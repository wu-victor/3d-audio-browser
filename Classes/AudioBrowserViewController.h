//
//  AudioBrowserViewController.h
//  AudioBrowser
//
//  Created by Victor Wu on 3/5/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioBrowserView.h"
#import "FeedsViewController.h"
#import "SoundManager.h"

@interface AudioBrowserViewController : UIViewController {
	CGFloat dot1x, dot1y;
	CGFloat baseDot1x, baseDot1y;	
	
	// Current location in 3D audio space.
	CGFloat locationX;
	CGFloat locationY;
	CGFloat locationZ;

	CGFloat soundWall; 
	
	IBOutlet UILabel *listenerLocationRightLabel;
	IBOutlet UILabel *listenerLocationForwardLabel;
	IBOutlet UILabel *listenerLocationUpLabel;
	
	SoundManager *soundManager;
	
	// FeedsViewController.
	FeedsViewController *feedsViewController;
}

- (IBAction)selectAbout;


@end

