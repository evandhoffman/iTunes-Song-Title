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
	// Listen for track changes
	NSDistributedNotificationCenter *dnc = [NSDistributedNotificationCenter defaultCenter];
	[dnc addObserver:self selector:@selector(updateSongTitle:) name:@"com.apple.iTunes.playerInfo" object:nil];
	
	statusItem = [[[NSStatusBar systemStatusBar] 
				   statusItemWithLength:NSVariableStatusItemLength]
				  retain];
	[statusItem setHighlightMode:YES];
	[statusItem setTitle:[NSString 
						  stringWithString:@"<No Song>"]]; 
	[statusItem setEnabled:YES];
	[statusItem setToolTip:@"Song Title Menulet"];
	
//	[statusItem setAction:@selector(updateSongTitle:)];
	[statusItem setTarget:self];
}

-(void)updateSongTitle:(NSNotification *)notification
{
	iTunesApplication *iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
	
	if ( [iTunes isRunning] ) {
		
		iTunesTrack *currentTrack = [iTunes currentTrack];
		
		NSString *trackName = [NSString stringWithFormat:@"%@ - %@",[currentTrack artist], [currentTrack name]];
		
		if (trackName != NULL) {
			[statusItem setTitle:
			 [NSString stringWithString:trackName]]; 
		} else {
			[statusItem setTitle:
			 [NSString stringWithString:@"<Woops>"]]; 			
		}
		
	} else {
		[statusItem setTitle:
		 [NSString stringWithString:@"<iTunes Not Running>"]]; 
		
	}
	
}

@end
