//
//  MKTextView.m
//  Moleskine
//
//  Created by shiweifu on 8/5/15.
//  Copyright (c) 2015 shiweifu. All rights reserved.
//

#import "MKTextView.h"
#import "MKHighlighterTextStorage.h"

@interface MKTextView()

@property (strong,nonatomic) MKHighlighterTextStorage *syntaxStorage;

@end


@implementation MKTextView

- (id)initWithFrame:(CGRect)frame {
  NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}];
  
  _syntaxStorage = [MKHighlighterTextStorage new];
  [_syntaxStorage appendAttributedString:attrString];
  
  CGRect newTextViewRect = frame;
  NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
  
  CGSize containerSize = CGSizeMake(newTextViewRect.size.width,  CGFLOAT_MAX);
  NSTextContainer *container = [[NSTextContainer alloc] initWithSize:containerSize];
  container.widthTracksTextView = YES;
  
  [layoutManager addTextContainer:container];
  [_syntaxStorage addLayoutManager:layoutManager];
  
  if (self = [super initWithFrame:frame textContainer:container]) {
    self.delegate = self;
//    self.inputAccessoryView = [RFKeyboardToolbar toolbarWithButtons:[self buttons]];
  }
  return self;
}

- (void)textViewDidChange:(UITextView *)textView {
//  [_syntaxStorage update];
}

@end
