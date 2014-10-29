//
//  Round1ViewController.m
//  1actor1scene
//
//  Created by George Francis on 08/04/2014.
//  Copyright (c) 2014 GeorgeFrancis. All rights reserved.
//

#import "Round1ViewController.h"

@interface Round1ViewController ()


@end

@implementation Round1ViewController



- (void)viewDidLoad {
    
    
       
    
    [self.yourScoreLabel setHidden:YES];
    [self.finalScoreLabel setHidden:YES];
    [self.gameComplete setHidden:YES];
    self.typeAnswer.delegate = self;
    
    //self.levelNumber = 0;
  //  [self.LevelLabel setHidden:YES];
    
    
    [self setUpImages];
    [self prefersStatusBarHidden];
    
   // [self.nextRoundButton setHidden:YES];
  //  [self.button setHidden:YES];
  //  [self.next setHidden:YES];
    
    self.checkPointLabel.text = @"";
   self.questionNumberStored = (int) [[NSUserDefaults standardUserDefaults]integerForKey:@"savedQuestionNumber"];
    
    if (self.questionNumberStored > 2) {
        
        self.questionNumber = self.questionNumberStored - 1;
        self.newScore = (int) [[NSUserDefaults standardUserDefaults]integerForKey:@"highScore"];
        [self.totalScore setText:[NSString stringWithFormat:@"%d",self.newScore]];
      
        
        [self.nextRoundButton setHidden:YES];
        [self.button setHidden:YES];
        [self.next setHidden:YES];
        [self nextGame];

        
    }
    
    else
        
    {
        [self.button setHidden:NO];
        [self.nextRoundButton setHidden:YES];
        [self.next setHidden:YES];
    }
    
}


-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(nextGame) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(prepareForResignation) name:UIApplicationWillResignActiveNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)prepareForResignation
{
    [self.timer invalidate];
    self.questionNumber--;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.typeAnswer) {
        [textField resignFirstResponder];
        [self checkForCorrect];
        
        return NO;
    }
    return YES;
}



-(void)setUpImages {
    
    self.gameOverBanner = [[UIImageView alloc]initWithFrame:self.view.frame];
    [self.gameOverBanner setImage:[UIImage imageNamed:@"gameOverBanner.png"]];
    [self.gameOverBanner setAlpha:0];
    [self.view addSubview:self.gameOverBanner];
    
    self.correct = [[UIImageView alloc]initWithFrame:self.view.frame];
    [self.correct setImage:[UIImage imageNamed:@"correct.png"]];
    [self.correct setAlpha:0];
    [self.view addSubview:self.correct];
    
}

- (void)showGameOverAnimation{
    [UIView animateWithDuration:2.0
                     animations:^{
                         [self.gameOverBanner setAlpha:1];
                         
                     } completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:2.0 animations:^{
                             [self.gameOverBanner setAlpha:0];
                             
                             [self gameOver];
                             
                         }];
                         
                     }];
}

- (void)showCorrectAnimation{
    
    //  [typeAnswer endEditing:YES];
    [UIView animateWithDuration:1.0
                     animations:^{
                         [self.correct setAlpha:1];
                         
                     } completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:2.0
                                          animations:^{
                                              [self.correct setAlpha:0];
                                              
                                              [self clearTextField];
                                              [self.next setHidden:NO];
                                              [self.LevelLabel setHidden:NO];
                                              [self stopTimer];
                                              [self updateScore];
                                              // self.mainInt = 30;
                                              self.seconds.text = [NSString stringWithFormat:@"30"];
                                              
                                          }];
                         
                         
                     }];
    
}



-(IBAction)runGame:(id)sender{
    
    
    self.questionNumber = -1;
    self.newScoreStored = 0;
    [self nextGame];
    [self.button setHidden:YES];
    
}

-(IBAction)nextLevel:(id)sender {
    
    [self nextGame];
    
}

- (IBAction)nextRoundButton:(id)sender {
    
    [self nextGame];
    
}


-(void)gameOver {
    
    
    self.questionNumber = self.questionNumberStored -1;
    self.newScore = self.newScoreStored;
    [self.totalScore setText:[NSString stringWithFormat:@"%d",self.newScoreStored]];
    
    self.typeAnswer.text = @"";
    
    // [self nextGame];
    [self.next setHidden:NO];
    [self.typeAnswer resignFirstResponder];
    
}

-(void) cancelAnimation {
    
    [self.imageView stopAnimating];
}


-(IBAction)submit:(id)sender{
    
    
    [self checkForCorrect];
    
    
}


-(void)checkForCorrect {
    
    
    if ([self.typeAnswer.text  isEqualToString:self.answer] || [self.typeAnswer.text  isEqualToString:self.answer2] )  {
        
        
        [self showCorrectAnimation];
        [self.typeAnswer resignFirstResponder];
        
        
    }
    
    else
        
        [self clearTextField];
    
    
}


-(void)updateScore {
    
    self.ScoreNumber = self.mainInt;
    
    self.newScore = self.ScoreNumber + self.newScore;
    
    [self.totalScore setText:[NSString stringWithFormat:@"%d",self.newScore]];
    
    
}

-(void)clearTextField{
    
    self.typeAnswer.text =@"";
}


-(void)runTimer {
    
    [_seconds setHidden:NO];
    
    self.mainInt = 30;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    
}

-(void)countDown {
    
    _mainInt -=1;
    self.seconds.text = [NSString stringWithFormat:@"%i", self.mainInt];
    
    
    if (self.mainInt ==0 )
        
    {
        [self stopTimer];
        [self showGameOverAnimation];
        
    }
    
}

-(void)stopTimer {
    
    [self.timer invalidate];
    [self cancelAnimation];
    
}




