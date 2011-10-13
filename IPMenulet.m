//
//  IPMenulet.m
//  iTunes Current Track
//
//  Created by Evan D. Hoffman on 10/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IPMenulet.h"


@implementation IPMenulet

-(void)dealloc
{
    [statusItem release];
	[super dealloc];
}
- (void)awakeFromNib
{
	statusItem = [[[NSStatusBar systemStatusBar] 
				   statusItemWithLength:NSVariableStatusItemLength]
				  retain];
	[statusItem setHighlightMode:YES];
	[statusItem setTitle:[NSString 
						  stringWithString:@"0.0.0.0"]]; 
	[statusItem setEnabled:YES];
	[statusItem setToolTip:@"IPMenulet"];
	
	[statusItem setAction:@selector(updateIPAddress:)];
	[statusItem setTarget:self];
}

-(IBAction)updateIPAddress:(id)sender
{
	NSString *ipAddr = [NSString stringWithContentsOfURL:
						[NSURL URLWithString:
						 @"http://highearthorbit.com/service/myip.php"]];
	if(ipAddr != NULL)
		[statusItem setTitle:
		 [NSString stringWithString:ipAddr]]; 
}

@end
