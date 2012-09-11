/* UISpeakerButton.m
 *
 * Copyright (C) 2011  Belledonne Comunications, Grenoble, France
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or   
 *  (at your option) any later version.                                 
 *                                                                      
 *  This program is distributed in the hope that it will be useful,     
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of      
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the       
 *  GNU General Public License for more details.                
 *                                                                      
 *  You should have received a copy of the GNU General Public License   
 *  along with this program; if not, write to the Free Software         
 *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 */       

#import <AudioToolbox/AudioToolbox.h>
#import "UISpeakerButton.h"
#import "Utils.h"
#import "LinphoneManager.h"

#include "linphonecore.h"

@implementation UISpeakerButton


#pragma mark - Static Functions

static AudioSessionPropertyID routeChangeID = kAudioSessionProperty_AudioRouteChange;

static void audioRouteChangeListenerCallback (
                                       void                   *inUserData,                                 // 1
                                       AudioSessionPropertyID inPropertyID,                                // 2
                                       UInt32                 inPropertyValueSize,                         // 3
                                       const void             *inPropertyValue                             // 4
                                       ) {
    if (inPropertyID != kAudioSessionProperty_AudioRouteChange) return; // 5
    UISpeakerButton* button=(UISpeakerButton*)inUserData;
	UInt32 routeSize = sizeof (CFStringRef);
	CFStringRef route;
	AudioSessionGetProperty (kAudioSessionProperty_AudioRoute,
										  &routeSize,
										  &route);
	
	if (route &&
		button.selected  && 
		!( [(NSString*)route isEqualToString: @"Speaker"] || [(NSString*)route isEqualToString: @"SpeakerAndMicrophone"])) {
		[LinphoneLogger logc:LinphoneLoggerLog format:"Audio route change to [%s] rejected by speaker button", [(NSString*)route cStringUsingEncoding:[NSString defaultCStringEncoding]]];
		// reject change
		[button onOn];
	} else
		[(UISpeakerButton*)inUserData update];  
   
}

- (void)initUISpeakerButton {
    AudioSessionInitialize(NULL, NULL, NULL, NULL);
    OSStatus lStatus = AudioSessionAddPropertyListener(routeChangeID, audioRouteChangeListenerCallback, self);
    if (lStatus) {
        [LinphoneLogger logc:LinphoneLoggerError format:"cannot register route change handler [%ld]",lStatus];
    }
}

- (id)init {
    self = [super init];
    if (self) {
		[self initUISpeakerButton];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		[self initUISpeakerButton];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
		[self initUISpeakerButton];
	}
    return self;
}	

- (void)dealloc {
    OSStatus lStatus = AudioSessionRemovePropertyListenerWithUserData(routeChangeID, audioRouteChangeListenerCallback, self);
	if (lStatus) {
		[LinphoneLogger logc:LinphoneLoggerError format:"cannot un register route change handler [%ld]",lStatus];
	}
	[super dealloc];
}

#pragma mark - UIToggleButtonDelegate Functions

- (void)onOn {
	[[LinphoneManager instance] enableSpeaker:TRUE];
}

- (void)onOff {
    [[LinphoneManager instance] enableSpeaker:FALSE];
}

- (bool)onUpdate {
    return [[LinphoneManager instance] isSpeakerEnabled];
}

@end