-(void) nextGame {
    
    self.questionNumber ++;
    
    
    
    switch (self.questionNumber) {
        case 0:
            
            
            [[NSUserDefaults standardUserDefaults]setInteger:self.questionNumber forKey:@"savedQuestionNumber"];
            self.questionNumberStored = (int) [[NSUserDefaults standardUserDefaults]integerForKey:@"savedQuestionNumber"];
            
            
            [[NSUserDefaults standardUserDefaults]setInteger:self.newScore forKey:@"highScore"];
            self.newScoreStored = (int)[[NSUserDefaults standardUserDefaults]integerForKey:@"highScore"];
            [self.totalScore setText:[NSString stringWithFormat:@"%d",self.newScoreStored]];
            [self.next setHidden:YES];
            
            
            
            [self runTimer];
            [self startGame1];
            
            [self.LevelLabel setText:@"1"];
            
            break;
        case 1:
            [self.LevelLabel setText:@"2"];
            [self runTimer];
            [self startGame2];
            break;
        case 2:
           [self.LevelLabel setText:@"3"];
            [self runTimer];
            [self startGame3];
            break;
        case 3:
            [self.LevelLabel setText:@"4"];
            [self runTimer];
            [self startGame4];
            break;
        case 4:
            [self.LevelLabel setText:@"5"];
            [self runTimer];
            [self startGame5];
            break;
        case 5:
            
            [[NSUserDefaults standardUserDefaults]setInteger:self.questionNumber forKey:@"savedQuestionNumber"];
            self.questionNumberStored = (int) [[NSUserDefaults standardUserDefaults]integerForKey:@"savedQuestionNumber"];
            
            
            [[NSUserDefaults standardUserDefaults]setInteger:self.newScore forKey:@"highScore"];
            self.newScoreStored = (int)[[NSUserDefaults standardUserDefaults]integerForKey:@"highScore"];
            [self.totalScore setText:[NSString stringWithFormat:@"%d",self.newScoreStored]];
            [self.next setHidden:YES];
            [self.nextRoundButton setHidden:NO];
            
            self.checkPointLabel.text = @"1";
            
            
            
            break;
        case 6:
            [self.LevelLabel setText:@"6"];
            self.checkPointLabel.text = @"";
            [self.nextRoundButton setHidden:YES];
            [self runTimer];
            [self startGame47];
            
            break;
        case 7:
            [self.LevelLabel setText:@"7"];
            [self runTimer];
            [self startGame8];
            break;
        case 8:
            [self.LevelLabel setText:@"8"];
            [self runTimer];
            [self startGame9];
            break;
        case 9:
            [self.LevelLabel setText:@"9"];
            [self runTimer];
            [self startGame10];
            break;
        case 10:
            [self.LevelLabel setText:@"10"];
            [self runTimer];
            [self startGame11];
            
            
            break;
        case 11:
            
            [[NSUserDefaults standardUserDefaults]setInteger:self.questionNumber forKey:@"savedQuestionNumber"];
            self.questionNumberStored = (int) [[NSUserDefaults standardUserDefaults]integerForKey:@"savedQuestionNumber"];
            
            
            [[NSUserDefaults standardUserDefaults]setInteger:self.newScore forKey:@"highScore"];
            self.newScoreStored = (int)[[NSUserDefaults standardUserDefaults]integerForKey:@"highScore"];
            [self.totalScore setText:[NSString stringWithFormat:@"%d",self.newScoreStored]];
            [self.next setHidden:YES];
            [self.nextRoundButton setHidden:NO];
            
            self.checkPointLabel.text = @"2";
            
            
            
            
            break;
        case 12:
            [self.LevelLabel setText:@"11"];
            self.checkPointLabel.text = @"";
            [self.nextRoundButton setHidden:YES];
            [self runTimer];
            [self startGame13];
            break;
        case 13:
            [self.LevelLabel setText:@"12"];
            [self runTimer];
            [self startGame12];
            break;
        case 14:
            [self.LevelLabel setText:@"13"];
            [self runTimer];
            [self startGame14];
            break;
        case 15:
            [self.LevelLabel setText:@"14"];
            [self runTimer];
            [self startGame15];
            break;
        case 16:
            [self.LevelLabel setText:@"15"];
            [self runTimer];
            [self startGame16];
            break;
        case 17:
            
            [[NSUserDefaults standardUserDefaults]setInteger:self.questionNumber forKey:@"savedQuestionNumber"];
            self.questionNumberStored = (int) [[NSUserDefaults standardUserDefaults]integerForKey:@"savedQuestionNumber"];
            
            
            [[NSUserDefaults standardUserDefaults]setInteger:self.newScore forKey:@"highScore"];
            self.newScoreStored = (int)[[NSUserDefaults standardUserDefaults]integerForKey:@"highScore"];
            [self.totalScore setText:[NSString stringWithFormat:@"%d",self.newScoreStored]];
            [self.next setHidden:YES];
            [self.nextRoundButton setHidden:NO];
            
            
            self.checkPointLabel.text = @"3";
            
            break;
        case 18:
            [self.LevelLabel setText:@"16"];
            self.checkPointLabel.text = @"";
            [self.nextRoundButton setHidden:YES];
            [self runTimer];
            [self startGame18];
            break;
        case 19:
            [self.LevelLabel setText:@"17"];
            [self runTimer];
            [self startGame19];
            break;
        case 20:
            [self.LevelLabel setText:@"18"];
            [self runTimer];
            [self startGame20];
            break;
        case 21:
            [self.LevelLabel setText:@"19"];
            [self runTimer];
            [self startGame21];
            break;
        case 22:
            [self.LevelLabel setText:@"20"];
            [self runTimer];
            [self startGame22];
            break;
        case 23:
            [[NSUserDefaults standardUserDefaults]setInteger:self.questionNumber forKey:@"savedQuestionNumber"];
            self.questionNumberStored = (int) [[NSUserDefaults standardUserDefaults]integerForKey:@"savedQuestionNumber"];
            
            
            [[NSUserDefaults standardUserDefaults]setInteger:self.newScore forKey:@"highScore"];
            self.newScoreStored = (int)[[NSUserDefaults standardUserDefaults]integerForKey:@"highScore"];
            [self.totalScore setText:[NSString stringWithFormat:@"%d",self.newScoreStored]];
            [self.next setHidden:YES];
            [self.nextRoundButton setHidden:NO];
            
            self.checkPointLabel.text = @"4";
            
            
            break;
        case 24:
            [self.LevelLabel setText:@"21"];
            self.checkPointLabel.text = @"";
            [self.nextRoundButton setHidden:YES];
            [self runTimer];
            [self startGame24];
            break;
        case 25:
            [self.LevelLabel setText:@"22"];
            [self runTimer];
            [self startGame25];
            break;
        case 26:
            [self.LevelLabel setText:@"23"];
            [self runTimer];
            [self startGame26];
            break;
        case 27:
            [self.LevelLabel setText:@"24"];
            [self runTimer];
            [self startGame27];
            break;
        case 28:
            [self.LevelLabel setText:@"25"];
            [self runTimer];
            [self startGame28];
            break;
        case 29:
            
            [[NSUserDefaults standardUserDefaults]setInteger:self.questionNumber forKey:@"savedQuestionNumber"];
            self.questionNumberStored = (int) [[NSUserDefaults standardUserDefaults]integerForKey:@"savedQuestionNumber"];
            
            
            [[NSUserDefaults standardUserDefaults]setInteger:self.newScore forKey:@"highScore"];
            self.newScoreStored = (int)[[NSUserDefaults standardUserDefaults]integerForKey:@"highScore"];
            [self.totalScore setText:[NSString stringWithFormat:@"%d",self.newScoreStored]];
            [self.next setHidden:YES];
            [self.nextRoundButton setHidden:NO];
            
            
            self.checkPointLabel.text = @"5";
            
            
            break;
        case 30:
            [self.LevelLabel setText:@"26"];
            self.checkPointLabel.text = @"";
            [self.nextRoundButton setHidden:YES];
            [self runTimer];
            [self startGame30];
            break;
        case 31:
            [self.LevelLabel setText:@"27"];
            [self runTimer];
            [self startGame31];
            break;
        case 32:
            [self.LevelLabel setText:@"28"];
            [self runTimer];
            [self startGame32];
            break;
        case 33:
            [self.LevelLabel setText:@"29"];
            [self runTimer];
            [self startGame33];
            break;
        case 34:
            [self.LevelLabel setText:@"30"];
            [self runTimer];
            [self startGame34];
            break;
        case 35:
            
            [[NSUserDefaults standardUserDefaults]setInteger:self.questionNumber forKey:@"savedQuestionNumber"];
            self.questionNumberStored = (int) [[NSUserDefaults standardUserDefaults]integerForKey:@"savedQuestionNumber"];
            
            
            [[NSUserDefaults standardUserDefaults]setInteger:self.newScore forKey:@"highScore"];
            self.newScoreStored = (int)[[NSUserDefaults standardUserDefaults]integerForKey:@"highScore"];
            [self.totalScore setText:[NSString stringWithFormat:@"%d",self.newScoreStored]];
            [self.next setHidden:YES];
            [self.nextRoundButton setHidden:NO];
            
            self.checkPointLabel.text = @"6";
            
            
            
            break;
        case 36:
            [self.LevelLabel setText:@"31"];
            self.checkPointLabel.text = @"";
            [self.nextRoundButton setHidden:YES];
            [self runTimer];
            [self startGame36];
            break;
        case 37:
            [self.LevelLabel setText:@"32"];
            [self runTimer];
            [self startGame37];
            break;
        case 38:
            [self.LevelLabel setText:@"33"];
            [self runTimer];
            [self startGame38];
            break;
        case 39:
            [self.LevelLabel setText:@"34"];
            [self runTimer];
            [self startGame39];
            break;
        case 40:
            [self.LevelLabel setText:@"35"];
            [self runTimer];
            [self startGame40];
            break;
        case 41:
            
            [[NSUserDefaults standardUserDefaults]setInteger:self.questionNumber forKey:@"savedQuestionNumber"];
            self.questionNumberStored = (int) [[NSUserDefaults standardUserDefaults]integerForKey:@"savedQuestionNumber"];
            
            
            [[NSUserDefaults standardUserDefaults]setInteger:self.newScore forKey:@"highScore"];
            self.newScoreStored = (int)[[NSUserDefaults standardUserDefaults]integerForKey:@"highScore"];
            [self.totalScore setText:[NSString stringWithFormat:@"%d",self.newScoreStored]];
            [self.next setHidden:YES];
            [self.nextRoundButton setHidden:NO];
            self.checkPointLabel.text = @"7";
            
            
            break;
        case 42:
            [self.LevelLabel setText:@"36"];
            self.checkPointLabel.text = @"";
            [self.nextRoundButton setHidden:YES];
            [self runTimer];
            [self startGame42];
            break;
        case 43:
            [self.LevelLabel setText:@"37"];
            [self runTimer];
            [self startGame43];
            break;
        case 44:
            [self.LevelLabel setText:@"38"];
            [self runTimer];
            [self startGame44];
            break;
        case 45:
            [self.LevelLabel setText:@"39"];
            [self runTimer];
            [self startGame45];
            break;
        case 46:
            [self.LevelLabel setText:@"40"];
            [self runTimer];
            [self startGame29];
            break;
        case 47:
            
            [[NSUserDefaults standardUserDefaults]setInteger:self.questionNumber forKey:@"savedQuestionNumber"];
            self.questionNumberStored = (int) [[NSUserDefaults standardUserDefaults]integerForKey:@"savedQuestionNumber"];
            
            
            [[NSUserDefaults standardUserDefaults]setInteger:self.newScore forKey:@"highScore"];
            self.newScoreStored = (int)[[NSUserDefaults standardUserDefaults]integerForKey:@"highScore"];
            [self.totalScore setText:[NSString stringWithFormat:@"%d",self.newScoreStored]];
            [self.next setHidden:YES];
            [self.nextRoundButton setHidden:NO];
            
            self.checkPointLabel.text = @"8";
            
            break;
        case 48:
            [self.LevelLabel setText:@"41"];
            self.checkPointLabel.text = @"";
            [self.nextRoundButton setHidden:YES];
            [self runTimer];
            [self startGame41];
            break;
        case 49:
            [self.LevelLabel setText:@"42"];
            [self runTimer];
            [self startGame6];
            break;
        case 50:
            [self.LevelLabel setText:@"43"];
            [self runTimer];
            [self startGame47];
            break;
        case 51:
            [self.LevelLabel setText:@"44"];
            [self runTimer];
            [self startGame17];
            break;
        case 52:
            [self.LevelLabel setText:@"45"];
            [self runTimer];
            [self startGame23];
            break;
        case 53:
            [self.gameComplete setHidden:NO];
            [self.finalScoreLabel setHidden:NO];
            [self.yourScoreLabel setHidden:NO];
            [self.finalScoreLabel setText:[NSString stringWithFormat:@"%d",self.newScore]];
           
          
            break;
            
            
            
        default:
            break;
            
            
    }
    
    
}


-(void)startGame1  {
    
    [self.next setHidden:YES];
    
    self.answer =(@"brad pitt");
    self.answer2 = (@"Brad Pitt");
    
    
    
    self.imageView.animationImages = [NSArray arrayWithObjects:
                                      
                                      
                                      
                                      [UIImage imageNamed:@"bradPitt_014.png"],
                                      [UIImage imageNamed:@"bradPitt_013.png"],
                                      [UIImage imageNamed:@"bradPitt_012.png"],
                                      [UIImage imageNamed:@"bradPitt_011.png"],
                                      [UIImage imageNamed:@"bradPitt_010.png"],
                                      [UIImage imageNamed:@"bradPitt_009.png"],
                                      [UIImage imageNamed:@"bradPitt_008.png"],
                                      [UIImage imageNamed:@"bradPitt_007.png"],
                                      [UIImage imageNamed:@"bradPitt_006.png"],
                                      [UIImage imageNamed:@"bradPitt_005.png"],
                                      [UIImage imageNamed:@"bradPitt_004.png"],
                                      [UIImage imageNamed:@"bradPitt_003.png"],
                                      [UIImage imageNamed:@"bradPitt_002.png"],
                                      [UIImage imageNamed:@"bradPitt_001.png"],nil];
    
    
    self.imageView.animationDuration = 30.0;
    
    self.imageView.animationRepeatCount = 1;
    
    [self.imageView startAnimating];
    
    
    
    
    
}



