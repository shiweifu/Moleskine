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

@interface MKTextView() <UIActionSheetDelegate, UIAlertViewDelegate>

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
  if(index == 0)
  {
    [self onBold];
  }
  else if(index == 1)
  {
    [self onItalic];
  }
  else if(index == 2)
  {
    [self onLink];
  }
  else if(index == 3)
  {
    [self onQuote];
  }
  else if(index == 4)
  {
    [self onCode];
  }
  else if(index == 5)
  {
    [self onImg];
  }
  else if(index == 6)
  {
    [self onOl];
  }
  else if(index == 7)
  {
    [self onTitle];
  }
  else if(index == 8)
  {
    [self onHR];
  }
}

#pragma mark - Event

- (void)onHR
{
  UITextView *textView = self;
  NSRange selectionRange = textView.selectedRange;
  if (textView.text.length == 0) {
    selectionRange.location += 4;
    [textView insertText:@"---\n"];
  } else {
    selectionRange.location += 5;
    [textView insertText:@"\n---\n"];
  }
  textView.selectedRange = selectionRange;
}

- (void)onTitle
{
  UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"标题"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:@"H1", @"H2", @"H3", @"H4", @"H5", @"H6", nil];

  [actionSheet showInView:self];
}

- (void)onOl
{
  UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"列表"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:@"有序列表", @"无序列表", nil];

  [actionSheet showInView:self];
}

- (void)onImg
{
  NSRange selectionRange = self.selectedRange;
  selectionRange.location += 2;

  [self insertText:@"![]()"];
  [self setSelectionRange:selectionRange];
}

- (void)onCode
{
  NSRange selectionRange = self.selectedRange;
  selectionRange.location += self.text.length == 0 ? 3 : 4;

  [self insertText: self.text.length == 0 ? @"```\n```" : @"\n```\n```"];
  [self setSelectionRange:selectionRange];
}

- (void)onQuote
{
  NSRange selectionRange = self.selectedRange;
  selectionRange.location += 3;

  [self insertText:self.text.length == 0 ? @"> " : @"\n> "];
  [self setSelectionRange:selectionRange];
}

- (void)onLink
{
  [self resignFirstResponder];
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"输入链接"
                                                      message:nil
                                                     delegate:self
                                            cancelButtonTitle:@"取消"
                                            otherButtonTitles:@"确定", nil];
  alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
  UITextField *titleTextField = [alertView textFieldAtIndex:0];
  UITextField *urlTextField   = [alertView textFieldAtIndex:1];

  [titleTextField setPlaceholder:@"输入标题"];
  [urlTextField   setPlaceholder:@"输入链接"];
  urlTextField.secureTextEntry = NO;
  [urlTextField setText:@"http://"];
//
  [alertView show];
}

- (void)onItalic
{
  NSRange selectionRange = self.selectedRange;
  [self insertText:@"*Italic*"];
  selectionRange.location += 1;
  selectionRange.length    = 6;
  [self setSelectionRange:selectionRange];
}

- (void)onBold
{
  NSRange selectionRange = self.selectedRange;
  [self insertText:@"**Bold**"];
  selectionRange.location += 2;
  selectionRange.length    = 4;
  [self setSelectionRange:selectionRange];
}

#pragma mark - ActionSheet delegate

- (void) actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex
{
  NSString *s = [actionSheet buttonTitleAtIndex:buttonIndex];
  NSLog(@"you click sheet by title: %@", s);
  UITextView *textView = self;
  NSRange selectionRange = textView.selectedRange;
  if([s isEqualToString:@"H1"])
  {
    if (textView.text.length == 0) {
      selectionRange.location += 2;
      [textView insertText:@"# "];
    } else {
      selectionRange.location += 3;
      [textView insertText:@"\n# "];
    }
    [textView insertText:@" #"];
    textView.selectedRange = selectionRange;
  }
  else if([s isEqualToString:@"H2"])
  {
    if (textView.text.length == 0) {
      selectionRange.location += 3;
      [textView insertText:@"## "];
    } else {
      selectionRange.location += 4;
      [textView insertText:@"\n## "];
    }
    [textView insertText:@" ##"];
    textView.selectedRange = selectionRange;
  }
  else if([s isEqualToString:@"H3"])
  {
    if (textView.text.length == 0) {
      selectionRange.location += 4;
      [textView insertText:@"### "];
    } else {
      selectionRange.location += 5;
      [textView insertText:@"\n### "];
    }
    [textView insertText:@" ###"];
    textView.selectedRange = selectionRange;
  }
  else if([s isEqualToString:@"H4"])
  {
    if (textView.text.length == 0) {
      selectionRange.location += 5;
      [textView insertText:@"#### "];
    } else {
      selectionRange.location += 6;
      [textView insertText:@"\n#### "];
    }
    [textView insertText:@" ####"];
    textView.selectedRange = selectionRange;
  }
  else if([s isEqualToString:@"H5"])
  {
    if (textView.text.length == 0) {
      selectionRange.location += 6;
      [textView insertText:@"##### "];
    } else {
      selectionRange.location += 7;
      [textView insertText:@"\n##### "];
    }
    [textView insertText:@" #####"];
    textView.selectedRange = selectionRange;
  }
  else if([s isEqualToString:@"H6"])
  {
    if (textView.text.length == 0) {
      selectionRange.location += 7;
      [textView insertText:@"###### "];
    } else {
      selectionRange.location += 8;
      [textView insertText:@"\n###### "];
    }
    [textView insertText:@" ######"];
    textView.selectedRange = selectionRange;
  }
  else if([s isEqualToString:@"有序列表"])
  {
    selectionRange.length = 4;
    if(textView.text.length == 0)
    {
      selectionRange.location += 3;
      [textView insertText:@"1. item\n2. \n3. \n"];
    }
    else
    {
      selectionRange.location += 4;
      [textView insertText:@"\n1. item\n2. \n3. \n"];
    }
    textView.selectedRange = selectionRange;
  }
  else if([s isEqualToString:@"无序列表"])
  {
    selectionRange.length = 4;
    if(textView.text.length == 0)
    {
      selectionRange.location += 2;
      [textView insertText:@"- item\n-item \n item "];
    }
    else
    {
      selectionRange.location += 3;
      [textView insertText:@"\n- item\n-item \n-item "];
    }
    [textView insertText:@""];
    textView.selectedRange = selectionRange;
  }
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

- (void)setSelectionRange:(NSRange)range {
  UIColor *previousTint = self.tintColor;

  self.tintColor = UIColor.clearColor;
  self.selectedRange = range;
  self.tintColor = previousTint;
}

-(NSArray *)images
{
  if(!_images)
  {
    _images = @[@"bold", @"italic", @"link", @"quote", @"code", @"img", @"ol", @"title", @"hr"];
  }
  return _images;
}

#pragma mark - alertView Delegate

- (void)   alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if(buttonIndex == 0)
  {
    return;
  }
  UITextField *titleTextField = [alertView textFieldAtIndex:0];
  UITextField *urlTextField   = [alertView textFieldAtIndex:1];

  NSString *s = [NSString stringWithFormat:@"[%@](%@)", titleTextField.text, urlTextField.text];
  [self insertText:s];
}

@end
