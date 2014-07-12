//
//  CUViewController.m
//  Continuum
//
//  Created by Sam Bodanis on 12/07/2014.
//  Copyright (c) 2014 Sam Bodanis. All rights reserved.
//

#import "CUViewController.h"

@interface CUViewController ()

@end

@implementation CUViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // nil while connected to an accessory
    

}
- (IBAction)sendButton {
    MPMediaItem *nowPlayingMediaItem = [[MPMusicPlayerController iPodMusicPlayer] nowPlayingItem];
    float currTime = [MPMusicPlayerController iPodMusicPlayer].currentPlaybackTime;
    // Works while not connected to an accessory
    NSString *title = [nowPlayingMediaItem valueForProperty:MPMediaItemPropertyTitle];
    NSString *artist = [nowPlayingMediaItem valueForProperty:MPMediaItemPropertyArtist];
    
    NSString *urlString = [NSString stringWithFormat:@"http://192.241.169.214:5000/?title=%@&artist=%@&offset=%f",
                           [title stringByReplacingOccurrencesOfString:@" " withString:@"+"],
                           [artist stringByReplacingOccurrencesOfString:@" " withString:@"+"],
                           currTime];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    
    NSData *response1 = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    if (requestError) {
        NSLog(@"Error! %@", requestError);
    } else {
        NSLog(@"Response: %@", urlResponse);
    }
    NSLog(@"Title: %@\nTime: %f\nArtist: %@", title, currTime, artist);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
