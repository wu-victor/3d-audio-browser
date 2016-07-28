//
//  AddFeedViewController.h
//  AudioBrowser
//
//  Created by Victor Wu on 3/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddFeedViewController : UIViewController <UITextFieldDelegate> {

	NSMutableArray *feedsURLs;
	NSMutableArray *feedsNames;
	NSMutableArray *feedsSelected;
	NSMutableArray *feedsLastRefreshed;
	NSMutableArray *feedsSubtext;
	
	NSMutableArray *filePaths;
	NSMutableArray *reloadFlags;

	
	IBOutlet UITextField *feedNameTextField;
	IBOutlet UITextField *feedURLTextField;
}

@property(nonatomic, retain) IBOutlet UITextField *feedNameTextField;
@property(nonatomic, retain) IBOutlet UITextField *feedURLTextField;

- (id)initWithFeedsURLs:(NSMutableArray *)theFeedsURLs 
		 WithFeedsNames:(NSMutableArray *)theFeedsNames 
	  WithFeedsSelected:(NSMutableArray *)theFeedsSelected
 WithFeedsLastRefreshed:(NSMutableArray *)theFeedsLastRefreshed
	   WithFeedsSubtext:(NSMutableArray *)theFeedsSubtext
		  WithFilePaths:(NSMutableArray *)theFilePaths 
		WithReloadFlags:(NSMutableArray *)theReloadFlags;

- (IBAction)addFeed;

@end
