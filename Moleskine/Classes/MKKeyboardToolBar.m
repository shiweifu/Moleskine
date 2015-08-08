//
// Created by shiweifu on 8/7/15.
// Copyright (c) 2015 shiweifu. All rights reserved.
//

#import "MKKeyboardToolBar.h"

@interface MKKeyboardToolBar()

@property (nonatomic, strong) UIScrollView *insideView;
@property (nonatomic,strong)  UIView       *toolbarView;

@end

@implementation MKKeyboardToolBar
{

}

- (instancetype)initWithDataSource:(id<MKKeyboardToolBarDataSource>)dataSource {
  self = [super initWithFrame:CGRectMake(0, 0, self.window.rootViewController.view.bounds.size.width, 40)];
  if (self) {
    self.dataSource = dataSource;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self addSubview:[self inputAccessoryView]];
    [self initButtons];
  }
  return self;
}

- (void)initButtons
{
  if(self.dataSource)
  {
    CGRect originFrame;
    CGFloat originX = self.inset;
    for (int i = 0; i < self.dataSource.numbersOfToolButton; ++i)
    {
      UIView *v = [self.dataSource viewWithIndex:i];
      [self.insideView addSubview:v];
      CGFloat inset = self.inset;
      originFrame = CGRectMake(originX, 0, v.frame.size.width, v.frame.size.height);
      [v setFrame:originFrame];
      originX = originX + v.bounds.size.width + 8;
    }

    CGSize contentSize = self.insideView.contentSize;
    contentSize.width = originX - self.inset;
    self.insideView.contentSize = contentSize;
  }
}

- (NSUInteger)inset
{
  if(_inset <= 0)
  {
    _inset = 8;
  }
  return _inset;
}

-(UIScrollView *)insideView
{
  if(!_insideView)
  {
    _insideView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 40)];
    _insideView.backgroundColor = [UIColor clearColor];
    _insideView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _insideView.showsHorizontalScrollIndicator = NO;
    _insideView.contentInset = UIEdgeInsetsMake(6.0f, 0.0f, 8.0f, 6.0f);
  }
  return _insideView;
}

- (UIView *)inputAccessoryView {
  _toolbarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 40)];
  _toolbarView.backgroundColor = [UIColor colorWithWhite:0.973 alpha:1.0];
  _toolbarView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;

  [_toolbarView addSubview:[self insideView]];

  return _toolbarView;
}

@end
