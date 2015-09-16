//
//  NSObject_Extension.m
//  XQuit
//
//  Created by Stefan Lage on 16/09/15.
//  Copyright (c) 2015 Stefan Lage. All rights reserved.
//


#import "NSObject_Extension.h"
#import "XQuit.h"

@implementation NSObject (Xcode_Plugin_Template_Extension)

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[XQuit alloc] initWithBundle:plugin];
        });
    }
}
@end