-(void)startGame2  {
    
    
    //  NSArray *images = [Questions imagesViewForQuestion:1];
    
    [self.next setHidden:YES];
    
    //[self runTimer];
    
    
    self.answer = @"channing tatum";
    self.answer2 = @"Channing Tatum";
    
    self.imageView.animationImages = [NSArray arrayWithObjects:
                                      
                                      
                                      [UIImage imageNamed:@"channingTatum_014.png"],
                                      [UIImage imageNamed:@"channingTatum_013.png"],
                                      [UIImage imageNamed:@"channingTatum_012.png"],
                                      [UIImage imageNamed:@"channingTatum_011.png"],
                                      [UIImage imageNamed:@"channingTatum_010.png"],
                                      [UIImage imageNamed:@"channingTatum_009.png"],
                                      [UIImage imageNamed:@"channingTatum_008.png"],
                                      [UIImage imageNamed:@"channingTatum_007.png"],
                                      [UIImage imageNamed:@"channingTatum_006.png"],
                                      [UIImage imageNamed:@"channingTatum_005.png"],
                                      [UIImage imageNamed:@"channingTatum_004.png"],
                                      [UIImage imageNamed:@"channingTatum_003.png"],
                                      [UIImage imageNamed:@"channingTatum_002.png"],
                                      [UIImage imageNamed:@"channingTatum_001.png"],nil];
    
    
    self.imageView.animationDuration = 30.0;
    
    self.imageView.animationRepeatCount = 1;
    
    [self.imageView startAnimating];
    
    
    
    
    
}

-(void)startGame3  {
    
    [self.next setHidden:YES];
    
    // [self runTimer];
    
    
    self.answer =@"christian bale";
    
    self.imageView.animationImages = [NSArray arrayWithObjects:
                                      
                                      
                                      [UIImage imageNamed:@"christianBale_014.png"],
                                      [UIImage imageNamed:@"christianBale_013.png"],
                                      [UIImage imageNamed:@"christianBale_012.png"],
                                      [UIImage imageNamed:@"christianBale_011.png"],
                                      [UIImage imageNamed:@"christianBale_010.png"],
                                      [UIImage imageNamed:@"christianBale_009.png"],
                                      [UIImage imageNamed:@"christianBale_008.png"],
                                      [UIImage imageNamed:@"christianBale_007.png"],
                                      [UIImage imageNamed:@"christianBale_006.png"],
                                      [UIImage imageNamed:@"christianBale_005.png"],
                                      [UIImage imageNamed:@"christianBale_004.png"],
                                      [UIImage imageNamed:@"christianBale_003.png"],
                                      [UIImage imageNamed:@"christianBale_002.png"],
                                      [UIImage imageNamed:@"christianBale_001.png"],nil];
    
    self.imageView.animationDuration = 30.0;
    
    self.imageView.animationRepeatCount = 1;
    
    [self.imageView startAnimating];
    
    
    
    
    
}


-(void)startGame4  {
    
    [self.next setHidden:YES];
    
    //  [self runTimer];
    
    
    self.answer =@"ben affleck";
    
    
    self.imageView.animationImages = [NSArray arrayWithObjects:
                                      
                                      [UIImage imageNamed:@"benAfleck_014.png"],
                                      [UIImage imageNamed:@"benAfleck_013.png"],
                                      [UIImage imageNamed:@"benAfleck_012.png"],
                                      [UIImage imageNamed:@"benAfleck_011.png"],
                                      [UIImage imageNamed:@"benAfleck_010.png"],
                                      [UIImage imageNamed:@"benAfleck_009.png"],
                                      [UIImage imageNamed:@"benAfleck_008.png"],
                                      [UIImage imageNamed:@"benAfleck_007.png"],
                                      [UIImage imageNamed:@"benAfleck_006.png"],
                                      [UIImage imageNamed:@"benAfleck_005.png"],
                                      [UIImage imageNamed:@"benAfleck_004.png"],
                                      [UIImage imageNamed:@"benAfleck_003.png"],
                                      [UIImage imageNamed:@"benAfleck_002.png"],
                                      [UIImage imageNamed:@"benAfleck_001.png"],nil];
    
    
    self.imageView.animationDuration = 30.0;
    
    self.imageView.animationRepeatCount = 1;
    
    [self.imageView startAnimating];
    
    
    
    
    
}



-(void)startGame5  {
    
    [self.next setHidden:YES];
    
    self.answer =@"will smith";
    
    
    self.imageView.animationImages = [NSArray arrayWithObjects:
                                      
                                      
                                      [UIImage imageNamed:@"willSmith_014.png"],
                                      [UIImage imageNamed:@"willSmith_013.png"],
                                      [UIImage imageNamed:@"willSmith_012.png"],
                                      [UIImage imageNamed:@"willSmith_011.png"],
                                      [UIImage imageNamed:@"willSmith_010.png"],
                                      [UIImage imageNamed:@"willSmith_009.png"],
                                      [UIImage imageNamed:@"willSmith_008.png"],
                                      [UIImage imageNamed:@"willSmith_007.png"],
                                      [UIImage imageNamed:@"willSmith_006.png"],
                                      [UIImage imageNamed:@"willSmith_005.png"],
                                      [UIImage imageNamed:@"willSmith_004.png"],
                                      [UIImage imageNamed:@"willSmith_003.png"],
                                      [UIImage imageNamed:@"willSmith_002.png"],
                                      [UIImage imageNamed:@"willSmith_001.png"],nil];
    
    self.imageView.animationDuration = 30.0;
    
    self.imageView.animationRepeatCount = 1;
    
    [self.imageView startAnimating];
    
    
    
    
}



-(void)startGame6  {
    
    //  [self runTimer];
    [self.next setHidden:YES];
    
    self.answer =@"kate winslet";
    
    
    self.imageView.animationImages = [NSArray arrayWithObjects:
                                      
                                      
                                      [UIImage imageNamed:@"kateWinslet_014.png"],
                                      [UIImage imageNamed:@"kateWinslet_013.png"],
                                      [UIImage imageNamed:@"kateWinslet_012.png"],
                                      [UIImage imageNamed:@"kateWinslet_011.png"],
                                      [UIImage imageNamed:@"kateWinslet_010.png"],
                                      [UIImage imageNamed:@"kateWinslet_009.png"],
                                      [UIImage imageNamed:@"kateWinslet_008.png"],
                                      [UIImage imageNamed:@"kateWinslet_007.png"],
                                      [UIImage imageNamed:@"kateWinslet_006.png"],
                                      [UIImage imageNamed:@"kateWinslet_005.png"],
                                      [UIImage imageNamed:@"kateWinslet_004.png"],
                                      [UIImage imageNamed:@"kateWinslet_003.png"],
                                      [UIImage imageNamed:@"kateWinslet_002.png"],
                                      [UIImage imageNamed:@"kateWinslet_001.png"],nil];
    
    self.imageView.animationDuration = 30.0;
    
    self.imageView.animationRepeatCount = 1;
    
    [self.imageView startAnimating];
    
    
    
    
    
}


-(void)startGame8  {
    
    //  [self runTimer];
    [self.next setHidden:YES];
    
    self.answer =@"ben stiller";
    
    
    self.imageView.animationImages = [NSArray arrayWithObjects:
                                      
                                      
                                      [UIImage imageNamed:@"benStiller_014.png"],
                                      [UIImage imageNamed:@"benStiller_013.png"],
                                      [UIImage imageNamed:@"benStiller_012.png"],
                                      [UIImage imageNamed:@"benStiller_011.png"],
                                      [UIImage imageNamed:@"benStiller_010.png"],
                                      [UIImage imageNamed:@"benStiller_009.png"],
                                      [UIImage imageNamed:@"benStiller_008.png"],
                                      [UIImage imageNamed:@"benStiller_007.png"],
                                      [UIImage imageNamed:@"benStiller_006.png"],
                                      [UIImage imageNamed:@"benStiller_005.png"],
                                      [UIImage imageNamed:@"benStiller_004.png"],
                                      [UIImage imageNamed:@"benStiller_003.png"],
                                      [UIImage imageNamed:@"benStiller_002.png"],
                                      [UIImage imageNamed:@"benStiller_001.png"],nil];
    
    self.imageView.animationDuration = 30.0;
    
    self.imageView.animationRepeatCount = 1;
    
    [self.imageView startAnimating];
    
    
    
    
    
}


-(void)startGame9  {
    
    //  [self runTimer];
    [self.next setHidden:YES];
    
    self.answer =@"chris evans";
    
    
    self.imageView.animationImages = [NSArray arrayWithObjects:
                                      
                                      
                                      [UIImage imageNamed:@"chrisEvans_014.png"],
                                      [UIImage imageNamed:@"chrisEvans_013.png"],
                                      [UIImage imageNamed:@"chrisEvans_012.png"],
                                      [UIImage imageNamed:@"chrisEvans_011.png"],
                                      [UIImage imageNamed:@"chrisEvans_010.png"],
                                      [UIImage imageNamed:@"chrisEvans_009.png"],
                                      [UIImage imageNamed:@"chrisEvans_008.png"],
                                      [UIImage imageNamed:@"chrisEvans_007.png"],
                                      [UIImage imageNamed:@"chrisEvans_006.png"],
                                      [UIImage imageNamed:@"chrisEvans_005.png"],
                                      [UIImage imageNamed:@"chrisEvans_004.png"],
                                      [UIImage imageNamed:@"chrisEvans_003.png"],
                                      [UIImage imageNamed:@"chrisEvans_002.png"],
                                      [UIImage imageNamed:@"chrisEvans_001.png"],nil];
    
    self.imageView.animationDuration = 30.0;
    
    self.imageView.animationRepeatCount = 1;
    
    [self.imageView startAnimating];
    
    
    
    
    
}


-(void)startGame10  {
    
    //  [self runTimer];
    [self.next setHidden:YES];
    
    self.answer =@"daniel radcliffe";
    
    
    self.imageView.animationImages = [NSArray arrayWithObjects:
                                      
                                      
                                      [UIImage imageNamed:@"danielRadcliffe_014.png"],
                                      [UIImage imageNamed:@"danielRadcliffe_013.png"],
                                      [UIImage imageNamed:@"danielRadcliffe_012.png"],
                                      [UIImage imageNamed:@"danielRadcliffe_011.png"],
                                      [UIImage imageNamed:@"danielRadcliffe_010.png"],
                                      [UIImage imageNamed:@"danielRadcliffe_009.png"],
                                      [UIImage imageNamed:@"danielRadcliffe_008.png"],
                                      [UIImage imageNamed:@"danielRadcliffe_007.png"],
                                      [UIImage imageNamed:@"danielRadcliffe_006.png"],
                                      [UIImage imageNamed:@"danielRadcliffe_005.png"],
                                      [UIImage imageNamed:@"danielRadcliffe_004.png"],
                                      [UIImage imageNamed:@"danielRadcliffe_003.png"],
                                      [UIImage imageNamed:@"danielRadcliffe_002.png"],
                                      [UIImage imageNamed:@"danielRadcliffe_001.png"],nil];
    
    self.imageView.animationDuration = 30.0;
    
    self.imageView.animationRepeatCount = 1;
    
    [self.imageView startAnimating];
    
    
    
    
    
}

