//
//  MKTextView.h
//  Moleskine
//
//  Created by shiweifu on 8/5/15.
//  Copyright (c) 2015 shiweifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKKeyboardToolBar.h"

@class MKKeyboardToolBar;

@interface MKTextView : UITextView <UITextViewDelegate, MKKeyboardToolBarDataSource>

@property (nonatomic, strong) MKKeyboardToolBar *toolBar;

@end
