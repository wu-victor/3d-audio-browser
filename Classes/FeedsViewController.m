//
//  FeedsViewController.m
//  AudioBrowser
//
//  Created by Victor Wu on 3/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FeedsViewController.h"
@implementation FeedsViewController

#pragma mark Initialization/cleanup.
- (id)initWithSoundManager:(SoundManager *)theSoundManager {
	[self setTitle:@"RSS feeds and music"];
	
	soundManager = theSoundManager;
	[soundManager retain];
	reloadFlags = [[NSMutableArray alloc] init];
	
	speechData = [[NSMutableDictionary alloc] init];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);	
	NSString *documentsDirectory = [paths objectAtIndex:0];
	if (!documentsDirectory) { NSLog(@"Documents directory not found!"); }		
	
	feedsURLs = [[NSMutableArray alloc] init];
	feedsNames = [[NSMutableArray alloc] init];
	feedsSelected = [[NSMutableArray alloc] init];
	feedsLastRefreshed = [[NSMutableArray alloc] init];
	feedsSubtext = [[NSMutableArray alloc] init];
	filePaths = [[NSMutableArray alloc] init];
		
	[feedsURLs addObject:@"http://news.google.com/news?ned=us&topic=h&output=rss"];
	[feedsNames addObject:@"Google Top News"];
	[feedsSelected addObject:[NSNumber numberWithUnsignedInt:0]];
	[feedsLastRefreshed addObject:[NSDate distantPast]];
	[feedsSubtext addObject:@""];
	[filePaths addObject:[documentsDirectory stringByAppendingPathComponent:@"Google Top News.mp3"]];
	[reloadFlags addObject:[NSNumber numberWithUnsignedInt:0]];

	[feedsURLs addObject:@"http://finance.yahoo.com/rss/usmarkets"];
	[feedsNames addObject:@"Yahoo! Finance U.S. Markets"];	
	[feedsSelected addObject:[NSNumber numberWithUnsignedInt:0]];
	[feedsLastRefreshed addObject:[NSDate distantPast]];
	[feedsSubtext addObject:@""];
	[filePaths addObject:[documentsDirectory stringByAppendingPathComponent:@"Yahoo! Finance U.S. Markets.mp3"]];
	[reloadFlags addObject:[NSNumber numberWithUnsignedInt:0]];
	
	[feedsURLs addObject:@"http://news.google.com/news?ned=us&topic=m&output=rss"];
	[feedsNames addObject:@"Google Health"];	
	[feedsSelected addObject:[NSNumber numberWithUnsignedInt:0]];
	[feedsLastRefreshed addObject:[NSDate distantPast]];
	[feedsSubtext addObject:@""];
	[filePaths addObject:[documentsDirectory stringByAppendingPathComponent:@"Google Health.mp3"]];
	[reloadFlags addObject:[NSNumber numberWithUnsignedInt:0]];
	
	[feedsURLs addObject:@"http://sports.espn.go.com/espn/rss/news"];
	[feedsNames addObject:@"ESPN"];
	[feedsSelected addObject:[NSNumber numberWithUnsignedInt:0]];
	[feedsLastRefreshed addObject:[NSDate distantPast]];
	[feedsSubtext addObject:@""];
	[filePaths addObject:[documentsDirectory stringByAppendingPathComponent:@"ESPN.mp3"]];
	[reloadFlags addObject:[NSNumber numberWithUnsignedInt:0]];
	
	[feedsURLs addObject:@"http://i.rottentomatoes.com/syndication/rss/top_news.xml"];
	[feedsNames addObject:@"Rotten Tomatoes"];
	[feedsSelected addObject:[NSNumber numberWithUnsignedInt:0]];
	[feedsLastRefreshed addObject:[NSDate distantPast]];
	[feedsSubtext addObject:@""];
	[filePaths addObject:[documentsDirectory stringByAppendingPathComponent:@"Rotten Tomatoes.mp3"]];
	[reloadFlags addObject:[NSNumber numberWithUnsignedInt:0]];
	
	[feedsURLs addObject:@"http://www.eonline.com/syndication/feeds/rssfeeds/topstories.xml"];
	[feedsNames addObject:@"E! Online"];
	[feedsSelected addObject:[NSNumber numberWithUnsignedInt:0]];
	[feedsLastRefreshed addObject:[NSDate distantPast]];
	[feedsSubtext addObject:@""];
	[filePaths addObject:[documentsDirectory stringByAppendingPathComponent:@"E! Online.mp3"]];
	[reloadFlags addObject:[NSNumber numberWithUnsignedInt:0]];
	
	[feedsURLs addObject:@"http://www.engadget.com/rss.xml"];
	[feedsNames addObject:@"Engadget"];
	[feedsSelected addObject:[NSNumber numberWithUnsignedInt:0]];
	[feedsLastRefreshed addObject:[NSDate distantPast]];
	[feedsSubtext addObject:@""];
	[filePaths addObject:[documentsDirectory stringByAppendingPathComponent:@"Engadget.mp3"]];
	[reloadFlags addObject:[NSNumber numberWithUnsignedInt:0]];

	[feedsURLs addObject:@"http://feeds.gawker.com/lifehacker/full"];
	[feedsNames addObject:@"Lifehacker"];
	[feedsSelected addObject:[NSNumber numberWithUnsignedInt:0]];
	[feedsLastRefreshed addObject:[NSDate distantPast]];
	[feedsSubtext addObject:@""];
	[filePaths addObject:[documentsDirectory stringByAppendingPathComponent:@"Lifehacker.mp3"]];
	[reloadFlags addObject:[NSNumber numberWithUnsignedInt:0]];
	
	[feedsURLs addObject:@"local"];
	[feedsNames addObject:@"Minuet"];	
	[feedsSelected addObject:[NSNumber numberWithUnsignedInt:1]]; // This is the default starting sound when the application launches.
	[feedsLastRefreshed addObject:[NSDate distantPast]];
	[feedsSubtext addObject:@"Johann Sebastian Bach"];	
	NSString *fileName = @"Minuet_Bach.mp3";
	NSString *path = [[NSBundle mainBundle] pathForResource:[fileName stringByDeletingPathExtension] ofType:[fileName pathExtension]];
	[filePaths addObject:path];
	[reloadFlags addObject:[NSNumber numberWithUnsignedInt:0]];

	[feedsURLs addObject:@"local"];
	[feedsNames addObject:@"Prelude in A Major"];	
	[feedsSelected addObject:[NSNumber numberWithUnsignedInt:0]];  
	[feedsLastRefreshed addObject:[NSDate distantPast]];
	[feedsSubtext addObject:@"Frédéric Chopin"];	
	fileName = @"Prelude_Chopin.mp3";
	path = [[NSBundle mainBundle] pathForResource:[fileName stringByDeletingPathExtension] ofType:[fileName pathExtension]];
	[filePaths addObject:path];
	[reloadFlags addObject:[NSNumber numberWithUnsignedInt:0]];

	[feedsURLs addObject:@"local"];
	[feedsNames addObject:@"Fantasia in D Minor"];	
	[feedsSelected addObject:[NSNumber numberWithUnsignedInt:0]];
	[feedsLastRefreshed addObject:[NSDate distantPast]];
	[feedsSubtext addObject:@"Wolfgang Amadeus Mozart"];	
	fileName = @"Fantasia_Mozart.mp3";
	path = [[NSBundle mainBundle] pathForResource:[fileName stringByDeletingPathExtension] ofType:[fileName pathExtension]];
	[filePaths addObject:path];
	[reloadFlags addObject:[NSNumber numberWithUnsignedInt:0]];	
	
	// Check if information already exists in disk.  If yes, replace with what's there.
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"feedsLastRefreshed.txt"];
	NSArray *feedsLastRefreshedData = [NSArray arrayWithContentsOfFile:filePath];
	if (feedsLastRefreshedData) {
		NSLog(@"Reading refresh times from file.");
		[feedsLastRefreshed release];
		feedsLastRefreshed = [[NSMutableArray alloc] initWithArray:feedsLastRefreshedData];
	}
	
	stories = [[NSMutableDictionary alloc] init];
	
	// Check array sizes.
	NSLog(@"feedsURLs has size %d", [feedsURLs count]);
	NSLog(@"feedsNames has size %d", [feedsNames count]);
	NSLog(@"feedsSelected has size %d", [feedsSelected count]);
	NSLog(@"feedsLastRefreshed has size %d", [feedsLastRefreshed count]);
	NSLog(@"feedsSubtext has size %d", [feedsSubtext count]);
	NSLog(@"filePaths has size %d", [filePaths count]);
	NSLog(@"reloadFlags has size %d", [reloadFlags count]);

	return self;
}

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/
- (void)dealloc {
    [super dealloc];
	[soundManager release];
	[filePaths release];
	[reloadFlags release];

	[speechData removeAllObjects];
	[speechData release];

	[feedsURLs removeAllObjects];
	[feedsURLs release];
	
	[feedsNames removeAllObjects];
	[feedsNames release];
	
	[feedsSelected removeAllObjects];
	[feedsSelected release];
	
	[feedsLastRefreshed removeAllObjects];
	[feedsLastRefreshed release];
	
	[feedsSubtext removeAllObjects];
	[feedsSubtext release];
	
	[stories removeAllObjects];
	[stories release];
}

