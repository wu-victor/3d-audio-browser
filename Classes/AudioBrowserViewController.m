//
//  AudioBrowserViewController.m
//  AudioBrowser
//
//  Created by Victor Wu on 3/5/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "AudioBrowserViewController.h"

@implementation AudioBrowserViewController

#pragma mark Initialization/cleanup.
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {  }
    return self;
}	

- (void)dealloc {
	[soundManager release];
	[feedsViewController release];
	[[UIAccelerometer sharedAccelerometer] setDelegate:nil];
    [super dealloc];
}

#pragma mark View.
/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];	
	
	soundManager = [[SoundManager alloc] init];
	locationX = 0;
	locationY = 0;
	locationZ = 0;
	soundWall = 1.1 * [soundManager soundSpaceRadius];
	
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"3D" style:UIBarButtonItemStyleBordered target:nil action:nil];
	[[self navigationItem] setBackBarButtonItem:backButton];
	[backButton release];
	
	
	feedsViewController = [[FeedsViewController alloc] initWithSoundManager:soundManager];
	[feedsViewController updatePlayingSounds];
	
}

- (void)viewWillAppear:(BOOL)animated {
	[[self navigationController] setNavigationBarHidden:YES];
	[(AudioBrowserView *)[self view] setDot1x:0];
	[(AudioBrowserView *)[self view] setDot1y:0];
	
	[[self view] becomeFirstResponder]; // For detecting shakes.
	[[self view] setNeedsDisplay];
	
	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [[self view] resignFirstResponder]; // For detecting shakes.
    [super viewWillDisappear:animated];
}


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
	
	NSLog(@"Memory warning in AudioBrowserViewController.m");
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)updateLocationLabels {
	// Convert iPhone's implied screen coordinate system to OpenAL coordinate system.
	int listenerLocationX = (int)locationX;
	int listenerLocationY = (int)-locationZ;
	int listenerLocationZ = (int)locationY;
	
	[listenerLocationRightLabel setText:[NSString stringWithFormat:@"%d", listenerLocationX]];
	[listenerLocationForwardLabel setText:[NSString stringWithFormat:@"%d", -listenerLocationZ]];
	[listenerLocationUpLabel setText:[NSString stringWithFormat:@"%d", listenerLocationY]];
}

#pragma mark Multitouch and shake detection.
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSArray *touchesArray = [[event allTouches] allObjects];
	CGPoint location1 = [[touchesArray objectAtIndex:0] locationInView:[self view]];
	dot1x = location1.x;	dot1y =location1.y;
	baseDot1x = dot1x;		baseDot1y = dot1y;
		
	[(AudioBrowserView *)[self view] setDot1x:dot1x];
	[(AudioBrowserView *)[self view] setDot1y:dot1y];
	[[self view] setNeedsDisplay];	
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	NSArray *touchesArray = [[event allTouches] allObjects];
	CGPoint location1 = [[touchesArray objectAtIndex:0] locationInView:[self view]];
	dot1x = location1.x;	dot1y = location1.y;	
	
	// Update locationX and locationY.
	locationX += (dot1x - baseDot1x);	locationY += (dot1y - baseDot1y);
	if (locationX > soundWall) { locationX = soundWall; }
	if (locationX < -soundWall) { locationX = -soundWall; }
	if (locationY > soundWall) { locationY = soundWall; }
	if (locationY < -soundWall) { locationY = -soundWall; }
	
	baseDot1x = dot1x;	baseDot1y = dot1y;
	[self updateLocationLabels];
	
	// Convert iPhone's implied screen coordinate system to OpenAL coordinate system.
	double listenerLocationX = (double)locationX;
	double listenerLocationY = (double)-locationZ;
	double listenerLocationZ = (double)locationY;
	NSArray *listenerLocation = [[NSArray alloc] initWithObjects:
								 [NSNumber numberWithDouble:listenerLocationX], 
								 [NSNumber numberWithDouble:listenerLocationY], 
								 [NSNumber numberWithDouble:listenerLocationZ], nil];
	[soundManager setListenerLocation:listenerLocation];
	[listenerLocation release];
	
	[(AudioBrowserView *)[self view] setDot1x:dot1x];
	[(AudioBrowserView *)[self view] setDot1y:dot1y];
	[[self view] setNeedsDisplay];	
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event { 
	dot1x = 0;	dot1y = 0;
	baseDot1x = 0;	baseDot1y = 0;
	
	NSLog(@"tapcount is %d", [[touches anyObject] tapCount]);
	
	int numberOfTaps = [[touches anyObject] tapCount]; // Move faster as you tap more consecutively.  (i.e. this value is cumulative.)
	
	if (numberOfTaps > 0) { 
		// Check if on top half or bottom half of screen.
		NSArray *touchesArray = [[event allTouches] allObjects];
		CGPoint location1 = [[touchesArray objectAtIndex:0] locationInView:[self view]];
		locationZ += (location1.y >=230 ? +numberOfTaps : -numberOfTaps);
		if (locationZ > soundWall) { locationZ = soundWall; }
		if (locationZ < -soundWall) { locationZ = -soundWall; }

		// Convert iPhone's implied screen coordinate system to OpenAL coordinate system.
		double listenerLocationX = (double)locationX;
		double listenerLocationY = (double)-locationZ;
		double listenerLocationZ = (double)locationY;
		NSArray *listenerLocation = [[NSArray alloc] initWithObjects:
									 [NSNumber numberWithDouble:listenerLocationX], 
									 [NSNumber numberWithDouble:listenerLocationY], 
									 [NSNumber numberWithDouble:listenerLocationZ], nil];
		[soundManager setListenerLocation:listenerLocation];
		[listenerLocation release];
	}
	
	[self updateLocationLabels];
	
	// Delete the dot just drawn.
	[(AudioBrowserView *)[self view] setDot1x:dot1x];
	[(AudioBrowserView *)[self view] setDot1y:dot1y];
	[[self view] setNeedsDisplay];	
	
	if ( [[event allTouches] count] >= 2 ) { // Go into the feeds menu if multitouch.
		[[self navigationController] setNavigationBarHidden:NO animated:YES];
		[[self navigationController] pushViewController:feedsViewController animated:YES];		
	}
} 

- (IBAction)selectAbout {

	UIAlertView *alertView = [[UIAlertView alloc]
							  initWithTitle:@"About" 
							  message:@"3D Audio RSS/Music Player\nVersion 1.0 Apr. 2010\n\nBy Victor Wu"
							  delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	// Reset user location.
	locationX = 0;
	locationY = 0;
	locationZ = 0;
	[self updateLocationLabels];
	double listenerLocationX = 0;
	double listenerLocationY = 0;
	double listenerLocationZ = 0;
	NSArray *listenerLocation = [[NSArray alloc] initWithObjects:
								 [NSNumber numberWithDouble:listenerLocationX], 
								 [NSNumber numberWithDouble:listenerLocationY], 
								 [NSNumber numberWithDouble:listenerLocationZ], nil];
	[soundManager setListenerLocation:listenerLocation];
	[listenerLocation release];
}

@end
