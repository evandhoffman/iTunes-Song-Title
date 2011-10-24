//
//  IPMenulet.m
//  iTunes Current Track
//
//  Created by Evan D. Hoffman on 10/13/11.
//  Copyright 2011. All rights reserved.
//

#import "IPMenulet.h"
#import "iTunes.h"


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
	
	
	// Build date
	NSString * buildDate = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"DDBuildDate"];
	
	
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
	buildDateItem = [[NSMenuItem alloc]
					 initWithTitle:[NSString stringWithFormat:@"Build date: %@",buildDate]
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

	[buildDateItem setTarget:self];
	
	[theMenu insertItem:currentTrackMenuItem atIndex:1];
	[theMenu insertItem:currentArtistMenuItem atIndex:3];
	[theMenu insertItem:currentAlbumMenuItem atIndex:5];
	[theMenu insertItem:currentTrackYear atIndex:7];
	[theMenu insertItem:currentTrackLength atIndex:9];
	[theMenu insertItem:currentTrackFileName atIndex:12];
	[theMenu insertItem:currentTrackFileSize atIndex:14];
	[theMenu insertItem:currentTrackBitrate atIndex:16];
	[theMenu insertItem:buildDateItem atIndex:17];

	NSLog(@"Init complete, menu setup");
	
	// Update the song info immediately so we don't have to wait for the track to change.
	[self updateSongTitle:nil];
	
	NSLog(@"Initial calling of updateSongTitle");
	
}

-(void)updateSongTitle:(NSNotification *)notification
{
	iTunesApplication *iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
	
	if ( iTunes != NULL && [iTunes isRunning] ) {
		
		iTunesTrack *currentTrack = [iTunes currentTrack];
		NSString *trackLocation = @"?";
		
		if (currentTrack != NULL) {
			NSLog(@"Trying to determine location");
			trackLocation = [NSString stringWithFormat:@"%@",[currentTrack kind]];
			

//			if ([currentTrack isKindOfClass:[iTunesFileTrack class]]) { // Why doesn't this work?			
//				NSLog(@"it's a iTunesFileTrack");
//				trackLocation = [[(iTunesFileTrack*)currentTrack location] absoluteString];
//			}
//			if ([[currentTrack className] isEqualToString:@"iTunesURLTrack"]) {
//				NSLog(@"it's a iTunesURLTrack");
//				trackLocation = [[(iTunesURLTrack*)currentTrack location] absoluteString];
//			}
//			
			NSLog(@"Updating track name");
			switch ([iTunes playerState]) {
				case iTunesEPlSStopped:
					[statusItem setTitle:@"♪◼"]; 
					break;
				case iTunesEPlSPaused:
					[statusItem setTitle:@"♪‖"]; 
					break;
				case iTunesEPlSPlaying:
					[statusItem setTitle:@"♪▶"]; 
					break;
				default:
					[statusItem setTitle:@"♪"]; 
					break;
			}
		//	[statusItem setTitle:@"♪▶‖◼"]; 
			[currentTrackMenuItem setTitle:([currentTrack name] == nil) ? @"" : [NSString stringWithString:[currentTrack name]]]; 
			NSLog(@"Updating track artist");
			[currentArtistMenuItem setTitle:([currentTrack name] == nil) ? @"" : [NSString stringWithString:[currentTrack artist]]]; 
			NSLog(@"Updating track album");
			[currentAlbumMenuItem setTitle:([currentTrack name] == nil) ? @"" : [NSString stringWithString:[currentTrack album]]]; 
			NSLog(@"Updating track year");
			[currentTrackYear setTitle:([currentTrack year] > 0) ? [NSString stringWithFormat:@"%d",[currentTrack year]] : @"?"]; 
			NSLog(@"Updating track time");
			[currentTrackLength setTitle:([currentTrack time] == nil) ? @"?" : [NSString stringWithString:[currentTrack time]]]; 
			NSLog(@"Updating track location");
//			[currentTrackFileName setTitle:[NSString stringWithString:trackLocation]]; 
			[currentTrackFileName setTitle:([currentTrack name] == nil) ? @"" : [NSString stringWithFormat:@"%@ - %@",[currentTrack className],trackLocation]]; 
			NSLog(@"Updating track size");
			[currentTrackFileSize setTitle:([currentTrack size] > 0) ? [NSString stringWithFormat:@"%0.2f MB",([currentTrack size]/1048576.0)] : @"?"]; 
			NSLog(@"Updating track bitrate");
			[currentTrackBitrate setTitle:([currentTrack name] == nil) ? @"" : [NSString stringWithFormat:@"%d kbps",[currentTrack bitRate]]]; 
			NSLog(@"Updated everything");
		} else {
			NSLog(@"Unable to determine track title");
			[statusItem setTitle:
			 [NSString stringWithString:@"♪!"]]; 			
			[currentTrackMenuItem setTitle:@"<Unable to determine current track>"]; 
			[currentArtistMenuItem setTitle:@""]; 
			[currentAlbumMenuItem setTitle:@""]; 
			[currentTrackYear setTitle:@""]; 
			[currentTrackLength setTitle:@""]; 
			[currentTrackFileName setTitle:@""]; 
			[currentTrackFileSize setTitle:@""]; 
			[currentTrackBitrate setTitle:@""]; 
		}
		
	} else {
		NSLog(@"iTunes not running");
		[statusItem setTitle:
		 [NSString stringWithString:@"♪?"]]; 
		[currentTrackMenuItem setTitle:@"<iTunes not running>"]; 
		[currentArtistMenuItem setTitle:@""]; 
		[currentAlbumMenuItem setTitle:@""]; 
		[currentTrackYear setTitle:@""]; 
		[currentTrackLength setTitle:@""]; 
		[currentTrackFileName setTitle:@""]; 
		[currentTrackFileSize setTitle:@""]; 
		[currentTrackBitrate setTitle:@""]; 

	}
	
}

@end