-(void)startGame11  {
    
    //  [self runTimer];
    [self.next setHidden:YES];
    
    self.answer =@"bill murray";
    
    
    self.imageView.animationImages = [NSArray arrayWithObjects:
                                      
                                      [UIImage imageNamed:@"billMurray_014.png"],
                                      [UIImage imageNamed:@"billMurray_013.png"],
                                      [UIImage imageNamed:@"billMurray_012.png"],
                                      [UIImage imageNamed:@"billMurray_011.png"],
                                      [UIImage imageNamed:@"billMurray_010.png"],
                                      [UIImage imageNamed:@"billMurray_009.png"],
                                      [UIImage imageNamed:@"billMurray_008.png"],
                                      [UIImage imageNamed:@"billMurray_007.png"],
                                      [UIImage imageNamed:@"billMurray_006.png"],
                                      [UIImage imageNamed:@"billMurray_005.png"],
                                      [UIImage imageNamed:@"billMurray_004.png"],
                                      [UIImage imageNamed:@"billMurray_003.png"],
                                      [UIImage imageNamed:@"billMurray_002.png"],
                                      [UIImage imageNamed:@"billMurray_001.png"],nil];
    
    self.imageView.animationDuration = 30.0;
    
    self.imageView.animationRepeatCount = 1;
    
    [self.imageView startAnimating];
    
    
    
    
    
}


-(void)startGame12  {
    
    //  [self runTimer];
    [self.next setHidden:YES];
    
    self.answer =@"samuel l jackson";
    
    
    self.imageView.animationImages = [NSArray arrayWithObjects:
                                      
                                      [UIImage imageNamed:@"samuelLJackson_014.png"],
                                      [UIImage imageNamed:@"samuelLJackson_013.png"],
                                      [UIImage imageNamed:@"samuelLJackson_012.png"],
                                      [UIImage imageNamed:@"samuelLJackson_011.png"],
                                      [UIImage imageNamed:@"samuelLJackson_010.png"],
                                      [UIImage imageNamed:@"samuelLJackson_009.png"],
                                      [UIImage imageNamed:@"samuelLJackson_008.png"],
                                      [UIImage imageNamed:@"samuelLJackson_007.png"],
                                      [UIImage imageNamed:@"samuelLJackson_006.png"],
                                      [UIImage imageNamed:@"samuelLJackson_005.png"],
                                      [UIImage imageNamed:@"samuelLJackson_004.png"],
                                      [UIImage imageNamed:@"samuelLJackson_003.png"],
                                      [UIImage imageNamed:@"samuelLJackson_002.png"],
                                      [UIImage imageNamed:@"samuelLJackson_001.png"],nil];
    
    self.imageView.animationDuration = 30.0;
    
    self.imageView.animationRepeatCount = 1;
    
    [self.imageView startAnimating];
    
    
    
    
    
}


-(void)startGame13  {
    
    //  [self runTimer];
    [self.next setHidden:YES];
    
    self.answer =@"tim allen";
    
    
    self.imageView.animationImages = [NSArray arrayWithObjects:
                                      
                                      [UIImage imageNamed:@"timAllen_014.png"],
                                      [UIImage imageNamed:@"timAllen_013.png"],
                                      [UIImage imageNamed:@"timAllen_012.png"],
                                      [UIImage imageNamed:@"timAllen_011.png"],
                                      [UIImage imageNamed:@"timAllen_010.png"],
                                      [UIImage imageNamed:@"timAllen_009.png"],
                                      [UIImage imageNamed:@"timAllen_008.png"],
                                      [UIImage imageNamed:@"timAllen_007.png"],
                                      [UIImage imageNamed:@"timAllen_006.png"],
                                      [UIImage imageNamed:@"timAllen_005.png"],
                                      [UIImage imageNamed:@"timAllen_004.png"],
                                      [UIImage imageNamed:@"timAllen_003.png"],
                                      [UIImage imageNamed:@"timAllen_002.png"],
                                      [UIImage imageNamed:@"timAllen_001.png"],nil];
                                     
    self.imageView.animationDuration = 30.0;
    
    self.imageView.animationRepeatCount = 1;
    
    [self.imageView startAnimating];
    
    
    
    
    
}


-(void)startGame14  {
    
    //  [self runTimer];
    [self.next setHidden:YES];
    
    self.answer =@"leonardo dicaprio";
    
    
    self.imageView.animationImages = [NSArray arrayWithObjects:
                                      
                                      
                                      [UIImage imageNamed:@"leonardoDiCaprio_014.png"],
                                      [UIImage imageNamed:@"leonardoDiCaprio_013.png"],
                                      [UIImage imageNamed:@"leonardoDiCaprio_012.png"],
                                      [UIImage imageNamed:@"leonardoDiCaprio_011.png"],
                                      [UIImage imageNamed:@"leonardoDiCaprio_010.png"],
                                      [UIImage imageNamed:@"leonardoDiCaprio_009.png"],
                                      [UIImage imageNamed:@"leonardoDiCaprio_008.png"],
                                      [UIImage imageNamed:@"leonardoDiCaprio_007.png"],
                                      [UIImage imageNamed:@"leonardoDiCaprio_006.png"],
                                      [UIImage imageNamed:@"leonardoDiCaprio_005.png"],
                                      [UIImage imageNamed:@"leonardoDiCaprio_004.png"],
                                      [UIImage imageNamed:@"leonardoDiCaprio_003.png"],
                                      [UIImage imageNamed:@"leonardoDiCaprio_002.png"],
                                      [UIImage imageNamed:@"leonardoDiCaprio_001.png"],nil];
    
    self.imageView.animationDuration = 30.0;
    
    self.imageView.animationRepeatCount = 1;
    
    [self.imageView startAnimating];
    
    
    
    
    
}


-(void)startGame15  {
    
    //  [self runTimer];
    [self.next setHidden:YES];
    
    self.answer =@"matt damon";
    
    
    self.imageView.animationImages = [NSArray arrayWithObjects:
                                      
                                      
                                      [UIImage imageNamed:@"mattDamon_014.png"],
                                      [UIImage imageNamed:@"mattDamon_013.png"],
                                      [UIImage imageNamed:@"mattDamon_012.png"],
                                      [UIImage imageNamed:@"mattDamon_011.png"],
                                      [UIImage imageNamed:@"mattDamon_010.png"],
                                      [UIImage imageNamed:@"mattDamon_009.png"],
                                      [UIImage imageNamed:@"mattDamon_008.png"],
                                      [UIImage imageNamed:@"mattDamon_007.png"],
                                      [UIImage imageNamed:@"mattDamon_006.png"],
                                      [UIImage imageNamed:@"mattDamon_005.png"],
                                      [UIImage imageNamed:@"mattDamon_004.png"],
                                      [UIImage imageNamed:@"mattDamon_003.png"],
                                      [UIImage imageNamed:@"mattDamon_002.png"],
                                      [UIImage imageNamed:@"mattDamon_001.png"],nil];
    
    self.imageView.animationDuration = 30.0;
    
    self.imageView.animationRepeatCount = 1;
    
    [self.imageView startAnimating];
    
    
    
    
    
}


-(void)startGame16  {
    
    //  [self runTimer];
    [self.next setHidden:YES];
    
    self.answer =@"zac efron";
    
    
    self.imageView.animationImages = [NSArray arrayWithObjects:
                                      
                                      [UIImage imageNamed:@"zacEfron_014.png"],
                                      [UIImage imageNamed:@"zacEfron_013.png"],
                                      [UIImage imageNamed:@"zacEfron_012.png"],
                                      [UIImage imageNamed:@"zacEfron_011.png"],
                                      [UIImage imageNamed:@"zacEfron_010.png"],
                                      [UIImage imageNamed:@"zacEfron_009.png"],
                                      [UIImage imageNamed:@"zacEfron_008.png"],
                                      [UIImage imageNamed:@"zacEfron_007.png"],
                                      [UIImage imageNamed:@"zacEfron_006.png"],
                                      [UIImage imageNamed:@"zacEfron_005.png"],
                                      [UIImage imageNamed:@"zacEfron_004.png"],
                                      [UIImage imageNamed:@"zacEfron_003.png"],
                                      [UIImage imageNamed:@"zacEfron_002.png"],
                                      [UIImage imageNamed:@"zacEfron_001.png"],nil];
    
                               
    
    self.imageView.animationDuration = 30.0;
    
    self.imageView.animationRepeatCount = 1;
    
    [self.imageView startAnimating];
    
    
    
    
    
}


-(void)startGame17  {
    
    //  [self runTimer];
    [self.next setHidden:YES];
    
    self.answer =@"chris hemsworth";
    
    
    self.imageView.animationImages = [NSArray arrayWithObjects:
                                      
                                      
                                      [UIImage imageNamed:@"chrisHemsworth_014.png"],
                                      [UIImage imageNamed:@"chrisHemsworth_013.png"],
                                      [UIImage imageNamed:@"chrisHemsworth_012.png"],
                                      [UIImage imageNamed:@"chrisHemsworth_011.png"],
                                      [UIImage imageNamed:@"chrisHemsworth_010.png"],
                                      [UIImage imageNamed:@"chrisHemsworth_009.png"],
                                      [UIImage imageNamed:@"chrisHemsworth_008.png"],
                                      [UIImage imageNamed:@"chrisHemsworth_007.png"],
                                      [UIImage imageNamed:@"chrisHemsworth_006.png"],
                                      [UIImage imageNamed:@"chrisHemsworth_005.png"],
                                      [UIImage imageNamed:@"chrisHemsworth_004.png"],
                                      [UIImage imageNamed:@"chrisHemsworth_003.png"],
                                      [UIImage imageNamed:@"chrisHemsworth_002.png"],
                                      [UIImage imageNamed:@"chrisHemsworth_001.png"],nil];
    
    self.imageView.animationDuration = 30.0;
    
    self.imageView.animationRepeatCount = 1;
    
    [self.imageView startAnimating];
    
    
    
    
    
}


