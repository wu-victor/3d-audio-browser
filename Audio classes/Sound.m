//
//  Sound.m
//  3DAudioRFIDPoster
//
//  Created by Victor Wu on 2/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Sound.h"

@implementation Sound

#pragma mark Initialization/deallocation.
- (id)initWithFileURL:(CFURLRef)fileURL {
	[super init];
	
	alGetError(); // Clear any previous error.
	ALenum error;
	
	/***************************** Load audio data from the sound file. ******************************/
	ALsizei size, freq;
	ALenum format;
	ALdouble duration;
	data = MyGetOpenALAudioData(fileURL, &size, &format, &freq, &duration);
	if((error = alGetError()) != AL_NO_ERROR) { NSLog(@"Error loading data from file."); return nil; }
	CFRelease(fileURL);		
	if ((format == AL_FORMAT_STEREO8) || (format == AL_FORMAT_STEREO16)) { NSLog(@"Audio format in stereo.  Audio will not be played in 3D space."); return nil; }
	
	/***************************** Get a buffer ID from openAL. ******************************/
	alGenBuffers(1, &bufferID);
	if((error = alGetError()) != AL_NO_ERROR) { NSLog(@"Error getting a buffer ID."); return nil; }
	
	/***************************** Push audio data into the openAL buffer. ******************************/
	// Apple recommends using a function that crashes the program.  Refer to two links below.
	// http://developer.apple.com/iphone/library/technotes/tn2008/tn2199.html
	// http://forums.macrumors.com/showthread.php?t=848203 
	//alBufferDataStaticProc(bufferID, format, data, size, freq);
	alBufferData(bufferID, format, data, size, freq);
	if((error = alGetError()) != AL_NO_ERROR) { NSLog(@"Error pushing data into openAL buffer."); return nil; }
	
	/***************************** Get a source from openAL. ******************************/
	alGenSources(1, &sourceID);  
	if((error = alGetError()) != AL_NO_ERROR) { NSLog(@"Error getting a source."); return nil; }
	
	/***************************** Attach the openAL buffer to the source. ******************************/
	alSourcei(sourceID, AL_BUFFER, bufferID); // Attach.
	if((error = alGetError()) != AL_NO_ERROR) { NSLog(@"Error attaching the openAL buffer to the source."); return nil; }
	alSourcei(sourceID, AL_LOOPING, AL_TRUE); // Set source to loop.
	if((error = alGetError()) != AL_NO_ERROR) { NSLog(@"Error setting the source to loop."); return nil; }
	
	/***************************** Set the distance attenuation model for the source. ******************************/
	alDistanceModel(AL_INVERSE_DISTANCE_CLAMPED);
	alSourcef(sourceID, AL_REFERENCE_DISTANCE, MINIMUM_SOUND_SOURCE_DISTANCE); // Reference distance is 1 meter.  I.e. the source is at least 1 meter away from the listener.
	alSourcef(sourceID, AL_ROLLOFF_FACTOR, 0.25);
	if((error = alGetError()) != AL_NO_ERROR) { NSLog(@"Error setting the attenuation model."); return nil; }
	
	return self;
}

- (void)dealloc {
	// Clean up resources.
	alSourceStop(sourceID);
	alDeleteSources(1, &sourceID);
	alDeleteBuffers(1, &bufferID);	
	if(data) {
		free(data);
		data = NULL;
	}	
	[super dealloc];
}

#pragma mark Sound setup.
- (void)setLocation:(NSArray *)location {	
	/***************************** Position the sound source. ******************************/
	alGetError(); // Clear any previous error.
	ALenum error;
	ALfloat sourcePosition[] = {[[location objectAtIndex:0] doubleValue], [[location objectAtIndex:1] doubleValue], [[location objectAtIndex:2] doubleValue]};  
	alSourcefv(sourceID, AL_POSITION, sourcePosition);
	if((error = alGetError()) != AL_NO_ERROR) { NSLog(@"Error positioning the source."); }
}

#pragma mark Sound playing.
- (void)play {
	/***************************** Play the sound. ******************************/
	alGetError(); // Clear any previous error.
	ALenum error;
	alSourcePlay(sourceID);	
	if((error = alGetError()) != AL_NO_ERROR) { NSLog(@"Error playing the source."); }
}



@end
