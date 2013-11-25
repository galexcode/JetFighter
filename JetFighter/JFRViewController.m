//
//  JFRViewController.m
//  JetFighter
//
//  Created by Divyendu Singh on 17/11/13.
//  Copyright (c) 2013 Divu. All rights reserved.
//

#import "JFRViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface JFRViewController ()
@property (nonatomic, strong) AVAudioPlayer *planeAudio;
@property (nonatomic, strong) AVAudioPlayer *missileAudio;
@end

@implementation JFRViewController

-(IBAction)Pause:(id)sender
{
    if(Start == NO)
    {
        if(!PauseToggle)
        {
            [timer invalidate];
            [scorer invalidate];
            [shotTimer invalidate];
            [explosionTimer invalidate];
            [difficultyTimer invalidate];
        
            timer = nil;
            scorer = nil;
            shotTimer = nil;
            explosionTimer = nil;
            difficultyTimer = nil;
        
            Ended.text = @"Paused";
            Ended.hidden = NO;
        
            PauseToggle = (BOOL *) YES;
        }
        else
        {
            timer = [NSTimer scheduledTimerWithTimeInterval:0.04 target:self selector:@selector(HeliMove) userInfo:nil repeats:YES];
            scorer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(Scoring) userInfo:nil repeats:YES];
            difficultyTimer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(difficulty) userInfo:nil repeats:YES];
            shotTimer = [NSTimer scheduledTimerWithTimeInterval:0.004 target:self selector:@selector(ShotMove) userInfo:nil repeats:YES];
            explosionTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(hideExplosion) userInfo:nil repeats:YES];
        
            Ended.text = @"Game Over";
            Ended.hidden = YES;
        
            PauseToggle = (BOOL *) NO;
        }
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle{return UIStatusBarStyleLightContent;}

/*
 -(void)PlaySoundWithFile:(NSString *)file player:(AVAudioPlayer *)av
 {
 NSURL* url = [[NSBundle mainBundle] URLForResource:file withExtension:@"aiff"];
 NSAssert(url, @"URL is valid.");
 NSError* error = nil;
 av = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
 if(!av)
 {
 NSLog(@"Error creating player: %@", error);
 }
 else
 {
 [av play];
 }
 }*/

-  (IBAction)Fire:(id)sender {
    if(!PauseToggle && !Start)
    {
        Shot.center = CGPointMake(Heli.center.x, Heli.center.y + 15);
        Shot.hidden = NO;

        [shotTimer invalidate];
        shotTimer = [NSTimer scheduledTimerWithTimeInterval:0.004 target:self selector:@selector(ShotMove) userInfo:nil repeats:YES];
    
        NSURL* url = [[NSBundle mainBundle] URLForResource:@"missile" withExtension:@"aiff"];
        NSAssert(url, @"URL is valid.");
        NSError* error = nil;
        self.missileAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        if(!self.missileAudio)
        {
            NSLog(@"Error creating player: %@", error);
        }
        else
        {
            [self.missileAudio play];
        }
    }
}

-(void) ShotMove{
    if(Shot.hidden == NO)
    {
        Shot.center = CGPointMake(Shot.center.x + 1, Shot.center.y);
        static BOOL imgBool;
        if(imgBool)
        {
            Shot.image = [UIImage imageNamed:@"missile1.png"];
            imgBool = NO;
        }
        else
        {
            Shot.image = [UIImage imageNamed:@"missile2.png"];
            imgBool = YES;
        }
    }
}

-(void) hideExplosion
{
    Explosion.center = CGPointMake(Explosion.center.x - 10, Explosion.center.y);
    [NSThread sleepForTimeInterval:0.1];
    Explosion.hidden = YES;
    [explosionTimer invalidate];
}

