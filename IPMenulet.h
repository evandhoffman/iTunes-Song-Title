//
//  IPMenulet.h
//  iTunes Current Track
//
//  Created by Evan D. Hoffman on 10/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iTunes.h"


@interface IPMenulet : NSObject {
    NSStatusItem *statusItem;
//	iTunesApplication *iTunes;
}

-(IBAction)updateSongTitle:(id)sender;

@end