#pragma mark Playing sounds.
- (void)updatePlayingSounds {
	[soundManager updatePlayingSoundsWithFilePaths:filePaths withFeedsSelected:feedsSelected withReloadFlags:reloadFlags];
}

#pragma mark TTS.
- (BOOL)retrieveSpeechData {
	for (int i = 0; i < [feedsURLs count]; i++) {
		[reloadFlags replaceObjectAtIndex:i withObject:[NSNumber numberWithUnsignedInt:0]]; // Don't reload audio file unless retrieved new speech data.
		
		NSTimeInterval intervalElapsed = - [[feedsLastRefreshed objectAtIndex:i] timeIntervalSinceNow]; // In seconds.
		NSTimeInterval MAX_UNREFRESH_INTERVAL = 900; // 15 minutes.
		// Check if the feed is selected and that the last refresh was a long time ago.  
		// If that is the case, then we need to retrieve the speech data.
		if ( ([[feedsSelected objectAtIndex:i] unsignedIntValue] == 1) && (intervalElapsed > MAX_UNREFRESH_INTERVAL) && 
			 (![[feedsURLs objectAtIndex:i] isEqualToString:@"local"]) ) {
			
			[speechData setObject:[[NSMutableData alloc] init] forKey:[feedsNames objectAtIndex:i]];
			
			// Chop up feed's stories and create a connection for each chopped piece.
			// Associate all chopped pieces with the same story.			
			NSString *storiesOfFeed = [stories objectForKey:[feedsNames objectAtIndex:i]];
			int storiesLength = [storiesOfFeed length];
			int MAX_TTS_LENGTH = 80;  // Being conservative.  It's 100 from last check.
			NSRange range; range.location = -1000; range.length = 1000; // Dummy values to initialize.
			BOOL done = NO;
			while (!done) {
				// Update the range.
				range.location = range.location + range.length;
				if (range.location + MAX_TTS_LENGTH >= storiesLength) {
					range.length = storiesLength - range.location;
					done = YES;
				} else {
					range.length = MAX_TTS_LENGTH;
				}
				// Move back the length of the range until not in the middle of a word.
				BOOL inMiddleOfWord = YES;
				do {
					NSRange middleRange; middleRange.location = range.location+range.length-1; middleRange.length = 1;
					if ([[storiesOfFeed substringWithRange:middleRange] isEqualToString:@"+"]) {
						inMiddleOfWord = NO;
					} else {						
						range.length = range.length - 1;
						if (range.length == 1) {inMiddleOfWord = NO;}
					}
					
				} while (inMiddleOfWord);				
					
				NSString *urlString = [NSString stringWithFormat:@"http://translate.google.com/translate_tts?q=%@", [storiesOfFeed substringWithRange:range]];
				NSURL *url = [[NSURL alloc] initWithString:urlString];
				if (url == nil) { return NO; }
				NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url]; 
				if (request == nil) { [url release]; ; return NO; }
				NSData *receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
				if (receivedData == nil) { [url release]; [request release]; return NO; }
				//if ([receivedData length] == 0) { [url release]; [request release]; return NO; }
				[[speechData objectForKey:[feedsNames objectAtIndex:i]] appendData:receivedData];
				[url release]; [request release]; 
																				
				// Below is asynchronous version.  Asynchronous connections do not work with this implementation, since data does not return in order.
				/*
				NSString *urlString = [NSString stringWithFormat:@"http://translate.google.com/translate_tts?q=%@", [storiesOfFeed substringWithRange:range]];
				NSURL *url = [[NSURL alloc] initWithString:urlString];
				NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url]; 
				NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:[connectionDelegates objectForKey:[feedsNames objectAtIndex:i]]];
				[url release]; [request release]; [connection release]; 	
				*/
			} // while
			
			// Write data to disk.			
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);	
			NSString *documentsDirectory = [paths objectAtIndex:0];
			if (!documentsDirectory) { NSLog(@"Documents directory not found!"); return NO; }
			NSString *audioFileName = [NSString stringWithFormat:@"%@.mp3", [feedsNames objectAtIndex:i]];
			NSString *audioFile = [documentsDirectory stringByAppendingPathComponent:audioFileName];	
			if (![[speechData objectForKey:[feedsNames objectAtIndex:i]] writeToFile:audioFile atomically:YES]) { return NO; }

			[feedsLastRefreshed replaceObjectAtIndex:i withObject:[NSDate date]];
			[reloadFlags replaceObjectAtIndex:i withObject:[NSNumber numberWithUnsignedInt:0]];	
		}	
	} // for each feed
	return YES;
}