-(void)startGame18  {
    
    //  [self runTimer];
    [self.next setHidden:YES];
    
    self.answer =@"clint eastwood";
    
    
    self.imageView.animationImages = [NSArray arrayWithObjects:
                                      
                                      
                                      [UIImage imageNamed:@"clintEastwood_014.png"],
                                      [UIImage imageNamed:@"clintEastwood_013.png"],
                                      [UIImage imageNamed:@"clintEastwood_012.png"],
                                      [UIImage imageNamed:@"clintEastwood_011.png"],
                                      [UIImage imageNamed:@"clintEastwood_010.png"],
                                      [UIImage imageNamed:@"clintEastwood_009.png"],
                                      [UIImage imageNamed:@"clintEastwood_008.png"],
                                      [UIImage imageNamed:@"clintEastwood_007.png"],
                                      [UIImage imageNamed:@"clintEastwood_006.png"],
                                      [UIImage imageNamed:@"clintEastwood_005.png"],
                                      [UIImage imageNamed:@"clintEastwood_004.png"],
                                      [UIImage imageNamed:@"clintEastwood_003.png"],
                                      [UIImage imageNamed:@"clintEastwood_002.png"],
                                      [UIImage imageNamed:@"clintEastwood_001.png"],nil];
    
    self.imageView.animationDuration = 30.0;
    
    self.imageView.animationRepeatCount = 1;
    
    [self.imageView startAnimating];
    
    
    
    
    
}



-(void)startGame20  {
    
    //  [self runTimer];
    [self.next setHidden:YES];
    
    self.answer =@"colin farrell";
    
    
    self.imageView.animationImages = [NSArray arrayWithObjects:
                                      
                                      
                                      [UIImage imageNamed:@"colinFarrell_014.png"],
                                      [UIImage imageNamed:@"colinFarrell_013.png"],
                                      [UIImage imageNamed:@"colinFarrell_012.png"],
                                      [UIImage imageNamed:@"colinFarrell_011.png"],
                                      [UIImage imageNamed:@"colinFarrell_010.png"],
                                      [UIImage imageNamed:@"colinFarrell_009.png"],
                                      [UIImage imageNamed:@"colinFarrell_008.png"],
                                      [UIImage imageNamed:@"colinFarrell_007.png"],
                                      [UIImage imageNamed:@"colinFarrell_006.png"],
                                      [UIImage imageNamed:@"colinFarrell_005.png"],
                                      [UIImage imageNamed:@"colinFarrell_004.png"],
                                      [UIImage imageNamed:@"colinFarrell_003.png"],
                                      [UIImage imageNamed:@"colinFarrell_002.png"],
                                      [UIImage imageNamed:@"colinFarrell_001.png"],nil];
    
    self.imageView.animationDuration = 30.0;
    
    self.imageView.animationRepeatCount = 1;
    
    [self.imageView startAnimating];
    
    
    
    
    
}

-(void)startGame21  {
    
    //  [self runTimer];
    
    [self.next setHidden:YES];
    self.answer =@"harrison ford";
    
    
    self.imageView.animationImages = [NSArray arrayWithObjects:
                                      
                                      [UIImage imageNamed:@"harrisonFord_014.png"],
                                      [UIImage imageNamed:@"harrisonFord_013.png"],
                                      [UIImage imageNamed:@"harrisonFord_012.png"],
                                      [UIImage imageNamed:@"harrisonFord_011.png"],
                                      [UIImage imageNamed:@"harrisonFord_010.png"],
                                      [UIImage imageNamed:@"harrisonFord_009.png"],
                                      [UIImage imageNamed:@"harrisonFord_008.png"],
                                      [UIImage imageNamed:@"harrisonFord_007.png"],
                                      [UIImage imageNamed:@"harrisonFord_006.png"],
                                      [UIImage imageNamed:@"harrisonFord_005.png"],
                                      [UIImage imageNamed:@"harrisonFord_004.png"],
                                      [UIImage imageNamed:@"harrisonFord_003.png"],
                                      [UIImage imageNamed:@"harrisonFord_002.png"],
                                      [UIImage imageNamed:@"harrisonFord_001.png"],nil];

    
    self.imageView.animationDuration = 30.0;
    
    self.imageView.animationRepeatCount = 1;
    
    [self.imageView startAnimating];
    
    
    
    
    
}

-(void)startGame22  {
    
    //  [self runTimer];
    [self.next setHidden:YES];
    
    self.answer =@"hugh jackman";
    
    
    self.imageView.animationImages = [NSArray arrayWithObjects:
                                      
                                      [UIImage imageNamed:@"hughJackman_014.png"],
                                      [UIImage imageNamed:@"hughJackman_013.png"],
                                      [UIImage imageNamed:@"hughJackman_012.png"],
                                      [UIImage imageNamed:@"hughJackman_011.png"],
                                      [UIImage imageNamed:@"hughJackman_010.png"],
                                      [UIImage imageNamed:@"hughJackman_009.png"],
                                      [UIImage imageNamed:@"hughJackman_008.png"],
                                      [UIImage imageNamed:@"hughJackman_007.png"],
                                      [UIImage imageNamed:@"hughJackman_006.png"],
                                      [UIImage imageNamed:@"hughJackman_005.png"],
                                      [UIImage imageNamed:@"hughJackman_004.png"],
                                      [UIImage imageNamed:@"hughJackman_003.png"],
                                      [UIImage imageNamed:@"hughJackman_002.png"],
                                      [UIImage imageNamed:@"hughJackman_001.png"],nil];
                                    
    
    self.imageView.animationDuration = 30.0;
    
    self.imageView.animationRepeatCount = 1;
    
    [self.imageView startAnimating];
    
    
    
    
    
}

-(void)startGame23  {
    
    //  [self runTimer];
    [self.next setHidden:YES];
    
    self.answer =@"jared leto";
    
    
    self.imageView.animationImages = [NSArray arrayWithObjects:
                                      
                                      [UIImage imageNamed:@"jaredLeto_014.png"],
                                      [UIImage imageNamed:@"jaredLeto_013.png"],
                                      [UIImage imageNamed:@"jaredLeto_012.png"],
                                      [UIImage imageNamed:@"jaredLeto_011.png"],
                                      [UIImage imageNamed:@"jaredLeto_010.png"],
                                      [UIImage imageNamed:@"jaredLeto_009.png"],
                                      [UIImage imageNamed:@"jaredLeto_008.png"],
                                      [UIImage imageNamed:@"jaredLeto_007.png"],
                                      [UIImage imageNamed:@"jaredLeto_006.png"],
                                      [UIImage imageNamed:@"jaredLeto_005.png"],
                                      [UIImage imageNamed:@"jaredLeto_004.png"],
                                      [UIImage imageNamed:@"jaredLeto_003.png"],
                                      [UIImage imageNamed:@"jaredLeto_002.png"],
                                      [UIImage imageNamed:@"jaredLeto_001.png"],nil];
    
    self.imageView.animationDuration = 30.0;
    
    self.imageView.animationRepeatCount = 1;
    
    [self.imageView startAnimating];
    
    
    
    
    
}

-(void)startGame24  {
    
    //  [self runTimer];
    [self.next setHidden:YES];
    
    self.answer =@"jessica alba";
    
    
    self.imageView.animationImages = [NSArray arrayWithObjects:
                                      
                                      
                                      [UIImage imageNamed:@"jessicaAlba_014.png"],
                                      [UIImage imageNamed:@"jessicaAlba_013.png"],
                                      [UIImage imageNamed:@"jessicaAlba_012.png"],
                                      [UIImage imageNamed:@"jessicaAlba_011.png"],
                                      [UIImage imageNamed:@"jessicaAlba_010.png"],
                                      [UIImage imageNamed:@"jessicaAlba_009.png"],
                                      [UIImage imageNamed:@"jessicaAlba_008.png"],
                                      [UIImage imageNamed:@"jessicaAlba_007.png"],
                                      [UIImage imageNamed:@"jessicaAlba_006.png"],
                                      [UIImage imageNamed:@"jessicaAlba_005.png"],
                                      [UIImage imageNamed:@"jessicaAlba_004.png"],
                                      [UIImage imageNamed:@"jessicaAlba_003.png"],
                                      [UIImage imageNamed:@"jessicaAlba_002.png"],
                                      [UIImage imageNamed:@"jessicaAlba_001.png"],nil];
    
    self.imageView.animationDuration = 30.0;
    
    self.imageView.animationRepeatCount = 1;
    
    [self.imageView startAnimating];
    
    
    
    
    
}

-(void)startGame25  {
    
    //  [self runTimer];
    [self.next setHidden:YES];
    
    self.answer =@"johnny depp";
    
    
    self.imageView.animationImages = [NSArray arrayWithObjects:
                                      
                                      
                                      [UIImage imageNamed:@"johnnyDepp_014.png"],
                                      [UIImage imageNamed:@"johnnyDepp_013.png"],
                                      [UIImage imageNamed:@"johnnyDepp_012.png"],
                                      [UIImage imageNamed:@"johnnyDepp_011.png"],
                                      [UIImage imageNamed:@"johnnyDepp_010.png"],
                                      [UIImage imageNamed:@"johnnyDepp_009.png"],
                                      [UIImage imageNamed:@"johnnyDepp_008.png"],
                                      [UIImage imageNamed:@"johnnyDepp_007.png"],
                                      [UIImage imageNamed:@"johnnyDepp_006.png"],
                                      [UIImage imageNamed:@"johnnyDepp_005.png"],
                                      [UIImage imageNamed:@"johnnyDepp_004.png"],
                                      [UIImage imageNamed:@"johnnyDepp_003.png"],
                                      [UIImage imageNamed:@"johnnyDepp_002.png"],
                                      [UIImage imageNamed:@"johnnyDepp_001.png"],nil];
    
    self.imageView.animationDuration = 30.0;
    
    self.imageView.animationRepeatCount = 1;
    
    [self.imageView startAnimating];
    
    
    
    
    
}