-(void)Collision{
    if(CGRectIntersectsRect(Heli.frame, Obstacle1.frame))
    {
        [self EndGame];
    }
    
    if(CGRectIntersectsRect(Heli.frame, Obstacle2.frame))
    {
        [self EndGame];
    }
    
    /*
    if(CGRectIntersectsRect(Heli.frame, Bottom1.frame))
    {
        [self EndGame];
    }
    
    if(CGRectIntersectsRect(Heli.frame, Bottom2.frame))
    {
        [self EndGame];
    }
    
    if(CGRectIntersectsRect(Heli.frame, Bottom3.frame))
    {
        [self EndGame];
    }
    
    if(CGRectIntersectsRect(Heli.frame, Bottom4.frame))
    {
        [self EndGame];
    }
    
    if(CGRectIntersectsRect(Heli.frame, Bottom5.frame))
    {
        [self EndGame];
    }
    
    if(CGRectIntersectsRect(Heli.frame, Bottom6.frame))
    {
        [self EndGame];
    }
    
    if(CGRectIntersectsRect(Heli.frame, Bottom7.frame))
    {
        [self EndGame];
    }
    */
    if(CGRectIntersectsRect(Shot.frame, Obstacle1.frame))
    {
        ScoreNumber += 40 * difficulty;
        O1Y = 10;
        Shot.center = CGPointMake( 0 , 0);
        Shot.hidden = YES;
        [shotTimer invalidate];
        
        Explosion.hidden = NO;
        Explosion.center = CGPointMake(Obstacle1.center.x, Obstacle1.center.y);
        explosionTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(hideExplosion) userInfo:nil repeats:YES];
        
        NSURL* url = [[NSBundle mainBundle] URLForResource:@"boom" withExtension:@"aiff"];
        NSAssert(url, @"URL is valid.");
        NSError* error = nil;
        self.missileAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        if(!self.missileAudio)
        {
            NSLog(@"Error creating player: %@", error);
        }
        else
        {
            [self.missileAudio play];
        }

    }
    
    if(CGRectIntersectsRect(Shot.frame, Obstacle2.frame))
    {
        ScoreNumber += 40 * difficulty;
        O2Y = 10;
        Shot.center = CGPointMake( 0 , 0);
        Shot.hidden = YES;
        [shotTimer invalidate];
        
        Explosion.hidden = NO;
        Explosion.center = CGPointMake(Obstacle2.center.x, Obstacle2.center.y);
        
        explosionTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(hideExplosion) userInfo:nil repeats:YES];
        
        NSURL* url = [[NSBundle mainBundle] URLForResource:@"boom" withExtension:@"aiff"];
        NSAssert(url, @"URL is valid.");
        NSError* error = nil;
        self.missileAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        if(!self.missileAudio)
        {
            NSLog(@"Error creating player: %@", error);
        }
        else
        {
            [self.missileAudio play];
        }

    }
    
    if(Obstacle1.center.y > 275)
    {
        O1Y = 0;
    }
    
    if(Obstacle2.center.y > 275)
    {
        O2Y = 0;
    }
    
    if(Heli.center.y > 275 || Heli.center.y < 10)
    {
        [self EndGame];
    }
}

-(void) EndGame{
    
    Explosion.hidden = NO;
    Explosion.center = CGPointMake(Heli.center.x, Heli.center.y);
    
    //explosionTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(hideExplosion) userInfo:nil repeats:YES];
    
    if(ScoreNumber > HighScore)
    {
        HighScore = ScoreNumber;
        [[NSUserDefaults standardUserDefaults]setInteger:HighScore forKey:@"HighScoreSaved"];
    }
    
    Pause.hidden = YES;
    Heli.hidden = YES;
    Ended.hidden = NO;
    Again.hidden = NO;
    [timer invalidate];
    [scorer invalidate];
    [shotTimer invalidate];
    [difficultyTimer invalidate];
    
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"enemycrash" withExtension:@"aiff"];
    NSAssert(url, @"URL is valid.");
    NSError* error = nil;
    self.missileAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    if(!self.missileAudio)
    {
        NSLog(@"Error creating player: %@", error);
    }
    else
    {
        [self.missileAudio play];
    }
    Start = YES;
    [NSThread sleepForTimeInterval:0.1];
}

