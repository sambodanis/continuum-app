//
//  CUAppDelegate.h
//  Continuum
//
//  Created by Sam Bodanis on 12/07/2014.
//  Copyright (c) 2014 Sam Bodanis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <MediaPlayer/MediaPlayer.h>
//#import "CUViewController.h"


@interface CUAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@property (nonatomic, strong) CMMotionManager *motionManager;

@property (nonatomic, strong) NSMutableDictionary *w_self;


@end
