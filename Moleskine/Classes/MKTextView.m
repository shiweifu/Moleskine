//
//  MKTextView.m
//  Moleskine
//
//  Created by shiweifu on 8/5/15.
//  Copyright (c) 2015 shiweifu. All rights reserved.
//

#import "MKTextView.h"
#import "MKHighlighterTextStorage.h"
#import "MKKeyboardToolBar.h"

@interface MKTextView()

@property (strong, nonatomic) MKHighlighterTextStorage *syntaxStorage;
@property (strong, nonatomic) NSArray *images;

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
    self.inputAccessoryView = self.toolBar;
    self.toolBar.backgroundColor = [UIColor colorWithRed:209 / 255.0f
                                                   green:213 / 255.0f
                                                    blue:219 / 255.0f
                                                   alpha:1.0f];
  }
  return self;
}

- (MKKeyboardToolBar *)toolBar
{
  if(!_toolBar)
  {
    _toolBar = [[MKKeyboardToolBar alloc] initWithDataSource:self];
    _toolBar.inset = 12;
    [_toolBar reloadData];
  }
  return _toolBar;
}

- (void)textViewDidChange:(UITextView *)textView {
}

#pragma mark - toolbar dataSource

- (NSUInteger)numbersOfToolButton
{
  return self.images.count;
}

- (UIView *)viewWithIndex:(NSUInteger)index
{
  UIImage  *img = [UIImage imageNamed:self.images[index]];
  UIButton *btn = [self createButtonWithImage:img];
  return btn;
}

- (void)viewDidTapFromIndex:(NSUInteger)index
{

}

#pragma mark - Utils

- (UIButton *)createButtonWithImage:(UIImage *)image
{
  UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
  [btn setFrame:CGRectMake(0, 0, 32, 32)];
  [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
  [btn setImage:image
       forState:UIControlStateNormal];

  btn.backgroundColor = [UIColor whiteColor];

  btn.layer.cornerRadius = 5.0f;
  btn.layer.borderWidth  = 1.0f;
  btn.layer.borderColor  = [UIColor whiteColor].CGColor;

  //设置下阴影
  CALayer *line     = [[CALayer alloc] init];
  line.borderWidth  = 1.0f;
  line.cornerRadius = 5.0f;

  line.borderColor = [UIColor colorWithRed:0.52 green:0.52 blue:0.53 alpha:1.0].CGColor;
  [line setFrame:CGRectMake(0,0, btn.layer.bounds.size.width, btn.layer.bounds.size.height+1)];
  [btn.layer addSublayer:line];

  return btn;
}

-(NSArray *)images
{
  if(!_images)
  {
    _images = @[@"bold", @"italic", @"link", @"quote", @"code", @"img", @"ol", @"title", @"hr"];
  }
  return _images;
}

@end