-(void)startGame26  {
    
    //  [self runTimer];
    [self.next setHidden:YES];
    
    self.answer =@"dwayne johnson";
    
    
    self.imageView.animationImages = [NSArray arrayWithObjects:
                                      
                                      [UIImage imageNamed:@"dwayneJohnson_014.png"],
                                      [UIImage imageNamed:@"dwayneJohnson_013.png"],
                                      [UIImage imageNamed:@"dwayneJohnson_012.png"],
                                      [UIImage imageNamed:@"dwayneJohnson_011.png"],
                                      [UIImage imageNamed:@"dwayneJohnson_010.png"],
                                      [UIImage imageNamed:@"dwayneJohnson_009.png"],
                                      [UIImage imageNamed:@"dwayneJohnson_008.png"],
                                      [UIImage imageNamed:@"dwayneJohnson_007.png"],
                                      [UIImage imageNamed:@"dwayneJohnson_006.png"],
                                      [UIImage imageNamed:@"dwayneJohnson_005.png"],
                                      [UIImage imageNamed:@"dwayneJohnson_004.png"],
                                      [UIImage imageNamed:@"dwayneJohnson_003.png"],
                                      [UIImage imageNamed:@"dwayneJohnson_002.png"],
                                      [UIImage imageNamed:@"dwayneJohnson_001.png"],nil];

                                      
    self.imageView.animationDuration = 30.0;
    
    self.imageView.animationRepeatCount = 1;
    
    [self.imageView startAnimating];
    
    
    
    
    
}

-(void)startGame27  {
    
    //  [self runTimer];
    [self.next setHidden:YES];
    
    self.answer =@"jeff goldblum";
    
    
    self.imageView.animationImages = [NSArray arrayWithObjects:
                                      
                                      [UIImage imageNamed:@"jeffGoldblum_014.png"],
                                      [UIImage imageNamed:@"jeffGoldblum_013.png"],
                                      [UIImage imageNamed:@"jeffGoldblum_012.png"],
                                      [UIImage imageNamed:@"jeffGoldblum_011.png"],
                                      [UIImage imageNamed:@"jeffGoldblum_010.png"],
                                      [UIImage imageNamed:@"jeffGoldblum_009.png"],
                                      [UIImage imageNamed:@"jeffGoldblum_008.png"],
                                      [UIImage imageNamed:@"jeffGoldblum_007.png"],
                                      [UIImage imageNamed:@"jeffGoldblum_006.png"],
                                      [UIImage imageNamed:@"jeffGoldblum_005.png"],
                                      [UIImage imageNamed:@"jeffGoldblum_004.png"],
                                      [UIImage imageNamed:@"jeffGoldblum_003.png"],
                                      [UIImage imageNamed:@"jeffGoldblum_002.png"],
                                      [UIImage imageNamed:@"jeffGoldblum_001.png"],nil];
   
                               
    
    self.imageView.animationDuration = 30.0;
    
    self.imageView.animationRepeatCount = 1;
    
    [self.imageView startAnimating];
    
    
    
    
    
}

-(void)startGame28  {
    
    [self.next setHidden:YES];
    
    self.answer =@"jet lee";
    
    
    self.imageView.animationImages = [NSArray arrayWithObjects:
                                      
                                      [UIImage imageNamed:@"jetLee_014.png"],
                                      [UIImage imageNamed:@"jetLee_013.png"],
                                      [UIImage imageNamed:@"jetLee_012.png"],
                                      [UIImage imageNamed:@"jetLee_011.png"],
                                      [UIImage imageNamed:@"jetLee_010.png"],
                                      [UIImage imageNamed:@"jetLee_009.png"],
                                      [UIImage imageNamed:@"jetLee_008.png"],
                                      [UIImage imageNamed:@"jetLee_007.png"],
                                      [UIImage imageNamed:@"jetLee_006.png"],
                                      [UIImage imageNamed:@"jetLee_005.png"],
                                      [UIImage imageNamed:@"jetLee_004.png"],
                                      [UIImage imageNamed:@"jetLee_003.png"],
                                      [UIImage imageNamed:@"jetLee_002.png"],
                                      [UIImage imageNamed:@"jetLee_001.png"],nil];
    
    self.imageView.animationDuration = 30.0;
    
    self.imageView.animationRepeatCount = 1;
    
    [self.imageView startAnimating];
    
    
}

-(void)startGame29  {
    
    //  [self runTimer];
    
    [self.next setHidden:YES];
    self.answer =@"jim carrey";
    
    
    self.imageView.animationImages = [NSArray arrayWithObjects:
                                      
                                      [UIImage imageNamed:@"jimCarrey_014.png"],
                                      [UIImage imageNamed:@"jimCarrey_013.png"],
                                      [UIImage imageNamed:@"jimCarrey_012.png"],
                                      [UIImage imageNamed:@"jimCarrey_011.png"],
                                      [UIImage imageNamed:@"jimCarrey_010.png"],
                                      [UIImage imageNamed:@"jimCarrey_009.png"],
                                      [UIImage imageNamed:@"jimCarrey_008.png"],
                                      [UIImage imageNamed:@"jimCarrey_007.png"],
                                      [UIImage imageNamed:@"jimCarrey_006.png"],
                                      [UIImage imageNamed:@"jimCarrey_005.png"],
                                      [UIImage imageNamed:@"jimCarrey_004.png"],
                                      [UIImage imageNamed:@"jimCarrey_003.png"],
                                      [UIImage imageNamed:@"jimCarrey_002.png"],
                                      [UIImage imageNamed:@"jimCarrey_001.png"],nil];
  
                            
    
    self.imageView.animationDuration = 30.0;
    
    self.imageView.animationRepeatCount = 1;
    
    [self.imageView startAnimating];
    
    
    
    
    
}

-(void)startGame30  {
    
    //  [self runTimer];
    [self.next setHidden:YES];
    
    self.answer =@"jonah hill";
    
    
    self.imageView.animationImages = [NSArray arrayWithObjects:
                                      
                                      [UIImage imageNamed:@"jonahHill_014.png"],
                                      [UIImage imageNamed:@"jonahHill_013.png"],
                                      [UIImage imageNamed:@"jonahHill_012.png"],
                                      [UIImage imageNamed:@"jonahHill_011.png"],
                                      [UIImage imageNamed:@"jonahHill_010.png"],
                                      [UIImage imageNamed:@"jonahHill_009.png"],
                                      [UIImage imageNamed:@"jonahHill_008.png"],
                                      [UIImage imageNamed:@"jonahHill_007.png"],
                                      [UIImage imageNamed:@"jonahHill_006.png"],
                                      [UIImage imageNamed:@"jonahHill_005.png"],
                                      [UIImage imageNamed:@"jonahHill_004.png"],
                                      [UIImage imageNamed:@"jonahHill_003.png"],
                                      [UIImage imageNamed:@"jonahHill_002.png"],
                                      [UIImage imageNamed:@"jonahHill_001.png"],nil];
  
                                      
    self.imageView.animationDuration = 30.0;
    
    self.imageView.animationRepeatCount = 1;
    
    [self.imageView startAnimating];
    
    
}

-(void)startGame31  {
    
    //  [self runTimer];
    
    [self.next setHidden:YES];
    self.answer =@"mila kunis";
    
    
    self.imageView.animationImages = [NSArray arrayWithObjects:
                                      
                                      
                                      [UIImage imageNamed:@"milaKunis_014.png"],
                                      [UIImage imageNamed:@"milaKunis_013.png"],
                                      [UIImage imageNamed:@"milaKunis_012.png"],
                                      [UIImage imageNamed:@"milaKunis_011.png"],
                                      [UIImage imageNamed:@"milaKunis_010.png"],
                                      [UIImage imageNamed:@"milaKunis_009.png"],
                                      [UIImage imageNamed:@"milaKunis_008.png"],
                                      [UIImage imageNamed:@"milaKunis_007.png"],
                                      [UIImage imageNamed:@"milaKunis_006.png"],
                                      [UIImage imageNamed:@"milaKunis_005.png"],
                                      [UIImage imageNamed:@"milaKunis_004.png"],
                                      [UIImage imageNamed:@"milaKunis_003.png"],
                                      [UIImage imageNamed:@"milaKunis_002.png"],
                                      [UIImage imageNamed:@"milaKunis_001.png"],nil];
    
    self.imageView.animationDuration = 30.0;
    
    self.imageView.animationRepeatCount = 1;
    
    [self.imageView startAnimating];
    
    
    
    
    
}

-(void)startGame32  {
    
    //  [self runTimer];
    [self.next setHidden:YES];
    
    self.answer =@"natalie portman";
    
    
    self.imageView.animationImages = [NSArray arrayWithObjects:
                                      
                                      
                                      [UIImage imageNamed:@"nataliePortman_014.png"],
                                      [UIImage imageNamed:@"nataliePortman_013.png"],
                                      [UIImage imageNamed:@"nataliePortman_012.png"],
                                      [UIImage imageNamed:@"nataliePortman_011.png"],
                                      [UIImage imageNamed:@"nataliePortman_010.png"],
                                      [UIImage imageNamed:@"nataliePortman_009.png"],
                                      [UIImage imageNamed:@"nataliePortman_008.png"],
                                      [UIImage imageNamed:@"nataliePortman_007.png"],
                                      [UIImage imageNamed:@"nataliePortman_006.png"],
                                      [UIImage imageNamed:@"nataliePortman_005.png"],
                                      [UIImage imageNamed:@"nataliePortman_004.png"],
                                      [UIImage imageNamed:@"nataliePortman_003.png"],
                                      [UIImage imageNamed:@"nataliePortman_002.png"],
                                      [UIImage imageNamed:@"nataliePortman_001.png"],nil];
    
    self.imageView.animationDuration = 30.0;
    
    self.imageView.animationRepeatCount = 1;
    
    [self.imageView startAnimating];
    
    
    
    
    
}

