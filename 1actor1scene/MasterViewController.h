//
//  MasterViewController.h
//  QuizTriviaGame
//
//  Created by George Francis on 22/03/2014.
//  Copyright (c) 2014 George Francis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface MasterViewController : UIViewController <ADBannerViewDelegate>

@property ADBannerView *adBanner;

@end
