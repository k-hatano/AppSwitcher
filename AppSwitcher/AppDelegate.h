//
//  AppDelegate.h
//  AppSwitcher
//
//  Created by kenta on 2014/11/27.
//  Copyright (c) 2014年 nita. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    IBOutlet NSArrayController *arrayController;
    IBOutlet NSTableView *table;
    IBOutlet NSWindow *window;
}

- (void)updateApplicationsList;

- (void)heartbeat:(NSThread*)thread;
- (IBAction)switchApplication:(id)sender;

@end

