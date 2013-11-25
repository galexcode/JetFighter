//
//  JFRViewController.h
//  JetFighter
//
//  Created by Divyendu Singh on 17/11/13.
//  Copyright (c) 2013 Divu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

int Y, O1Y , O2Y;
BOOL Start;
static BOOL *PauseToggle;
int RandomPosition;
int ScoreNumber;
int HighScore;
int difficulty;

@interface JFRViewController : UIViewController
{
    IBOutlet UILabel *Intro1;
    IBOutlet UILabel *Intro2;
    IBOutlet UILabel *Intro3;
    IBOutlet UILabel *Ended;
    IBOutlet UILabel *Again;
    IBOutlet UILabel *Score;
    
    
    IBOutlet UIButton *Fire;
    IBOutlet UIButton *Pause;
    
    IBOutlet UIImageView *Shot;
    IBOutlet UIImageView *Explosion;
    IBOutlet UIImageView *Heli;
    IBOutlet UIImageView *Water;
    IBOutlet UIImageView *Background;
    
    NSTimer *timer;
    NSTimer *scorer;
    NSTimer *shotTimer;
    NSTimer *explosionTimer;
    NSTimer *difficultyTimer;
    
    NSArray *images;
    
    IBOutlet UIImageView *Obstacle1;
    IBOutlet UIImageView *Obstacle2;
    
    IBOutlet UIImageView *Bottom1;
    IBOutlet UIImageView *Bottom2;
    IBOutlet UIImageView *Bottom3;
    IBOutlet UIImageView *Bottom4;
    IBOutlet UIImageView *Bottom5;
    IBOutlet UIImageView *Bottom6;
    IBOutlet UIImageView *Bottom7;
}

-(void)HeliMove;
-(void)Collision;
-(void)EndGame;
-(void)NewGame;
-(void)Scoring;
-(IBAction)Fire:(id)sender;
-(IBAction)Pause:(id)sender;
-(BOOL)CircleDistanceBetween:(UIImageView*)c1 And:(UIImageView*)c2;
//-(void)PlaySoundWithFile:(NSString*)file player:(AVAudioPlayer*)av;

@end
