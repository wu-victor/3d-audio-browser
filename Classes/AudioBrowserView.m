//
//  AudioBrowserView.m
//  AudioBrowser
//
//  Created by Victor Wu on 3/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AudioBrowserView.h"

@implementation AudioBrowserView

@synthesize dot1x, dot1y;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)drawRect:(CGRect)rect {
	CGContextRef ctx = UIGraphicsGetCurrentContext();		
	
	if (dot1x != 0) {
		CGContextSetFillColorWithColor(ctx, [[UIColor colorWithRed:0 green:0 blue:1 alpha:0.25] CGColor]);
//		CGContextSetFillColorWithColor(ctx, [[UIColor redColor] CGColor]);
		CGContextAddArc(ctx, dot1x, dot1y, 10.0f, 0.0f, 2.0f * M_PI, YES);
		CGContextFillPath(ctx);
	}
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if ( event.subtype == UIEventSubtypeMotionShake ) {
		// NSLog(@"UIView shook.");
	}
    if ( [super respondsToSelector:@selector(motionBegan:withEvent:)] ) {
        [super motionBegan:motion withEvent:event];
	}
}

- (BOOL)canBecomeFirstResponder { 
 return YES; 
}


@end
