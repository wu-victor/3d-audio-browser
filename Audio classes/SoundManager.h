//
//  SoundManager.h
//  3DAudioRFIDPoster
//
//  Created by Victor Wu on 2/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenAL/al.h>
#import <OpenAL/alc.h>

#import "Sound.h"

#define MINIMUM_SOUND_SOURCE_DISTANCE 1.0
#define SOUND_SPACE_RADIUS 100
//#define DISTANCE_SCALING_FACTOR 10.0

@interface SoundManager : NSObject {	
	ALCdevice *device;
	ALCcontext *context;
	
	NSMutableDictionary *playingSounds;
	
	int soundSpaceRadius;
}

@property (readonly) int soundSpaceRadius;

- (void)updatePlayingSoundsWithFilePaths:(NSArray *)filePaths withFeedsSelected:(NSArray *)feedsSelected withReloadFlags:(NSArray *)reloadFlags;

- (void)setListenerLocation:(NSArray *)location;

@end

