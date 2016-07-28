//
//  FeedsViewController.h
//  AudioBrowser
//
//  Created by Victor Wu on 3/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoundManager.h"
#import "AddFeedViewController.h"

@interface FeedsViewController : UITableViewController <UIActionSheetDelegate> {
	// Audio.
	SoundManager *soundManager;
	NSMutableArray *filePaths;
	NSMutableArray *reloadFlags;
	
	// TTS.
	NSMutableDictionary *speechData;	
	
	// RSS.
	// These mutable arrays have to be maintained rigorously in order to match the correct feed.
	NSMutableArray *feedsURLs;
	NSMutableArray *feedsNames;
	NSMutableArray *feedsSelected;
	NSMutableArray *feedsLastRefreshed;
	NSMutableArray *feedsSubtext;
	
	// Stories is changed on the fly, each time audio files need to be refreshed.
	NSMutableDictionary *stories;
	NSString *currentFeedName;
	BOOL inRSSElementOfInterest;	
	
	// Alert.
	UIAlertView *dataLoadingAlertView;

}

- (id)initWithSoundManager:(SoundManager *)theSoundManager;
- (void)updatePlayingSounds;

@end
