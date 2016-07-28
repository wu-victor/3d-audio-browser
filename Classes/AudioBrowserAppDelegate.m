//
//  AudioBrowserAppDelegate.m
//  AudioBrowser
//
//  Created by Victor Wu on 3/5/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "AudioBrowserAppDelegate.h"

@implementation AudioBrowserAppDelegate

@synthesize window;
@synthesize navigationController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
		
	
    // Override point for customization after app launch    
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
	
	// Prevent app from screen locking.
	UIApplication *thisApp = [UIApplication sharedApplication];
	thisApp.idleTimerDisabled = YES;
	
}

- (void)dealloc {
	[navigationController release];
    [window release];
    [super dealloc];
}


@end
