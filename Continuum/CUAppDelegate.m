//
//  CUAppDelegate.m
//  Continuum
//
//  Created by Sam Bodanis on 12/07/2014.
//  Copyright (c) 2014 Sam Bodanis. All rights reserved.
//

#import "CUAppDelegate.h"

@implementation CUAppDelegate

@synthesize w_self = _w_self;

int arrayElem = 0;
float kFilteringFactor = 0.07;
int taps = 0;
NSDate *lastBump = NULL;
bool isPaused = false;

- (NSMutableDictionary *)w_self {
    if (!_w_self) {
        _w_self = [[NSMutableDictionary alloc] init];
    }
    return _w_self;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    __block UIBackgroundTaskIdentifier background_task;
    
    background_task = [application beginBackgroundTaskWithExpirationHandler:^ {
        [application endBackgroundTask: background_task];
        background_task = UIBackgroundTaskInvalid;
        }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //run the app without startUpdatingLocation. backgroundTimeRemaining decremented from 600.00
//        [manager startUpdatingLocation];
        NSLog(@"Background!");
        self.motionManager = [[CMMotionManager alloc] init];
        [self.w_self setObject:[NSNumber numberWithFloat:0] forKey:@"accelX"];
        [self.w_self setObject:[NSNumber numberWithFloat:0] forKey:@"accelY"];
        [self.w_self setObject:[NSNumber numberWithFloat:0] forKey:@"accelZ"];
        [self startAccelerationCollection];
        
        while(TRUE) {
            //backgroundTimeRemaining time does not go down.
            
            NSLog(@"Background time Remaining: %f",[[UIApplication sharedApplication] backgroundTimeRemaining]);
            [NSThread sleepForTimeInterval:1]; //wait for 1 sec
        }
        [application endBackgroundTask: background_task];
        background_task = UIBackgroundTaskInvalid;
    });

    
//    NSLog(@"Background!");
//    self.motionManager = [[CMMotionManager alloc] init];
//    [self.w_self setObject:[NSNumber numberWithFloat:0] forKey:@"accelX"];
//    [self.w_self setObject:[NSNumber numberWithFloat:0] forKey:@"accelY"];
//    [self.w_self setObject:[NSNumber numberWithFloat:0] forKey:@"accelZ"];
//    [self startAccelerationCollection];
    
}

- (void)startAccelerationCollection {
    lastBump = [NSDate date];
    [self.motionManager startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc] init]
                                             withHandler:^(CMAccelerometerData *data, NSError *error) {
//                                                 NSLog(@"Chillin");
                                                 CMAcceleration acceleration = data.acceleration;
                                                 float prevAccelX = [[self.w_self objectForKey:@"accelX"] floatValue];
                                                 float prevAccelY = [[self.w_self objectForKey:@"accelY"] floatValue];
                                                 float prevAccelZ = [[self.w_self objectForKey:@"accelZ"] floatValue];
                                                 [self.w_self setObject:[NSNumber numberWithFloat:acceleration.x - ( (acceleration.x * kFilteringFactor) +
                                                                                                                    ([[self.w_self objectForKey:@"accelX"] floatValue] * (1.0 - kFilteringFactor)) ) ] forKey:@"accelX"];
                                                 [self.w_self setObject:[NSNumber numberWithFloat:acceleration.x - ( (acceleration.x * kFilteringFactor) +
                                                                                                                    ([[self.w_self objectForKey:@"accelY"] floatValue] * (1.0 - kFilteringFactor)) ) ] forKey:@"accelY"];
                                                 [self.w_self setObject:[NSNumber numberWithFloat:acceleration.x - ( (acceleration.x * kFilteringFactor) +
                                                                                                                    ([[self.w_self objectForKey:@"accelZ"] floatValue] * (1.0 - kFilteringFactor)) ) ] forKey:@"accelZ"];
                                                 //                                                 NSLog(@"%@", self.w_self);
                                                 
                                                 // Compute the derivative (which represents change in acceleration).
                                                 float deltaX = ABS(([[self.w_self objectForKey:@"accelX"] floatValue] - prevAccelX));
                                                 float deltaY = ABS(([[self.w_self objectForKey:@"accelY"] floatValue] - prevAccelY));
                                                 float deltaZ = ABS(([[self.w_self objectForKey:@"accelZ"] floatValue] - prevAccelZ));
                                                 
                                                 // Check if the derivative exceeds some sensitivity threshold
                                                 // (Bigger value indicates stronger bump)
                                                 // (Probably should use length of the vector instead of componentwise)
                                                 if ( deltaX > 1 || deltaY > 1 || deltaZ > 1 ) {
                                                     //                                                     NSLog( @"BUMP %d:  %.3f, %.3f, %.3f", taps++, deltaX, deltaY, deltaZ);
                                                     [self handleBumpEvent];
                                                 }
                                                 
                                                 //                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                 //                                                     [self.accelerometerReadings addObject:data];
                                                 //                                                 });
                                             }];
}

- (void)handleBumpEvent {
    NSDate *localDate = [NSDate date];
    NSTimeInterval bumpDiff = [localDate timeIntervalSinceDate:lastBump];
    lastBump = localDate;
    //    NSLog(@"%f", bumpDiff);
    if (bumpDiff > .5) {
        NSLog(@"Bump!");
        [self sendSong];
    }
}


//- (IBAction)sendButton {
- (void)sendSong {
    MPMediaItem *nowPlayingMediaItem = [[MPMusicPlayerController iPodMusicPlayer] nowPlayingItem];
    float currTime = [MPMusicPlayerController iPodMusicPlayer].currentPlaybackTime;
    // Works while not connected to an accessory
    NSString *title = [nowPlayingMediaItem valueForProperty:MPMediaItemPropertyTitle];
    NSString *artist = [nowPlayingMediaItem valueForProperty:MPMediaItemPropertyArtist];
    if (!artist) {
        artist = @"";
    }
    
    NSString *urlString = [NSString stringWithFormat:@"http://192.241.169.214:5000/?title=%@&artist=%@&offset=%f&paused=%d",
                           [title stringByReplacingOccurrencesOfString:@" " withString:@"+"],
                           [artist stringByReplacingOccurrencesOfString:@" " withString:@"+"],
                           currTime,
                           isPaused];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    if (isPaused) {
        [[MPMusicPlayerController iPodMusicPlayer] play];
        isPaused = false;
    } else {
        [[MPMusicPlayerController iPodMusicPlayer] pause];
        isPaused = true;
    }
    
    NSData *response1 = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    if (requestError) {
        NSLog(@"Error! %@", requestError);
    } else {
        NSLog(@"Response: %@", urlResponse);
    }
    NSLog(@"Title: %@\nTime: %f\nArtist: %@", title, currTime, artist);
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
