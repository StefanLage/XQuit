//
//  XQuit.m
//  XQuit
//
//  Created by Stefan Lage on 05/08/14.
//    Copyright (c) 2014 StefanLage. All rights reserved.
//

#import "XQuit.h"

static XQuit *sharedPlugin;
static NSString * const messageText         = @"Xcode exit";
static NSString * const informativeText     = @"Are you sure you want to exit Xcode ?";
static NSString * const applicationTitle    = @"Xcode";
static NSString * const menuTitle           = @"Xcode";
static NSString * const itemTitle           = @"Quit Xcode";
static NSString * const positiveButton      = @"Yes";
static NSString * const negativeButton      = @"Cancel";

@interface XQuit()

@property (nonatomic, strong) NSBundle *bundle;
@end

@implementation XQuit

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:applicationTitle]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[self alloc] initWithBundle:plugin];
        });
    }
}

- (id)initWithBundle:(NSBundle *)plugin
{
    if (self = [super init]) {
        // reference to plugin's bundle, for resource acccess
        self.bundle = plugin;
        
        NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:menuTitle];
        if(menuItem){
            // Iterate through items to find the one to quit the Xcode
            for(NSMenuItem *item in [[menuItem submenu]itemArray]){
                if([item.title isEqualToString:itemTitle]){
                    // Redefine behavior's method & listener
                    [item setAction:@selector(askForQuitting)];
                    [item setTarget:self];
                }
            }
        }
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// Show an alert asking to exit or not Xcode
-(void) askForQuitting{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:positiveButton];
    [alert addButtonWithTitle:negativeButton];
    [alert setMessageText:messageText];
    [alert setInformativeText:informativeText];
    [alert setAlertStyle:NSWarningAlertStyle];
    NSInteger result = [alert runModal];
    
    if (result == NSAlertFirstButtonReturn) {
        // Click on YES
        @try {
            // Quit properly Xcode
            [[NSApplication sharedApplication] terminate:self];
        }
        @catch (NSException *exception) {
            // Something went wrong -> force to exit
            exit(0);
        }
    }
}

@end