//
//  IPMenulet.m
//  iTunes Current Track
//
//  Created by Evan D. Hoffman on 10/13/11.
//  Copyright 2011. All rights reserved.
//

#import "IPMenulet.h"


@implementation IPMenulet

//-(id)init {
//	self = [super init];
//	if (self != nil) {
//		[self awakeFromNib];
//	}
//	return self;
//}

-(void)dealloc
{
    [statusItem release];
	[theMenu release];
	[currentTrackMenuItem release];
	[currentArtistMenuItem release];
	[currentAlbumMenuItem release];	
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
	
	currentTrackFileName = [[NSMenuItem alloc]
							initWithTitle:@"<No Information>"
							action:@selector(updateSongTitle:)
							keyEquivalent:@""];
	
	currentTrackYear = [[NSMenuItem alloc]
							initWithTitle:@"<No Information>"
							action:@selector(updateSongTitle:)
							keyEquivalent:@""];
	
	currentTrackFileSize = [[NSMenuItem alloc]
							initWithTitle:@"<No Information>"
							action:@selector(updateSongTitle:)
							keyEquivalent:@""];
	
	currentTrackLength = [[NSMenuItem alloc]
							initWithTitle:@"<No Information>"
							action:@selector(updateSongTitle:)
							keyEquivalent:@""];
	
	currentTrackBitrate = [[NSMenuItem alloc]
						  initWithTitle:@"<No Information>"
						  action:@selector(updateSongTitle:)
						  keyEquivalent:@""];
	
	
	
	[currentTrackMenuItem setTarget:self];
	[currentArtistMenuItem setTarget:self];
	[currentAlbumMenuItem setTarget:self];
	[currentTrackFileName setTarget:self];
	[currentTrackYear setTarget:self];
	[currentTrackFileSize setTarget:self];
	[currentTrackLength setTarget:self];
	[currentTrackBitrate setTarget:self];
	
	[theMenu insertItem:currentTrackMenuItem atIndex:1];
	[theMenu insertItem:currentArtistMenuItem atIndex:3];
	[theMenu insertItem:currentAlbumMenuItem atIndex:5];
	[theMenu insertItem:currentTrackYear atIndex:7];
	[theMenu insertItem:currentTrackLength atIndex:9];
	[theMenu insertItem:currentTrackFileName atIndex:12];
	[theMenu insertItem:currentTrackFileSize atIndex:14];
	[theMenu insertItem:currentTrackBitrate atIndex:16];
	
	// Update the song info immediately so we don't have to wait for the track to change.
	[self updateSongTitle:nil];
	
	
}

-(void)updateSongTitle:(NSNotification *)notification
{
	iTunesApplication *iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
	
	if ( iTunes != NULL && [iTunes isRunning] ) {
		
		iTunesFileTrack *currentTrack = (iTunesFileTrack*)[iTunes currentTrack];
		
		if (currentTrack != NULL) {
//			if ([currentTrack class] == [iTunesFileTrack class]) {
//				iTunesFileTrack *fileTrack = (iTunesFileTrack*)currentTrack;
//				[currentTrackFileName setTitle:[NSString stringWithFormat:@"%@",[fileTrack location]]]; 
//			}
			
			[statusItem setTitle:@"♪"]; 
			[currentTrackMenuItem setTitle:[NSString stringWithString:[currentTrack name]]]; 
			[currentArtistMenuItem setTitle:[NSString stringWithString:[currentTrack artist]]]; 
			[currentAlbumMenuItem setTitle:[NSString stringWithString:[currentTrack album]]]; 
			[currentTrackYear setTitle:[NSString stringWithFormat:@"%d",[currentTrack year]]]; 
			[currentTrackLength setTitle:[NSString stringWithString:[currentTrack time]]]; 
//			[currentTrackFileName setTitle:[NSString stringWithString:[[currentTrack location] absoluteString]]]; 
			[currentTrackFileName setTitle:[NSString stringWithString:@"<wut?>"]]; 
			[currentTrackFileSize setTitle:[NSString stringWithFormat:@"%0.2f MB",([currentTrack size]/1048576.0)]]; 
			[currentTrackBitrate setTitle:[NSString stringWithFormat:@"%d kbps",[currentTrack bitRate]]]; 
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
		[currentTrackMenuItem setTitle:@""]; 
		[currentArtistMenuItem setTitle:@""]; 
		[currentAlbumMenuItem setTitle:@""]; 
		
	}
	
}

@end