-(void) NewGame{
    
    O1Y = O2Y = 0;
    
    Ended.layer.zPosition=100;
    Again.layer.zPosition=100;
    Start = YES;
    Obstacle1.hidden = YES;
    Obstacle2.hidden = YES;
    Bottom1.hidden = YES;
    Bottom2.hidden = YES;
    Bottom3.hidden = YES;
    Bottom4.hidden = YES;
    Bottom5.hidden = YES;
    Bottom6.hidden = YES;
    Bottom7.hidden = YES;
    Ended.hidden = YES;
    Again.hidden = YES;
    Pause.hidden = NO;
    
    Explosion.hidden = YES;
    
    Intro1.hidden = NO;
    Intro2.hidden = NO;
    Intro3.hidden = NO;
    
    Shot.hidden = YES;
    
    Heli.hidden = NO;
    Heli.center = CGPointMake(40, 133);
    Heli.image = [UIImage imageNamed:@"up1.png"];
    
    ScoreNumber = 0;
    difficulty = 3;
    Score.text = [NSString stringWithFormat:@"Score: 000"];
}

-(void) HeliMove{
    
    [self Collision];
    
    Heli.center = CGPointMake(Heli.center.x, Heli.center.y + Y);
    
    int xSpeed = difficulty;
    
    Obstacle1.center = CGPointMake(Obstacle1.center.x -xSpeed, Obstacle1.center.y + O1Y);
    Obstacle2.center = CGPointMake(Obstacle2.center.x -xSpeed, Obstacle2.center.y + O2Y);
    
    Bottom1.center = CGPointMake(Bottom1.center.x -xSpeed, Bottom1.center.y);
    Bottom2.center = CGPointMake(Bottom2.center.x -xSpeed, Bottom2.center.y);
    Bottom3.center = CGPointMake(Bottom3.center.x -xSpeed, Bottom3.center.y);
    Bottom4.center = CGPointMake(Bottom4.center.x -xSpeed, Bottom4.center.y);
    Bottom5.center = CGPointMake(Bottom5.center.x -xSpeed, Bottom5.center.y);
    Bottom6.center = CGPointMake(Bottom6.center.x -xSpeed, Bottom6.center.y);
    Bottom7.center = CGPointMake(Bottom7.center.x -xSpeed, Bottom7.center.y);
    
    Background.center = CGPointMake(Background.center.x - 0.5 + difficulty/100 , Background.center.y);
    
    if(Background.center.x < 180)
    {
        Background.center = CGPointMake(Background.center.x + 100, Background.center.y);
    }
    
    if(Obstacle1.center.x < 0)
    {
        RandomPosition = arc4random() %75;
        RandomPosition = RandomPosition + 110;
        Obstacle1.center = CGPointMake( 510, RandomPosition);
    }
    
    if(Obstacle2.center.x < 0)
    {
        RandomPosition = arc4random() %75;
        RandomPosition = RandomPosition + 110;
        Obstacle2.center = CGPointMake( 510, RandomPosition);
    }
    
    if(Bottom1.center.x < -30)
    {
        RandomPosition = arc4random() %55;
        Bottom1.center = CGPointMake(510, RandomPosition + 265);
    }
    
    if(Bottom2.center.x < -30)
    {
        RandomPosition = arc4random() %55;
        Bottom2.center = CGPointMake(510, RandomPosition+ 265);
    }
    
    if(Bottom3.center.x < -30)
    {
        RandomPosition = arc4random() %55;
        Bottom3.center = CGPointMake(510, RandomPosition+ 265);
    }
    
    if(Bottom4.center.x < -30)
    {
        RandomPosition = arc4random() %55;
        Bottom4.center = CGPointMake(510, RandomPosition+ 265);
    }
    
    if(Bottom5.center.x < -30)
    {
        RandomPosition = arc4random() %55;
        Bottom5.center = CGPointMake(510, RandomPosition+ 265);
    }
    
    if(Bottom6.center.x < -30)
    {
        RandomPosition = arc4random() %55;
        Bottom6.center = CGPointMake(510, RandomPosition+ 265);
    }
    
    if(Bottom7.center.x < -30)
    {
        RandomPosition = arc4random() %55;
        Bottom7.center = CGPointMake(510, RandomPosition+ 265);
    }
}

-(void) Scoring{
    ScoreNumber += 10;
    Score.text = [NSString stringWithFormat:@"Score: %i / Level: %i" , ScoreNumber, difficulty-2];
}

