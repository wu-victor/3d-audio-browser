//
//  AudioBrowserView.h
//  AudioBrowser
//
//  Created by Victor Wu on 3/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AudioBrowserView : UIView {
	// Draw a dots to the view when touching.
	CGFloat dot1x, dot1y;
}

@property (readwrite, assign) CGFloat dot1x, dot1y;

@end