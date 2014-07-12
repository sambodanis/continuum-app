//
//  CUViewController.m
//  Continuum
//
//  Created by Sam Bodanis on 12/07/2014.
//  Copyright (c) 2014 Sam Bodanis. All rights reserved.
//

#import "CUViewController.h"

@interface CUViewController ()

@property (nonatomic, strong) CBCentralManager *mgr;

@property (nonatomic, strong) CMMotionManager *motionManager;

@property (nonatomic, strong) NSMutableArray *motionDataArray;

@property (nonatomic, strong) NSMutableDictionary *w_self;

@property (strong, nonatomic) IBOutlet UITextField *textInputView;

@end

@implementation CUViewController

//@synthesize w_self = _w_self;
//
//int arrayElem = 0;
//float kFilteringFactor = 0.07;
//int taps = 0;
//NSDate *lastBump = NULL;
//bool isPaused = false;

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:@"username"];
    [textField resignFirstResponder];
    return YES;
}

- (NSMutableDictionary *)w_self {
    if (!_w_self) {
        _w_self = [[NSMutableDictionary alloc] init];
    }
    return _w_self;
}

- (void)resignOnTap:(id)iSender {
    [[self view] endEditing:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // nil while connected to an accessory
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [singleTap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:singleTap];

    
//    self.mgr = [[CBCentralManager alloc] initWithDelegate:nil queue:nil];
//    self.motionManager = [[CMMotionManager alloc] init];
//    
////    self.w_self = [[NSMutableDictionary alloc] init];
//    [self.w_self setObject:[NSNumber numberWithFloat:0] forKey:@"accelX"];
//    [self.w_self setObject:[NSNumber numberWithFloat:0] forKey:@"accelY"];
//    [self.w_self setObject:[NSNumber numberWithFloat:0] forKey:@"accelZ"];
    
//    [self startAccelerationCollection];
    
//    lastBump = [NSDate date];
    
    
//    int arraySize = 100;
//    self.motionDataArray = [[NSMutableArray alloc] initWithCapacity:arraySize];
}

//- (void)applicationDidEnterBackground:(UIApplication *)application {
//    NSLog(@"#background");
//    __block UIBackgroundTaskIdentifier background_task;
//    
//    background_task = [application beginBackgroundTaskWithExpirationHandler:^ {
//        [application endBackgroundTask: background_task];
//        background_task = UIBackgroundTaskInvalid;
//    }];
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [self startAccelerationCollection];
//    });
//}


//- (void)startAccelerationCollection {
//    lastBump = [NSDate date];
//    [self.motionManager startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc] init]
//                                             withHandler:^(CMAccelerometerData *data, NSError *error) {
//
//                                                 CMAcceleration acceleration = data.acceleration;
//                                                 float prevAccelX = [[self.w_self objectForKey:@"accelX"] floatValue];
//                                                 float prevAccelY = [[self.w_self objectForKey:@"accelY"] floatValue];
//                                                 float prevAccelZ = [[self.w_self objectForKey:@"accelZ"] floatValue];
//                                                 [self.w_self setObject:[NSNumber numberWithFloat:acceleration.x - ( (acceleration.x * kFilteringFactor) +
//                                                                                         ([[self.w_self objectForKey:@"accelX"] floatValue] * (1.0 - kFilteringFactor)) ) ] forKey:@"accelX"];
//                                                 [self.w_self setObject:[NSNumber numberWithFloat:acceleration.x - ( (acceleration.x * kFilteringFactor) +
//                                                                                                                    ([[self.w_self objectForKey:@"accelY"] floatValue] * (1.0 - kFilteringFactor)) ) ] forKey:@"accelY"];
//                                                 [self.w_self setObject:[NSNumber numberWithFloat:acceleration.x - ( (acceleration.x * kFilteringFactor) +
//                                                                                                                    ([[self.w_self objectForKey:@"accelZ"] floatValue] * (1.0 - kFilteringFactor)) ) ] forKey:@"accelZ"];
////                                                 NSLog(@"%@", self.w_self);
//                                                 
//                                                 // Compute the derivative (which represents change in acceleration).
//                                                 float deltaX = ABS(([[self.w_self objectForKey:@"accelX"] floatValue] - prevAccelX));
//                                                 float deltaY = ABS(([[self.w_self objectForKey:@"accelY"] floatValue] - prevAccelY));
//                                                 float deltaZ = ABS(([[self.w_self objectForKey:@"accelZ"] floatValue] - prevAccelZ));
//                                                 
//                                                 // Check if the derivative exceeds some sensitivity threshold
//                                                 // (Bigger value indicates stronger bump)
//                                                 // (Probably should use length of the vector instead of componentwise)
//                                                 if ( deltaX > 1 || deltaY > 1 || deltaZ > 1 ) {
////                                                     NSLog( @"BUMP %d:  %.3f, %.3f, %.3f", taps++, deltaX, deltaY, deltaZ);
//                                                     [self handleBumpEvent];
//                                                 }
//                                                 
////                                                 dispatch_async(dispatch_get_main_queue(), ^{
////                                                     [self.accelerometerReadings addObject:data];
////                                                 });
//                                             }];
//}

//- (void)handleBumpEvent {
//    NSDate *localDate = [NSDate date];
//    NSTimeInterval bumpDiff = [localDate timeIntervalSinceDate:lastBump];
//    lastBump = localDate;
////    NSLog(@"%f", bumpDiff);
//    if (bumpDiff > .5) {
//        NSLog(@"Bump!");
//        [self sendSong];
//    }
//}


////- (IBAction)sendButton {
//- (void)sendSong {
//    MPMediaItem *nowPlayingMediaItem = [[MPMusicPlayerController iPodMusicPlayer] nowPlayingItem];
//    float currTime = [MPMusicPlayerController iPodMusicPlayer].currentPlaybackTime;
//    // Works while not connected to an accessory
//    NSString *title = [nowPlayingMediaItem valueForProperty:MPMediaItemPropertyTitle];
//    NSString *artist = [nowPlayingMediaItem valueForProperty:MPMediaItemPropertyArtist];
//    if (!artist) {
//        artist = @"";
//    }
//    
//    NSString *urlString = [NSString stringWithFormat:@"http://192.241.169.214:5000/?title=%@&artist=%@&offset=%f&paused=%d",
//                           [title stringByReplacingOccurrencesOfString:@" " withString:@"+"],
//                           [artist stringByReplacingOccurrencesOfString:@" " withString:@"+"],
//                           currTime,
//                           isPaused];
//    NSURL *url = [NSURL URLWithString:urlString];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
//                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
//                                                       timeoutInterval:10];
//    NSError *requestError;
//    NSURLResponse *urlResponse = nil;
//    
//    if (isPaused) {
//        [[MPMusicPlayerController iPodMusicPlayer] play];
//        isPaused = false;
//    } else {
//        [[MPMusicPlayerController iPodMusicPlayer] pause];
//        isPaused = true;
//    }
//    
//    NSData *response1 = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
//    if (requestError) {
//        NSLog(@"Error! %@", requestError);
//    } else {
//        NSLog(@"Response: %@", urlResponse);
//    }
//    NSLog(@"Title: %@\nTime: %f\nArtist: %@", title, currTime, artist);
//}

- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals {
    NSLog(@"Peripherals: %@", peripherals);
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
//    [self.mgr scanForPeripheralsWithServices:[NSArray arrayWithObject:heartRate] options:scanOptions];
    NSLog(@"State: %ld", central.state);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
