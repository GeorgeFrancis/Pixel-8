//
//  Round1ViewController.h
//  1actor1scene
//
//  Created by George Francis on 08/04/2014.
//  Copyright (c) 2014 GeorgeFrancis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"


//@interface Round1ViewController : UIViewController  <UITextFieldDelegate>

@interface Round1ViewController : MasterViewController <ADBannerViewDelegate, UITextFieldDelegate>



    
@property (strong, nonatomic) IBOutlet UIImageView *gameComplete;
  
@property IBOutlet UIButton *nextRoundButton;
    
@property IBOutlet UIButton *button;
@property IBOutlet UIButton *next;
@property IBOutlet UIImageView *imageView;
//@property (weal, nonautomic) IBOutlet UITextField *typeAnswer;
//IBOutlet UITextField *typeAnswer;
    
@property IBOutlet UIImageView *gameOverBanner;
@property IBOutlet UIImageView *correctBanner;
//IBOutlet UIImageView *correct;


@property int ScoreNumber;
@property int newScore;
@property int savedScore;



@property int questionNumberStored;
@property int newScoreStored;

@property UIImageView *correct;


@property int mainInt;
@property int questionNumber;

//@property int levelNumber;

@property NSString *answer;
@property NSString *answer2;
@property (strong, nonatomic) IBOutlet UILabel *LevelLabel;

@property NSTimer *timer;
@property IBOutlet UILabel *seconds;
@property IBOutlet UILabel *totalScore;
@property (strong, nonatomic) IBOutlet UILabel *checkPointLabel;

@property (strong, nonatomic) IBOutlet UILabel *finalScoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *yourScoreLabel;

@property (weak, nonatomic) IBOutlet UITextField *typeAnswer;

//@property IBOutlet UITextField *typeAnswer;

//@property (retain, nonatomic) IBOutlet UIProgressView *myProgressView;

-(IBAction)runGame:(id)sender;
-(IBAction)nextLevel:(id)sender;

- (IBAction)nextRoundButton:(id)sender;

@end
