//
//  XQuit.h
//  XQuit
//
//  Created by Stefan Lage on 16/09/15.
//  Copyright (c) 2015 Stefan Lage. All rights reserved.
//

#import <AppKit/AppKit.h>

@class XQuit;

static XQuit *sharedPlugin;

@interface XQuit : NSObject

+ (instancetype)sharedPlugin;
- (id)initWithBundle:(NSBundle *)plugin;

@property (nonatomic, strong, readonly) NSBundle* bundle;
@end