-(void) upImageToggle
{
    static BOOL imgBool;
    if(imgBool)
    {
        Heli.image = [UIImage imageNamed:@"up1.png"];
        imgBool = NO;
    }
    else
    {
        Heli.image = [UIImage imageNamed:@"up2.png"];
        imgBool = YES;
    }
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(Start == YES)
    {
        
        [self NewGame];
        Intro1.hidden = YES;
        Intro2.hidden = YES;
        Intro3.hidden = YES;
        Ended.hidden = YES;
        Again.hidden = YES;
        
        timer = [NSTimer scheduledTimerWithTimeInterval:0.04 target:self selector:@selector(HeliMove) userInfo:nil repeats:YES];
        scorer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(Scoring) userInfo:nil repeats:YES];
        difficultyTimer = [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(difficulty) userInfo:nil repeats:YES];
        
        Start = NO;
        
        
        Obstacle1.hidden = NO;
        Obstacle2.hidden = NO;
        
        /*
        Bottom1.hidden = NO;
        Bottom2.hidden = NO;
        Bottom3.hidden = NO;
        Bottom4.hidden = NO;
        Bottom5.hidden = NO;
        Bottom6.hidden = NO;
        Bottom7.hidden = NO;
        */
        
        RandomPosition = arc4random() %75;
        RandomPosition = RandomPosition + 110;
        Obstacle1.center = CGPointMake( 570, RandomPosition);
        
        RandomPosition = arc4random() %75;
        RandomPosition = RandomPosition + 110;
        Obstacle2.center = CGPointMake( 855, RandomPosition);
        
        int baseVal = 560;
        int raiseMul = 80;
        
        RandomPosition = arc4random() %55;
        Bottom1.center = CGPointMake(baseVal + raiseMul * 0, RandomPosition + 265);
        
        RandomPosition = arc4random() %55;
        Bottom2.center = CGPointMake(baseVal + raiseMul * 1, RandomPosition + 265);
        
        RandomPosition = arc4random() %55;
        Bottom3.center = CGPointMake(baseVal + raiseMul * 2, RandomPosition + 265);
        
        RandomPosition = arc4random() %55;
        Bottom4.center = CGPointMake(baseVal + raiseMul * 3, RandomPosition + 265);
        
        RandomPosition = arc4random() %55;
        Bottom5.center = CGPointMake(baseVal + raiseMul * 4, RandomPosition + 265);
    
        RandomPosition = arc4random() %55;
        Bottom6.center = CGPointMake(baseVal + raiseMul * 5, RandomPosition+ 265 );
        
        RandomPosition = arc4random() %55;
        Bottom7.center = CGPointMake(baseVal + raiseMul * 6, RandomPosition+ 265);
        
    }
    
    if(!PauseToggle && !Start)
    {
    
        Y=-(difficulty/2);
    
        Heli.animationImages = [NSArray arrayWithObjects:
                            [UIImage imageNamed:@"up1.png"],
                            [UIImage imageNamed:@"up2.png"],nil];
        Heli.animationDuration = 0.1;
        [Heli startAnimating];
    
        NSURL* url = [[NSBundle mainBundle] URLForResource:@"high" withExtension:@"aiff"];
        NSAssert(url, @"URL is valid.");
        NSError* error = nil;
        self.planeAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        if(!self.planeAudio)
        {
            NSLog(@"Error creating player: %@", error);
        }
        else
        {
            [self.planeAudio play];
        }
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!PauseToggle && !Start)
    {
    Y=difficulty/2;
    Heli.image = [UIImage imageNamed:@"down.png"];
    [Heli stopAnimating];
    
    
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"low" withExtension:@"aiff"];
    NSAssert(url, @"URL is valid.");
    NSError* error = nil;
    self.planeAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    if(!self.planeAudio)
    {
        NSLog(@"Error creating player: %@", error);
    }
    else
    {
        [self.planeAudio play];
    }
    }
}

-(void) difficulty
{
    difficulty += 1;
    difficulty += ScoreNumber / 5000;
}

- (void)viewDidLoad
{
    [self NewGame];
    Pause.hidden = YES;
    Water.animationImages = [NSArray arrayWithObjects:
                             [UIImage imageNamed:@"water1.png"],
                             [UIImage imageNamed:@"water2.png"],
                             [UIImage imageNamed:@"water3.png"],nil];
    
    Water.animationDuration = 0.7;
    [Water startAnimating];
    
    HighScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"HighScoreSaved"];
    Intro3.text = [NSString stringWithFormat:@"High Score: %i" , HighScore];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
