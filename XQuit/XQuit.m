//
//  XQuit.m
//  XQuit
//
//  Created by Stefan Lage on 16/09/15.
//  Copyright (c) 2015 Stefan Lage. All rights reserved.
//

#import "XQuit.h"

static NSString * const quitXcodeTitle   = @"Quit Xcode";
static NSString * const quitXcodeMessage = @"Are you sure you want to exit Xcode ?";
static NSString * const applicationTitle = @"Xcode";
static NSString * const menuTitle        = @"Xcode";
static NSString * const itemTitle        = @"Quit Xcode";
static NSString * const positiveButton   = @"Yes";
static NSString * const negativeButton   = @"Cancel";

@interface XQuit()

@property (nonatomic, strong, readwrite) NSBundle *bundle;
@end

@implementation XQuit

+ (instancetype)sharedPlugin
{
    return sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)plugin
{
    if (self = [super init]) {
        // reference to plugin's bundle, for resource access
        self.bundle = plugin;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didApplicationFinishLaunchingNotification:)
                                                     name:NSApplicationDidFinishLaunchingNotification
                                                   object:nil];
    }
    return self;
}

- (void)didApplicationFinishLaunchingNotification:(NSNotification*)noti
{
    //removeObserver
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidFinishLaunchingNotification object:nil];

    // Get Xcode menu items
    NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:menuTitle];
    if(menuItem){
        // Iterate through items to find the one to quit the Xcode
        for(NSMenuItem *item in [[menuItem submenu]itemArray]){
            if([item.title isEqualToString:itemTitle]
               || [item.title containsString:@"Close"]){
                // Redefine behavior's method & listener
                [item setAction:@selector(askBeforeQuitting)];
                [item setTarget:self];
            }
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Internal method

/**
 *  Make an NSAlert with the title and message passed in args and show it
 *
 *  @param title
 *  @param message
 *
 *  @return NSAlert's result
 */
-(NSInteger)showAlertBeforeActionWithTitle:(NSString*)title message:(NSString*)message{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:positiveButton];
    [alert addButtonWithTitle:negativeButton];
    [alert setMessageText:title];
    [alert setInformativeText:message];
    [alert setAlertStyle:NSWarningAlertStyle];
    return [alert runModal];
}

/**
 *  Show an alert asking to exit or not Xcode
 *  Quit Xcode or Not depending on the answer
 */
-(void) askBeforeQuitting{
    NSInteger result = [self showAlertBeforeActionWithTitle:quitXcodeTitle
                                                    message:quitXcodeMessage];
    
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
