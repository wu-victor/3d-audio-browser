//
//  SoundManager.m
//  3DAudioRFIDPoster
//
//  Created by Victor Wu on 2/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SoundManager.h"

#define PI 3.14159265	

@implementation SoundManager

@synthesize soundSpaceRadius;

#pragma mark Initialization/deallocation.
- (id)init {
	[super init];
	
	// Initialization of openAL.
	device = alcOpenDevice(NULL); // Select default device.
	if (!device) { NSLog(@"Error initializing the device."); }
	context = alcCreateContext(device, NULL); // Use the device to create a context.
	if(!context) { NSLog(@"Error creating a context."); }
	alcMakeContextCurrent(context); // Set the context to be currently active.
	
	// Create a mutable dictionary to store the currently playing sounds.
	playingSounds = [[NSMutableDictionary alloc] init];

	soundSpaceRadius = SOUND_SPACE_RADIUS;
	
	return self;
}

- (void)dealloc {
	alcDestroyContext(context); // Release the context.
	alcCloseDevice(device); // Close the device.
	
	[playingSounds release];
	[super dealloc]; 
	
	return;
}

#pragma mark Sound playing.
- (void)updatePlayingSoundsWithFilePaths:(NSArray *)filePaths withFeedsSelected:(NSArray *)feedsSelected withReloadFlags:(NSArray *)reloadFlags {
	double radius = soundSpaceRadius;
	NSArray *location1 = [NSArray arrayWithObjects:
						  [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:-radius], nil];
	NSArray *location2 = [NSArray arrayWithObjects:
						  [NSNumber numberWithDouble:-radius], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:0], nil];
	NSArray *location3 = [NSArray arrayWithObjects:
						  [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:+radius], nil];
	NSArray *location4 = [NSArray arrayWithObjects:
						  [NSNumber numberWithDouble:+radius], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:0], nil];
	NSArray *location5 = [NSArray arrayWithObjects:
						  [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:+radius], [NSNumber numberWithDouble:0], nil];
	NSArray *location6 = [NSArray arrayWithObjects:
						  [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:-radius], [NSNumber numberWithDouble:0], nil];
	NSArray *locations = [NSArray arrayWithObjects:location1, location2, location3, location4, location5, location6, nil];
	
	int count = -1;
	for (int i = 0; i < [filePaths count]; i++) {
		NSLog(@"Updating sound for %@", [filePaths objectAtIndex:i]);
		if ([[feedsSelected objectAtIndex:i] unsignedIntValue] == 0) { // Feed not selected.
			NSLog(@"Feed not selected.");
			[playingSounds removeObjectForKey:[filePaths objectAtIndex:i]]; // Stop and release the sound, if it is playing.
		} else { // Feed selected.  Try to play it.
			NSLog(@"Feed selected.");
			BOOL reload = NO;			
			if ([[reloadFlags objectAtIndex:i] unsignedIntValue] == 1) { reload = YES; }
			if ([playingSounds objectForKey:[filePaths objectAtIndex:i]] == nil) { reload = YES; } // Sound doesn't exist yet.  So must load it.
			NSLog(@"Reload is YES? %d", reload);
			if (reload) { // Try to create the sound and play it.
				NSURL *nsFileURL = [[NSURL fileURLWithPath:[filePaths objectAtIndex:i]] retain];
				NSString *checkFileExistence = [[NSString alloc] initWithContentsOfURL:nsFileURL];
				if (checkFileExistence == nil) { 
					NSLog(@"Sound file not found."); 
				} else {
					NSLog(@"Create sound.");
					CFURLRef fileURL = (CFURLRef)nsFileURL;
					Sound *sound = [[Sound alloc] initWithFileURL:fileURL];
					if (sound) { // Successfully created sound.
						[playingSounds removeObjectForKey:[filePaths objectAtIndex:i]];
						NSLog(@"Play the sound.");
						[sound play];
						[playingSounds setObject:sound forKey:[filePaths objectAtIndex:i]]; // Add sound to the mutable dictionary.
						[sound release]; // Ownership is given to playingSounds.
						NSLog(@"Sound ownership transferred.");						
					} else {
						NSLog(@"Could not create sound.");
					}
				}
				[checkFileExistence release];
			}			
			if ([playingSounds objectForKey:[filePaths objectAtIndex:i]]) { // If sound exists, relocate it.
				count++;
				[[playingSounds objectForKey:[filePaths objectAtIndex:i]] setLocation:[locations objectAtIndex:count]];			
			}
		}	
	}
	NSLog(@"Done updating sounds.");	
	return;
}

- (void)setListenerLocation:(NSArray *)location {	
	/***************************** Position the listener. ******************************/
	alGetError(); // Clear any previous error.
	ALenum error;
	ALfloat listenerPosition[] = { 
		[[location objectAtIndex:0] doubleValue], [[location objectAtIndex:1] doubleValue], [[location objectAtIndex:2] doubleValue] };
    alListenerfv(AL_POSITION, listenerPosition);
	if((error = alGetError()) != AL_NO_ERROR) { NSLog(@"Error positioning the listener."); }
}
@end