#pragma mark RSS.
- (BOOL)retrieveStories {
	[stories removeAllObjects];	
	for (int i = 0; i < [feedsURLs count]; i++) {
		NSTimeInterval intervalElapsed = - [[feedsLastRefreshed objectAtIndex:i] timeIntervalSinceNow]; // In seconds.
		NSTimeInterval MAX_UNREFRESH_INTERVAL = 900; // 15 minutes.
		// Check if the feed is selected and that the last refresh was a long time ago.  
		// If that is the case, then we need to retrieve the stories.		
		if ( ([[feedsSelected objectAtIndex:i] unsignedIntValue] == 1) && (intervalElapsed > MAX_UNREFRESH_INTERVAL) && 
			(![[feedsURLs objectAtIndex:i] isEqualToString:@"local"]) ) {
			
			NSURL *url = [[NSURL alloc] initWithString:[feedsURLs objectAtIndex:i]];
			if (url == nil) { return NO; }
			NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
			if (xmlParser == nil) { [url release]; return NO; }
			[xmlParser setDelegate:self];
			currentFeedName = [NSString stringWithString:[feedsNames objectAtIndex:i]];
			NSMutableString *story = [[NSMutableString alloc] init];
			[stories setObject:story forKey:currentFeedName];
			[story release];			
			if (![xmlParser parse]) { [xmlParser release]; [url release]; return NO; }			
			[xmlParser release];  [url release];
			// Clean up data.  Replace whitespace with "+".  Also weird characters.  Just leave letters, and numbers, periods, and the "+" character.  
			// This ensures the TTS (http request and actual audio) is smooth.
			NSString *preString = [stories objectForKey:currentFeedName];
			NSCharacterSet *safeChars = [NSCharacterSet characterSetWithCharactersInString:
						@"0123456789 the quick brown fox jumps over the lazy dog THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG,.:;+"];
			NSCharacterSet *unsafeChars = [safeChars invertedSet];
			NSArray *extractedSafeStrings = [preString componentsSeparatedByCharactersInSet:unsafeChars];
			NSMutableString *postString = [[NSMutableString alloc] init];
			[postString appendString:[extractedSafeStrings componentsJoinedByString:@"+"]];
			NSRange wholeRange = [postString rangeOfString:postString];
			[postString replaceOccurrencesOfString:@" " withString:@"+" options:NSCaseInsensitiveSearch range:wholeRange];
			[postString replaceOccurrencesOfString:@"," withString:@"." options:NSCaseInsensitiveSearch range:wholeRange];
			[postString replaceOccurrencesOfString:@":" withString:@"." options:NSCaseInsensitiveSearch range:wholeRange];
			[postString replaceOccurrencesOfString:@";" withString:@"." options:NSCaseInsensitiveSearch range:wholeRange];
			[stories setObject:postString forKey:currentFeedName];
			[postString release];
		}
	}
	return YES;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
	if ([elementName isEqualToString:@"title"]) { inRSSElementOfInterest = YES; }	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if (inRSSElementOfInterest) { 
		if ( [[stories objectForKey:currentFeedName] length] < 500 ) {
			NSString *newString = [NSString stringWithFormat:@"+.+%@", string];
			[[stories objectForKey:currentFeedName] appendString:newString]; // Separate each story with a period.
		}		
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if ([elementName isEqualToString:@"title"]) { inRSSElementOfInterest = NO; }
}

-(void)parserDidStartDocument:(NSXMLParser *)parser {
}

-(void)parserDidEndDocument:(NSXMLParser *)parser {
}

#pragma mark UIView.
- (void)viewDidLoad {
	
    [super viewDidLoad];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	// self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	dataLoadingAlertView = [[UIAlertView alloc] initWithTitle:@"Loading..." message:@" " delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
	UIActivityIndicatorView *spinnerView= [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(125, 60, 30, 30)];
	[spinnerView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[dataLoadingAlertView addSubview:spinnerView];
	[spinnerView startAnimating];
	[dataLoadingAlertView show];

}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
	// Check array sizes.
	NSLog(@"feedsURLs has size %d", [feedsURLs count]);
	NSLog(@"feedsNames has size %d", [feedsNames count]);
	NSLog(@"feedsSelected has size %d", [feedsSelected count]);
	NSLog(@"feedsLastRefreshed has size %d", [feedsLastRefreshed count]);
	NSLog(@"feedsSubtext has size %d", [feedsSubtext count]);
	NSLog(@"filePaths has size %d", [filePaths count]);
	NSLog(@"reloadFlags has size %d", [reloadFlags count]);
	
	// Check Internet connection.
	BOOL connected = NO;
	NSString *checkConnection = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"]];
	if (checkConnection) { connected = YES; } 
		else { NSLog(@"Connection offline."); }
	[checkConnection release];
	
	// If connected, retrieve data.
	BOOL dataRetrieved = NO;
	if (checkConnection) {
		NSLog(@"Before retrieving stories.");	
	
		BOOL retrievedStoriesNoError = [self retrieveStories];	
		NSLog(@"After retrieving stories.");
			
		BOOL retrievedSpeechNoError = NO;
		if (retrievedStoriesNoError) {
			retrievedSpeechNoError = [self retrieveSpeechData];
		}
		NSLog(@"After retrieving speech data.");	
		
		dataRetrieved = retrievedSpeechNoError;
	}

	[dataLoadingAlertView dismissWithClickedButtonIndex:0 animated:YES];

	if (!dataRetrieved) {
		UIAlertView *alertView = [[UIAlertView alloc]
									initWithTitle:@"Connection error" message:@"Feed(s) not refreshed" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}
	
	// Check array sizes.
	NSLog(@"feedsURLs has size %d", [feedsURLs count]);
	NSLog(@"feedsNames has size %d", [feedsNames count]);
	NSLog(@"feedsSelected has size %d", [feedsSelected count]);
	NSLog(@"feedsLastRefreshed has size %d", [feedsLastRefreshed count]);
	NSLog(@"feedsSubtext has size %d", [feedsSubtext count]);
	NSLog(@"filePaths has size %d", [filePaths count]);
	NSLog(@"reloadFlags has size %d", [reloadFlags count]);
	
	// Tell sound manager to play sounds.
	[self updatePlayingSounds];
	[(UITableView *)[self view] reloadData];  // Refresh subtext information in cells.
	
	NSLog(@"After updating sounds.");	
	
	// Write information to disk.
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);	
	NSString *documentsDirectory = [paths objectAtIndex:0];
	if (!documentsDirectory) { NSLog(@"Documents directory not found!"); return; }		
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"feedsLastRefreshed.txt"];
	[feedsLastRefreshed writeToFile:filePath atomically:YES];	

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
	
	NSLog(@"Memory warning in FeedsViewController.m");	
	// Release any cached data, images, etc that aren't in use.
}

