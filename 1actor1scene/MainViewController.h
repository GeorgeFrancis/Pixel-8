//
//  MainViewController.h
//  1actor1scene
//
//  Created by George Francis on 24/03/2014.
//  Copyright (c) 2014 GeorgeFrancis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"


//@interface MainViewController : UIViewController
@interface MainViewController : MasterViewController <ADBannerViewDelegate>

@property BOOL paidApp;



@end
