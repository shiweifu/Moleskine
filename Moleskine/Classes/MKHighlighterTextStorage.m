//
// Created by shiweifu on 8/5/15.
// Copyright (c) 2015 shiweifu. All rights reserved.
//

#import "MKHighlighterTextStorage.h"
#import "MKHighlighterType.h"
#import "MKMarkdownHeaderHighlighter.h"

@interface MKHighlighterTextStorage ()

@property (nonatomic, readwrite) NSMutableAttributedString *backingStore;
@property (nonatomic, strong) NSDictionary   *attributeDictionary;
@property (nonatomic, strong) NSDictionary   *defaultAttributes;
@property (nonatomic, strong) NSDictionary   *bodyFont;
@property (nonatomic, strong) NSMutableArray *highlighters;

@end


@implementation MKHighlighterTextStorage
{
}

-(id)init
{
  self = [super init];
  if (self)
  {
    _backingStore = [NSMutableAttributedString new];
    _bodyFont = @{NSFontAttributeName:[UIFont systemFontOfSize:12],
            NSUnderlineStyleAttributeName:[NSNumber numberWithInt:NSUnderlineStyleNone]};
    MKMarkdownHeaderHighlighter *highlighter = [[MKMarkdownHeaderHighlighter alloc] init];
    [self addHighlighter:highlighter];
  }
  return self;
}

- (void)addHighlighter:(id<MKHighlighterTypeProtocol>)highlighter
{
  [self.highlighters addObject:highlighter];
  [self editedAll:NSTextStorageEditedAttributes];
}

- (NSDictionary *)defaultAttributes
{
  if(!_defaultAttributes)
  {
    _defaultAttributes = @{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody],};
  }
  return _defaultAttributes;
}

- (NSString *)string
{
  return _backingStore.string;
}

- (NSMutableArray *)highlighters
{
  if(!_highlighters)
  {
    _highlighters = [@[] mutableCopy];
  }
  return _highlighters;
}


- (NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range;
{
  return [_backingStore attributesAtIndex:location
                           effectiveRange:range];
}

- (void)replaceCharactersInRange:(NSRange)range withAttributedString:(NSAttributedString *)str;
{
  [self beginEditing];
  [self.backingStore replaceCharactersInRange:range
                         withAttributedString:str];
  [self edited:NSTextStorageEditedCharacters | NSTextStorageEditedAttributes
         range:range
changeInLength:str.length - range.length];

  [self endEditing];
}

- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range;
{
  [self beginEditing];
  [_backingStore setAttributes:attrs range:range];
  [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
  [self endEditing];
}

- (void)processEditing {
//  [self performReplacementsForRange:self.editedRange];
  NSRange r = NSMakeRange(0, self.string.length);
  [self highlightRange:r];
  [super processEditing];
}

-(void)editedAll:(NSTextStorageEditActions) actions
{
  [self edited:actions
         range:NSMakeRange(0, self.backingStore.length)
changeInLength:0];

}

- (void)highlightRange:(NSRange)range
{
  [self.backingStore beginEditing];
//      实施高亮之前，首先恢复默认配色
  [self setAttributes:self.defaultAttributes
                range:range];

  NSMutableAttributedString *attrString = [[self.backingStore attributedSubstringFromRange:range] mutableCopy];

  for (int i = 0; i < self.highlighters.count; ++i)
  {
    id<MKHighlighterTypeProtocol> highlighter = self.highlighters[i];
    [highlighter highlightAttributedString:attrString];
  }

  [self replaceCharactersInRange:range
            withAttributedString:attrString];
  [self.backingStore endEditing];
}

- (void)performReplacementsForRange:(NSRange)changedRange {
  NSRange extendedRange = NSUnionRange(changedRange, [[self.backingStore string] lineRangeForRange:NSMakeRange(changedRange.location, 0)]);
  extendedRange = NSUnionRange(changedRange, [[self.backingStore string] lineRangeForRange:NSMakeRange(NSMaxRange(changedRange), 0)]);
  
  NSLog(@"extendedRange: %@", NSStringFromRange(extendedRange));
  [self applyStylesToRange:extendedRange];
}


- (void)createHighlightPatterns {
  NSDictionary *boldAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:12]};
  NSDictionary *italicAttributes = @{NSFontAttributeName:[UIFont italicSystemFontOfSize:12]};
  NSDictionary *boldItalicAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:11.5]};

  NSDictionary *codeAttributes = @{NSForegroundColorAttributeName:[UIColor grayColor]};

  /*
   NSDictionary *headerOneAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]};
   NSDictionary *headerTwoAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:13]};
   NSDictionary *headerThreeAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:12.5]};

   Alternate H1 with underline:

   NSDictionary *headerOneAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],NSUnderlineStyleAttributeName:[NSNumber numberWithInt:NSUnderlineStyleSingle], NSUnderlineColorAttributeName:[UIColor colorWithWhite:0.933 alpha:1.0]};

   Headers need to be worked on...

   @"(\\#\\w+(\\s\\w+)*\n)":headerOneAttributes,
   @"(\\##\\w+(\\s\\w+)*\n)":headerTwoAttributes,
   @"(\\###\\w+(\\s\\w+)*\n)":headerThreeAttributes

   */

  NSDictionary *linkAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:0.255 green:0.514 blue:0.769 alpha:1.00]};

  _attributeDictionary = @{
          @"[a-zA-Z0-9\t\n ./<>?;:\\\"'`!@#$%^&*()[]{}_+=|\\-]":_bodyFont,
          @"\\**(?:^|[^*])(\\*\\*(\\w+(\\s\\w+)*)\\*\\*)":boldAttributes,
          @"\\**(?:^|[^*])(\\*(\\w+(\\s\\w+)*)\\*)":italicAttributes,
          @"(\\*\\*\\*\\w+(\\s\\w+)*\\*\\*\\*)":boldItalicAttributes,
          @"(`\\w+(\\s\\w+)*`)":codeAttributes,
          @"(```\n([\\s\n\\d\\w[/[\\.,-\\/#!?@$%\\^&\\*;:|{}<>+=\\-'_~()\\\"\\[\\]\\\\]/]]*)\n```)":codeAttributes,
          @"(\\[\\w+(\\s\\w+)*\\]\\(\\w+\\w[/[\\.,-\\/#!?@$%\\^&\\*;:|{}<>+=\\-'_~()\\\"\\[\\]\\\\]/ \\w+]*\\))":linkAttributes
  };
}

- (void)update {
  [self createHighlightPatterns];

  [self addAttributes:_bodyFont range:NSMakeRange(0, self.length)];

  [self applyStylesToRange:NSMakeRange(0, self.length)];
}

- (void)applyStylesToRange:(NSRange)searchRange {
  for (NSString *key in _attributeDictionary) {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:key options:0 error:nil];

    NSDictionary *attributes = _attributeDictionary[key];

    [regex enumerateMatchesInString:[self.backingStore string] options:0 range:searchRange
                         usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop) {
                           NSRange matchRange = [match rangeAtIndex:1];
                           [self addAttributes:attributes range:matchRange];

                           if (NSMaxRange(matchRange)+1 < self.length) {
                             [self addAttributes:_bodyFont range:NSMakeRange(NSMaxRange(matchRange)+1, 1)];
                           }
                         }];
  }
}


@end