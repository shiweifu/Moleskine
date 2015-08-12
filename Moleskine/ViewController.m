//
//  ViewController.m
//  Moleskine
//
//  Created by shiweifu on 8/4/15.
//  Copyright (c) 2015 shiweifu. All rights reserved.
//

#import "ViewController.h"
#import "MKTextView.h"
#import "MKMarkdownController.h"
#import "MKPreviewController.h"

@interface ViewController ()

@property (strong, nonatomic) MKTextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
//  _textView = [[MKTextView alloc] initWithFrame:self.view.bounds];
//  [self.view addSubview:_textView];
  UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
  [btn setTitle:@"Test"
       forState:UIControlStateNormal];
  [btn setTitleColor:[UIColor blueColor]
            forState:UIControlStateNormal];
  [self.view addSubview:btn];
  [btn sizeToFit];
  [btn setCenter:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2)];
  [btn addTarget:self
          action:@selector(onClick:)
forControlEvents:UIControlEventTouchUpInside];
}

- (void)onClick:(id)onClick
{
  NSString *filePath = [[NSBundle mainBundle] pathForResource:@"syntax" ofType:@"md"];
  NSString *content  = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];

  content = [content stringByReplacingOccurrencesOfString:@"\r" withString:@""];

  MKMarkdownController *controller = [MKMarkdownController new];
  controller.defaultMarkdownText   = content;
  controller.onComplete = ^(UIViewController *c)
  {
    MKPreviewController *pc = (MKPreviewController *) c;
    NSLog(@"%@", pc.bodyMarkdown);
    [c dismissViewControllerAnimated:YES completion:nil];
  };
  UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
  [self presentViewController:nav
                     animated:YES
                   completion:nil];
}

@end
