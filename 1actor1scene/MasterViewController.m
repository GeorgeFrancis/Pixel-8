//
//  MasterViewController.m
//  QuizTriviaGame
//
//  Created by George Francis on 22/03/2014.
//  Copyright (c) 2014 George Francis. All rights reserved.
//

#import "MasterViewController.h"

@interface MasterViewController ()

@end

@implementation MasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.adBanner) {
        self.adBanner = [[ADBannerView alloc]initWithFrame:CGRectZero];
//        [self.adBanner setCurrentContentSizeIdentifier:ADBannerContentSizeIdentifierPortrait];
        [self.adBanner setDelegate:self];
        [self.adBanner setAlpha:0];
        [self.view addSubview:self.adBanner];
        CGRect frame = self.adBanner.frame;
        frame.origin.y = self.view.frame.size.height-frame.size.height;
        [self.adBanner setFrame:frame];
        
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)bannerViewDidLoadAd:(ADBannerView *)banner {
    
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:1];
    [banner setAlpha:1];
    
    [UIView commitAnimations];
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    NSLog(@"Ad failed to load with Error: %@", error.localizedDescription);
    
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:1];
    [banner setAlpha:0];
    
    [UIView commitAnimations];
    
}

@end