-(void)startGame33  {
    
    //  [self runTimer];
    [self.next setHidden:YES];
    
    self.answer =@"pierce brosnan";
    
    
    self.imageView.animationImages = [NSArray arrayWithObjects:
                                      
                                      
                                      [UIImage imageNamed:@"pierceBrosnon_014.png"],
                                      [UIImage imageNamed:@"pierceBrosnon_013.png"],
                                      [UIImage imageNamed:@"pierceBrosnon_012.png"],
                                      [UIImage imageNamed:@"pierceBrosnon_011.png"],
                                      [UIImage imageNamed:@"pierceBrosnon_010.png"],
                                      [UIImage imageNamed:@"pierceBrosnon_009.png"],
                                      [UIImage imageNamed:@"pierceBrosnon_008.png"],
                                      [UIImage imageNamed:@"pierceBrosnon_007.png"],
                                      [UIImage imageNamed:@"pierceBrosnon_006.png"],
                                      [UIImage imageNamed:@"pierceBrosnon_005.png"],
                                      [UIImage imageNamed:@"pierceBrosnon_004.png"],
                                      [UIImage imageNamed:@"pierceBrosnon_003.png"],
                                      [UIImage imageNamed:@"pierceBrosnon_002.png"],
                                      [UIImage imageNamed:@"pierceBrosnon_001.png"],nil];
    
    self.imageView.animationDuration = 30.0;
    
    self.imageView.animationRepeatCount = 1;
    
    [self.imageView startAnimating];
    
    
    
    
    
}

-(void)startGame34  {
    
    //  [self runTimer];
    [self.next setHidden:YES];
    
    self.answer =@"richard gere";
    
    
    self.imageView.animationImages = [NSArray arrayWithObjects:
                                      
                                      
                                      [UIImage imageNamed:@"richardGere_014.png"],
                                      [UIImage imageNamed:@"richardGere_013.png"],
                                      [UIImage imageNamed:@"richardGere_012.png"],
                                      [UIImage imageNamed:@"richardGere_011.png"],
                                      [UIImage imageNamed:@"richardGere_010.png"],
                                      [UIImage imageNamed:@"richardGere_009.png"],
                                      [UIImage imageNamed:@"richardGere_008.png"],
                                      [UIImage imageNamed:@"richardGere_007.png"],
                                      [UIImage imageNamed:@"richardGere_006.png"],
                                      [UIImage imageNamed:@"richardGere_005.png"],
                                      [UIImage imageNamed:@"richardGere_004.png"],
                                      [UIImage imageNamed:@"richardGere_003.png"],
                                      [UIImage imageNamed:@"richardGere_002.png"],
                                      [UIImage imageNamed:@"richardGere_001.png"],nil];
    
    self.imageView.animationDuration = 30.0;
    
    self.imageView.animationRepeatCount = 1;
    
    [self.imageView startAnimating];
    
    
    
    
    
}

-(void)startGame35  {
    
    //  [self runTimer];
    [self.next setHidden:YES];
    
    self.answer =@"jude law";
    
    
    
    self.imageView.animationImages = [NSArray arrayWithObjects:
                                      
                                      [UIImage imageNamed:@"judeLaw_014.png"],
                                      [UIImage imageNamed:@"judeLaw_013.png"],
                                      [UIImage imageNamed:@"judeLaw_012.png"],
                                      [UIImage imageNamed:@"judeLaw_011.png"],
                                      [UIImage imageNamed:@"judeLaw_010.png"],
                                      [UIImage imageNamed:@"judeLaw_009.png"],
                                      [UIImage imageNamed:@"judeLaw_008.png"],
                                      [UIImage imageNamed:@"judeLaw_007.png"],
                                      [UIImage imageNamed:@"judeLaw_006.png"],
                                      [UIImage imageNamed:@"judeLaw_005.png"],
                                      [UIImage imageNamed:@"judeLaw_004.png"],
                                      [UIImage imageNamed:@"judeLaw_003.png"],
                                      [UIImage imageNamed:@"judeLaw_002.png"],
                                      [UIImage imageNamed:@"judeLaw_001.png"],nil];
    
    self.imageView.animationDuration = 30.0;
    
    self.imageView.animationRepeatCount = 1;
    
    [self.imageView startAnimating];
    

    
}

-(void)startGame36  {
    
    //  [self runTimer];
     [self.next setHidden:YES];
    
    self.answer =@"robin williams";
    
    
    self.imageView.animationImages = [NSArray arrayWithObjects:
                                      
                                      
                                      [UIImage imageNamed:@"robinWilliams_014.png"],
                                      [UIImage imageNamed:@"robinWilliams_013.png"],
                                      [UIImage imageNamed:@"robinWilliams_012.png"],
                                      [UIImage imageNamed:@"robinWilliams_011.png"],
                                      [UIImage imageNamed:@"robinWilliams_010.png"],
                                      [UIImage imageNamed:@"robinWilliams_009.png"],
                                      [UIImage imageNamed:@"robinWilliams_008.png"],
                                      [UIImage imageNamed:@"robinWilliams_007.png"],
                                      [UIImage imageNamed:@"robinWilliams_006.png"],
                                      [UIImage imageNamed:@"robinWilliams_005.png"],
                                      [UIImage imageNamed:@"robinWilliams_004.png"],
                                      [UIImage imageNamed:@"robinWilliams_003.png"],
                                      [UIImage imageNamed:@"robinWilliams_002.png"],
                                      [UIImage imageNamed:@"robinWilliams_001.png"],nil];
    
    self.imageView.animationDuration = 30.0;
    
    self.imageView.animationRepeatCount = 1;
    
    [self.imageView startAnimating];
    
    
    
    
    
}

-(void)startGame37  {
    
     [self.next setHidden:YES];
    
    self.answer =@"morgan freeman";
    
    
    self.imageView.animationImages = [NSArray arrayWithObjects:
                                      
                                      [UIImage imageNamed:@"morganFreeman_014.png"],
                                      [UIImage imageNamed:@"morganFreeman_013.png"],
                                      [UIImage imageNamed:@"morganFreeman_012.png"],
                                      [UIImage imageNamed:@"morganFreeman_011.png"],
                                      [UIImage imageNamed:@"morganFreeman_010.png"],
                                      [UIImage imageNamed:@"morganFreeman_009.png"],
                                      [UIImage imageNamed:@"morganFreeman_008.png"],
                                      [UIImage imageNamed:@"morganFreeman_007.png"],
                                      [UIImage imageNamed:@"morganFreeman_006.png"],
                                      [UIImage imageNamed:@"morganFreeman_005.png"],
                                      [UIImage imageNamed:@"morganFreeman_004.png"],
                                      [UIImage imageNamed:@"morganFreeman_003.png"],
                                      [UIImage imageNamed:@"morganFreeman_002.png"],
                                      [UIImage imageNamed:@"morganFreeman_001.png"],nil];
    
    self.imageView.animationDuration = 30.0;
    
    self.imageView.animationRepeatCount = 1;
    
    [self.imageView startAnimating];
    
    
    
    
    
}

-(void)startGame38  {
    
    //  [self runTimer];
     [self.next setHidden:YES];
    
    self.answer =@"robert pattinson";
    
    
    self.imageView.animationImages = [NSArray arrayWithObjects:
                                      
                                      [UIImage imageNamed:@"robertPattinson_014.png"],
                                      [UIImage imageNamed:@"robertPattinson_013.png"],
                                      [UIImage imageNamed:@"robertPattinson_012.png"],
                                      [UIImage imageNamed:@"robertPattinson_011.png"],
                                      [UIImage imageNamed:@"robertPattinson_010.png"],
                                      [UIImage imageNamed:@"robertPattinson_009.png"],
                                      [UIImage imageNamed:@"robertPattinson_008.png"],
                                      [UIImage imageNamed:@"robertPattinson_007.png"],
                                      [UIImage imageNamed:@"robertPattinson_006.png"],
                                      [UIImage imageNamed:@"robertPattinson_005.png"],
                                      [UIImage imageNamed:@"robertPattinson_004.png"],
                                      [UIImage imageNamed:@"robertPattinson_003.png"],
                                      [UIImage imageNamed:@"robertPattinson_002.png"],
                                      [UIImage imageNamed:@"robertPattinson_001.png"],nil];
    
    self.imageView.animationDuration = 30.0;
    
    self.imageView.animationRepeatCount = 1;
    
    [self.imageView startAnimating];
    
    
    
    
    
}

-(void)startGame39  {
    
    //  [self runTimer];
     [self.next setHidden:YES];
    
    
    self.answer =@"seth rogan";
    
    
    self.imageView.animationImages = [NSArray arrayWithObjects:
                                      
                                      
                                      [UIImage imageNamed:@"sethRogan_014.png"],
                                      [UIImage imageNamed:@"sethRogan_013.png"],
                                      [UIImage imageNamed:@"sethRogan_012.png"],
                                      [UIImage imageNamed:@"sethRogan_011.png"],
                                      [UIImage imageNamed:@"sethRogan_010.png"],
                                      [UIImage imageNamed:@"sethRogan_009.png"],
                                      [UIImage imageNamed:@"sethRogan_008.png"],
                                      [UIImage imageNamed:@"sethRogan_007.png"],
                                      [UIImage imageNamed:@"sethRogan_006.png"],
                                      [UIImage imageNamed:@"sethRogan_005.png"],
                                      [UIImage imageNamed:@"sethRogan_004.png"],
                                      [UIImage imageNamed:@"sethRogan_003.png"],
                                      [UIImage imageNamed:@"sethRogan_002.png"],
                                      [UIImage imageNamed:@"sethRogan_001.png"],nil];
    
    self.imageView.animationDuration = 30.0;
    
    self.imageView.animationRepeatCount = 1;
    
    [self.imageView startAnimating];
    
    
    
    
    
}

-(void)startGame40  {
    
    //  [self runTimer];
     [self.next setHidden:YES];
    
    self.answer =@"tom cruise";
    
    
    self.imageView.animationImages = [NSArray arrayWithObjects:
                                      
                                      
                                      [UIImage imageNamed:@"tomCruise_014.png"],
                                      [UIImage imageNamed:@"tomCruise_013.png"],
                                      [UIImage imageNamed:@"tomCruise_012.png"],
                                      [UIImage imageNamed:@"tomCruise_011.png"],
                                      [UIImage imageNamed:@"tomCruise_010.png"],
                                      [UIImage imageNamed:@"tomCruise_009.png"],
                                      [UIImage imageNamed:@"tomCruise_008.png"],
                                      [UIImage imageNamed:@"tomCruise_007.png"],
                                      [UIImage imageNamed:@"tomCruise_006.png"],
                                      [UIImage imageNamed:@"tomCruise_005.png"],
                                      [UIImage imageNamed:@"tomCruise_004.png"],
                                      [UIImage imageNamed:@"tomCruise_003.png"],
                                      [UIImage imageNamed:@"tomCruise_002.png"],
                                      [UIImage imageNamed:@"tomCruise_001.png"],nil];
    
    self.imageView.animationDuration = 30.0;
    
    self.imageView.animationRepeatCount = 1;
    
    [self.imageView startAnimating];
    
    
    
    
    
}

