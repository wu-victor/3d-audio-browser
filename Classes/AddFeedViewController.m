//
//  AddFeedViewController.m
//  AudioBrowser
//
//  Created by Victor Wu on 3/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AddFeedViewController.h"

@implementation AddFeedViewController

@synthesize feedNameTextField, feedURLTextField;

- (id)initWithFeedsURLs:(NSMutableArray *)theFeedsURLs 
		 WithFeedsNames:(NSMutableArray *)theFeedsNames 
	  WithFeedsSelected:(NSMutableArray *)theFeedsSelected
 WithFeedsLastRefreshed:(NSMutableArray *)theFeedsLastRefreshed
	   WithFeedsSubtext:(NSMutableArray *)theFeedsSubtext 
		  WithFilePaths:(NSMutableArray *)theFilePaths 
		WithReloadFlags:(NSMutableArray *)theReloadFlags
{
		
	[self setTitle:@"Add feeds"];
	
	feedsURLs = theFeedsURLs;
	feedsNames = theFeedsNames;
	feedsSelected = theFeedsSelected;
	feedsLastRefreshed = theFeedsLastRefreshed;
	feedsSubtext = theFeedsSubtext;
	
	filePaths = theFilePaths;
	reloadFlags = theReloadFlags;

	return self;
}


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField { 
	[textField resignFirstResponder]; // Keyboard will leave.
	return YES; 
} 


- (IBAction)addFeed {
	NSLog(@"add feed in this controller.");
	
	NSString *feedName = [feedNameTextField text];
	NSString *feedURL = [[feedURLTextField text] lowercaseString];

	BOOL validEntry = YES;
	
	// Check length of strings.
	validEntry = [feedName length] == 0 ? NO : YES;
	if (validEntry) { validEntry = [feedURL length] == 0 ? NO : YES; }
	
	// Check if feedURL is a valid URL.
	if (validEntry) {
		NSURL *url = [[NSURL alloc] initWithString:feedURL];
		if (url == nil) { validEntry = NO; }	
		if (validEntry) {
			NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
			if (xmlParser == nil) { validEntry = NO; }
			if (![xmlParser parse]) { validEntry = NO; }		
			[xmlParser release];
		}
		[url release]; 
	}
	
	// Check if feedName or feedURL already exists.
	if (validEntry) {
		for (int i = 0; i < [feedsNames count] && validEntry; i++) {
			if ([[feedName lowercaseString] isEqualToString:[[feedsNames objectAtIndex:i] lowercaseString]]) { validEntry = NO; }
			if ([[feedURL lowercaseString] isEqualToString:[[feedsURLs objectAtIndex:i] lowercaseString]]) { validEntry = NO; }
		}
	}

	if (validEntry) {
		// Add need feed information to the appropriate NSMutableArrays.
		[feedsURLs addObject:feedURL];
		[feedsNames addObject:feedName];
		[feedsSelected addObject:[NSNumber numberWithUnsignedInt:0]];
		[feedsLastRefreshed addObject:[NSDate distantPast]];
		[feedsSubtext addObject:@""];
		
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);	
		NSString *documentsDirectory = [paths objectAtIndex:0];
		if (!documentsDirectory) { NSLog(@"Documents directory not found!"); }		

		[filePaths addObject:[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3", feedName]]];
		[reloadFlags addObject:[NSNumber numberWithUnsignedInt:0]];		
	}

	if (!validEntry) {
		UIAlertView *alertView = [[UIAlertView alloc]
				initWithTitle:@"Feed not added" message:@"Information is incorrect or feed already exists" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}
	
	[feedNameTextField setText:@""];
	[feedURLTextField setText:@""];
}

/*
NSMutableArray *feedsURLs;
NSMutableArray *feedsNames;
NSMutableArray *feedsSelected;
NSMutableArray *feedsLastRefreshed;
NSMutableArray *feedsSubtext;
*/
		
@end
