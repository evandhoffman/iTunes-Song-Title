//
//  IPMenulet.m
//  iTunes Current Track
//
//  Created by Evan D. Hoffman on 10/13/11.
//  Copyright 2011. All rights reserved.
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
						  stringWithString:@"♪"]]; 
	[statusItem setEnabled:YES];
	[statusItem setToolTip:@"Song Title Menulet"];
	
	[statusItem setAction:@selector(updateSongTitle:)];
	[statusItem setTarget:self];
	
	// Menu display
	[statusItem setMenu:theMenu];
	currentTrackMenuItem = [[NSMenuItem alloc]
							initWithTitle:@"<No Information>"
							action:@selector(updateSongTitle:)
							keyEquivalent:@""];
	currentArtistMenuItem = [[NSMenuItem alloc]
							initWithTitle:@"<No Information>"
							action:@selector(updateSongTitle:)
							keyEquivalent:@""];
	currentAlbumMenuItem = [[NSMenuItem alloc]
							initWithTitle:@"<No Information>"
							action:@selector(updateSongTitle:)
							keyEquivalent:@""];
	
	
	[currentTrackMenuItem setTarget:self];
	[currentArtistMenuItem setTarget:self];
	[currentAlbumMenuItem setTarget:self];
	
	[theMenu insertItem:currentTrackMenuItem atIndex:1];
	[theMenu insertItem:currentArtistMenuItem atIndex:3];
	[theMenu insertItem:currentAlbumMenuItem atIndex:5];
	
}

-(void)updateSongTitle:(NSNotification *)notification
{
	iTunesApplication *iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
	
	if ( [iTunes isRunning] ) {
		
		iTunesTrack *currentTrack = [iTunes currentTrack];
				
		if (currentTrack != NULL) {
			[statusItem setTitle:@"♪"]; 
			[currentTrackMenuItem setTitle:[NSString stringWithString:[currentTrack name]]]; 
			[currentArtistMenuItem setTitle:[NSString stringWithString:[currentTrack artist]]]; 
			[currentAlbumMenuItem setTitle:[NSString stringWithString:[currentTrack album]]]; 
		} else {
			[statusItem setTitle:
			 [NSString stringWithString:@"<Woops>"]]; 			
			[currentTrackMenuItem setTitle:@""]; 
			[currentArtistMenuItem setTitle:@""]; 
			[currentAlbumMenuItem setTitle:@""]; 
		}
		
	} else {
		[statusItem setTitle:
		 [NSString stringWithString:@"♪?"]]; 
		
	}
	
}

@end