-(void)startGame41  {
    
    //  [self runTimer];
     [self.next setHidden:YES];
    
    self.answer =@"al pacino";
    
    
    self.imageView.animationImages = [NSArray arrayWithObjects:
                                      
                                      
                                      [UIImage imageNamed:@"alPacino_014.png"],
                                      [UIImage imageNamed:@"alPacino_013.png"],
                                      [UIImage imageNamed:@"alPacino_012.png"],
                                      [UIImage imageNamed:@"alPacino_011.png"],
                                      [UIImage imageNamed:@"alPacino_010.png"],
                                      [UIImage imageNamed:@"alPacino_009.png"],
                                      [UIImage imageNamed:@"alPacino_008.png"],
                                      [UIImage imageNamed:@"alPacino_007.png"],
                                      [UIImage imageNamed:@"alPacino_006.png"],
                                      [UIImage imageNamed:@"alPacino_005.png"],
                                      [UIImage imageNamed:@"alPacino_004.png"],
                                      [UIImage imageNamed:@"alPacino_003.png"],
                                      [UIImage imageNamed:@"alPacino_002.png"],
                                      [UIImage imageNamed:@"alPacino_001.png"],nil];
    
    self.imageView.animationDuration = 30.0;
    
    self.imageView.animationRepeatCount = 1;
    
    [self.imageView startAnimating];
    
    
    
    
    
}

-(void)startGame42  {
    
    //  [self runTimer];
     [self.next setHidden:YES];
    
    self.answer =@"tom hardy";
    
    
    self.imageView.animationImages = [NSArray arrayWithObjects:
                                      
                                      
                                      [UIImage imageNamed:@"tomHardy_014.png"],
                                      [UIImage imageNamed:@"tomHardy_013.png"],
                                      [UIImage imageNamed:@"tomHardy_012.png"],
                                      [UIImage imageNamed:@"tomHardy_011.png"],
                                      [UIImage imageNamed:@"tomHardy_010.png"],
                                      [UIImage imageNamed:@"tomHardy_009.png"],
                                      [UIImage imageNamed:@"tomHardy_008.png"],
                                      [UIImage imageNamed:@"tomHardy_007.png"],
                                      [UIImage imageNamed:@"tomHardy_006.png"],
                                      [UIImage imageNamed:@"tomHardy_005.png"],
                                      [UIImage imageNamed:@"tomHardy_004.png"],
                                      [UIImage imageNamed:@"tomHardy_003.png"],
                                      [UIImage imageNamed:@"tomHardy_002.png"],
                                      [UIImage imageNamed:@"tomHardy_001.png"],nil];
    
    self.imageView.animationDuration = 30.0;
    
    self.imageView.animationRepeatCount = 1;
    
    [self.imageView startAnimating];
    
    
    
    
    
}

-(void)startGame43  {
    
    //  [self runTimer];
     [self.next setHidden:YES];
    
    self.answer =@"will ferrell";
    
    
    self.imageView.animationImages = [NSArray arrayWithObjects:
                                      
                                      
                                      [UIImage imageNamed:@"willFerrell_014.png"],
                                      [UIImage imageNamed:@"willFerrell_013.png"],
                                      [UIImage imageNamed:@"willFerrell_012.png"],
                                      [UIImage imageNamed:@"willFerrell_011.png"],
                                      [UIImage imageNamed:@"willFerrell_010.png"],
                                      [UIImage imageNamed:@"willFerrell_009.png"],
                                      [UIImage imageNamed:@"willFerrell_008.png"],
                                      [UIImage imageNamed:@"willFerrell_007.png"],
                                      [UIImage imageNamed:@"willFerrell_006.png"],
                                      [UIImage imageNamed:@"willFerrell_005.png"],
                                      [UIImage imageNamed:@"willFerrell_004.png"],
                                      [UIImage imageNamed:@"willFerrell_003.png"],
                                      [UIImage imageNamed:@"willFerrell_002.png"],
                                      [UIImage imageNamed:@"willFerrell_001.png"],nil];
    
    self.imageView.animationDuration = 30.0;
    
    self.imageView.animationRepeatCount = 1;
    
    [self.imageView startAnimating];
    
    
    
    
    
}

-(void)startGame44  {
    
    //  [self runTimer];
     [self.next setHidden:YES];
    
    self.answer =@"mark wahlberg";
    
    
    self.imageView.animationImages = [NSArray arrayWithObjects:
                                      
                                      
                                      [UIImage imageNamed:@"markWahlberg_014.png"],
                                      [UIImage imageNamed:@"markWahlberg_013.png"],
                                      [UIImage imageNamed:@"markWahlberg_012.png"],
                                      [UIImage imageNamed:@"markWahlberg_011.png"],
                                      [UIImage imageNamed:@"markWahlberg_010.png"],
                                      [UIImage imageNamed:@"markWahlberg_009.png"],
                                      [UIImage imageNamed:@"markWahlberg_008.png"],
                                      [UIImage imageNamed:@"markWahlberg_007.png"],
                                      [UIImage imageNamed:@"markWahlberg_006.png"],
                                      [UIImage imageNamed:@"markWahlberg_005.png"],
                                      [UIImage imageNamed:@"markWahlberg_004.png"],
                                      [UIImage imageNamed:@"markWahlberg_003.png"],
                                      [UIImage imageNamed:@"markWahlberg_002.png"],
                                      [UIImage imageNamed:@"markWahlberg_001.png"],nil];
    
    self.imageView.animationDuration = 30.0;
    
    self.imageView.animationRepeatCount = 1;
    
    [self.imageView startAnimating];
    
    
    
    
    
}

-(void)startGame45  {
    
    //  [self runTimer];
     [self.next setHidden:YES];
    
    self.answer =@"russell crowe";
    
    
    self.imageView.animationImages = [NSArray arrayWithObjects:
                                      
                                      [UIImage imageNamed:@"russellCrowe_014.png"],
                                      [UIImage imageNamed:@"russellCrowe_013.png"],
                                      [UIImage imageNamed:@"russellCrowe_012.png"],
                                      [UIImage imageNamed:@"russellCrowe_011.png"],
                                      [UIImage imageNamed:@"russellCrowe_010.png"],
                                      [UIImage imageNamed:@"russellCrowe_009.png"],
                                      [UIImage imageNamed:@"russellCrowe_008.png"],
                                      [UIImage imageNamed:@"russellCrowe_007.png"],
                                      [UIImage imageNamed:@"russellCrowe_006.png"],
                                      [UIImage imageNamed:@"russellCrowe_005.png"],
                                      [UIImage imageNamed:@"russellCrowe_004.png"],
                                      [UIImage imageNamed:@"russellCrowe_003.png"],
                                      [UIImage imageNamed:@"russellCrowe_002.png"],
                                      [UIImage imageNamed:@"russellCrowe_001.png"],nil];
                                 
    
    self.imageView.animationDuration = 30.0;
    
    self.imageView.animationRepeatCount = 1;
    
    [self.imageView startAnimating];
    
    
    
    
    
}


-(void)startGame47  {
    
    //  [self runTimer];
     [self.next setHidden:YES];
    
    self.answer =@"amy adams";
    
    
    self.imageView.animationImages = [NSArray arrayWithObjects:
                                      
                                      [UIImage imageNamed:@"amyAdams_014.png"],
                                      [UIImage imageNamed:@"amyAdams_013.png"],
                                      [UIImage imageNamed:@"amyAdams_012.png"],
                                      [UIImage imageNamed:@"amyAdams_011.png"],
                                      [UIImage imageNamed:@"amyAdams_010.png"],
                                      [UIImage imageNamed:@"amyAdams_009.png"],
                                      [UIImage imageNamed:@"amyAdams_008.png"],
                                      [UIImage imageNamed:@"amyAdams_007.png"],
                                      [UIImage imageNamed:@"amyAdams_006.png"],
                                      [UIImage imageNamed:@"amyAdams_005.png"],
                                      [UIImage imageNamed:@"amyAdams_004.png"],
                                      [UIImage imageNamed:@"amyAdams_003.png"],
                                      [UIImage imageNamed:@"amyAdams_002.png"],
                                      [UIImage imageNamed:@"amyAdams_001.png"],nil];
    
    self.imageView.animationDuration = 30.0;
    
    self.imageView.animationRepeatCount = 1;
    
    [self.imageView startAnimating];
    
    
    
    
    
}


-(void)startGame19  {
    
    //  [self runTimer];
     [self.next setHidden:YES];
    
    self.answer =@"angelina jolie";
    
    
    self.imageView.animationImages = [NSArray arrayWithObjects:
                                      
                                      
                                      [UIImage imageNamed:@"angelinaJolie_014.png"],
                                      [UIImage imageNamed:@"angelinaJolie_013.png"],
                                      [UIImage imageNamed:@"angelinaJolie_012.png"],
                                      [UIImage imageNamed:@"angelinaJolie_011.png"],
                                      [UIImage imageNamed:@"angelinaJolie_010.png"],
                                      [UIImage imageNamed:@"angelinaJolie_009.png"],
                                      [UIImage imageNamed:@"angelinaJolie_008.png"],
                                      [UIImage imageNamed:@"angelinaJolie_007.png"],
                                      [UIImage imageNamed:@"angelinaJolie_006.png"],
                                      [UIImage imageNamed:@"angelinaJolie_005.png"],
                                      [UIImage imageNamed:@"angelinaJolie_004.png"],
                                      [UIImage imageNamed:@"angelinaJolie_003.png"],
                                      [UIImage imageNamed:@"angelinaJolie_002.png"],
                                      [UIImage imageNamed:@"angelinaJolie_001.png"],nil];
    
    self.imageView.animationDuration = 30.0;
    
    self.imageView.animationRepeatCount = 1;
    
    [self.imageView startAnimating];
    
    
    
    
    
}





@end
