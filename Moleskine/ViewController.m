//
//  ViewController.m
//  Moleskine
//
//  Created by shiweifu on 8/4/15.
//  Copyright (c) 2015 shiweifu. All rights reserved.
//

#import "ViewController.h"
#import "MKTextView.h"

@interface ViewController ()

@property (strong, nonatomic) MKTextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  _textView = [[MKTextView alloc] initWithFrame:self.view.bounds];
  [self.view addSubview:_textView];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
