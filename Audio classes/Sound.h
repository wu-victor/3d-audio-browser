//
//  Sound.h
//  3DAudioRFIDPoster
//
//  Created by Victor Wu on 2/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenAL/al.h>
#import <OpenAL/alc.h>

#import "AppleOpenALSupport.h"
#import "SoundManager.h"

@interface Sound : NSObject {
	ALuint	bufferID;		
	ALvoid	*data;
	ALuint	sourceID;	
}

- (id)initWithFileURL:(CFURLRef)fileURL;
- (void)setLocation:(NSArray *)location;
- (void)play;

@end

