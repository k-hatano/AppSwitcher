//
//  AppDelegate.m
//  AppSwitcher
//
//  Created by kenta on 2014/11/27.
//  Copyright (c) 2014年 nita. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self updateApplicationsList];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:NSApplicationDidBecomeActiveNotification
                                               object:nil];
    [NSThread detachNewThreadSelector:@selector(heartbeat:) toTarget:self withObject:nil];
}

- (void)heartbeat:(NSThread*)thread{
    while(YES){
        [self updateApplicationsList];
        [NSThread sleepForTimeInterval:1.0f];
    }
}

- (void)applicationDidBecomeActive:(NSNotification *)notification{
    NSLog(@"applicationDidBecomeActive");
    [self updateApplicationsList];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)updateApplicationsList{
    while([[arrayController arrangedObjects] count]>0){
        [arrayController removeObjectAtArrangedObjectIndex:0];
    }
    
    NSArray *apps = [[NSWorkspace sharedWorkspace] runningApplications];
    NSInteger selection = -1;
    
    NSInteger i = 0;
    
    for(NSRunningApplication *app in apps){
        if (app.activationPolicy != NSApplicationActivationPolicyRegular){
            continue;
        }
        if (app.ownsMenuBar){
            selection = i;
        }
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        [dict setObject:app.icon forKey:@"icon"];
        [dict setObject:app.localizedName forKey:@"name"];
        [dict setObject:app.bundleIdentifier forKey:@"bundleIdentifier"];
        
        [arrayController addObject:dict];
        i++;
    }
    
    /*
    if (selection >= 0){
        [arrayController setSelectionIndex:selection];
    }
     */
    
    [table reloadData];
    [arrayController setSelectionIndexes:[NSIndexSet indexSet]];
}

- (IBAction)switchApplication:(id)sender{
    NSArray *array = [arrayController selectedObjects];
    if (!array || [array count]<=0){
        [arrayController setSelectionIndexes:[NSIndexSet indexSet]];
        return;
    }
    
    NSDictionary *dict = [array objectAtIndex:0];
    if (!dict){
        [arrayController setSelectionIndexes:[NSIndexSet indexSet]];
        return;
    }
    
    NSRunningApplication *app = [[NSRunningApplication runningApplicationsWithBundleIdentifier:[dict objectForKey:@"bundleIdentifier"]] objectAtIndex:0];
    [app activateWithOptions:0];
    
    [arrayController setSelectionIndexes:[NSIndexSet indexSet]];
}

- (void)windowWillClose:(NSNotification *)notification{
    [[NSApplication sharedApplication] terminate:self];
}


@end
