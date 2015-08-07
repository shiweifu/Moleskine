//
// Created by shiweifu on 8/7/15.
// Copyright (c) 2015 shiweifu. All rights reserved.
//

#import "MKMarkdownStrongBlockHighlighter.h"


@implementation MKMarkdownStrongBlockHighlighter
{
}

- (NSRegularExpression *)regularExpression
{
  return [MKRegularExpressionHighlighter regexFromPattern:@"(\\*\\*|__)(?=\\S)(?:.+?[*_]*)(?<=\\S)\\1"];
}

- (NSDictionary *)attributes
{
  return @{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]};
}

@end