/*
- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}
*/

#pragma mark UITableView.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [feedsNames count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    // Set up the cell...
	[[cell textLabel] setText:[feedsNames objectAtIndex:[indexPath row]]];
	if ([[feedsURLs objectAtIndex:[indexPath row]] isEqualToString:@"local"]) {
		[[cell detailTextLabel] setText:[feedsSubtext objectAtIndex:[indexPath row]]];
	} else {
		NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ;
		NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:[feedsLastRefreshed objectAtIndex:[indexPath row]]];
		NSString *lastRefreshedTime;
		if ([[feedsLastRefreshed objectAtIndex:[indexPath row]] isEqualToDate:[NSDate distantPast]]) {
			lastRefreshedTime = @"Never loaded";
		} else {
			lastRefreshedTime = [NSString stringWithFormat:@"Last refreshed: %04d.%02d.%02d. %02d:%02d:%02d", 
				[dateComponents year], [dateComponents month], [dateComponents day], [dateComponents hour], [dateComponents minute], [dateComponents second]];
		}
		[[cell detailTextLabel] setText:lastRefreshedTime];
	}
	if ( [[feedsSelected objectAtIndex:[indexPath row]] unsignedIntValue] == 1) {
		[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
	} else {
		[cell setAccessoryType:UITableViewCellAccessoryNone];
	}	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
	
	// Update checkmarks and active flags accordingly.
	UITableViewCell *cell = [(UITableView *)[self view] cellForRowAtIndexPath:indexPath];
	if ( [[feedsSelected objectAtIndex:[indexPath row]] unsignedIntValue] == 1) { // Uncheckmarking.
		[feedsSelected replaceObjectAtIndex:[indexPath row] withObject:[NSNumber numberWithUnsignedInt:0]];
		[cell setAccessoryType:UITableViewCellAccessoryNone];
	} else { // Attempt to checkmark.  Check if allowed.  (Cannot have too many checkmarked feeds.)
		int count = 0;
		for (int i = 0; i < [feedsSelected count]; i++) {
			count = count + [[feedsSelected objectAtIndex:i] unsignedIntValue];
		}
		int MAX_NUMBER_FEEDS = 6;
		if (count < MAX_NUMBER_FEEDS) {
			[feedsSelected replaceObjectAtIndex:[indexPath row] withObject:[NSNumber numberWithUnsignedInt:1]];
			[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
		}
	}
	[(UITableView *)[self view] deselectRowAtIndexPath:indexPath animated:NO];
}
	
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
		[RSSFeedsURLs removeObjectAtIndex:[indexPath row]];
		[RSSFeedsNames removeObjectAtIndex:[indexPath row]];
		[RSSFeedsActive removeObjectAtIndex:[indexPath row]];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/
/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/
/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

@end

