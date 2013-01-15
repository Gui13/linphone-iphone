/* BuschJaegerSettingsView.h
 *
 * Copyright (C) 2012  Belledonne Comunications, Grenoble, France
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

#import <UIKit/UIKit.h>

#import "ZBarReaderViewController.h"
#import "BuschJaegerConfiguration.h"

@interface BuschJaegerSettingsView : UIViewController<ZBarReaderDelegate, BuschJaegerConfigurationDelegate> {
    @private
    ZBarReaderViewController *scanController;
}

@property (nonatomic, retain) IBOutlet UIView *scanButton;
@property (nonatomic, retain) IBOutlet UIView *manualButton;
@property (nonatomic, retain) IBOutlet UIView *backButton;
@property (nonatomic, retain) IBOutlet UIView *waitView;

- (IBAction)onScanClick:(id)sender;
- (IBAction)onManualClick:(id)sender;
- (IBAction)onBackClick:(id)sender;

- (void)reloadConfiguration;

@end
