//
//  GameOverPopup.m
//  ThroughTheFruiteors
//
//  Created by Calvin Ng on 4/20/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameOverPopup.h"

#import "CCNode+AntialisedUpdate.h"

#import "Rainbow.h"

@implementation GameOverPopup
{
    CCLabelTTF *_fruitLabel;
    CCLabelTTF *_crushedLabel;
    CCLabelTTF *_rankLabel;
    CCLabelTTF *_scoreLabel;
    CCLabelTTF *_bestLabel;
    
    NSArray *_crushedString;
    NSArray *_fruitString;
    NSArray *_rankString;
    
    NSString *_highScoreIdentifier;
    NSArray *_achievementIdentifier;
    
    int _highScore;
    int _rankIndex;
    
    BOOL _achievementSent;
}

@synthesize score, fruit;

- (void)didLoadFromCCB
{
    _fruitString = @[@"Grape", @"Pear", @"Banana", @"Orange", @"Apple"];
    _crushedString = @[@"Crushed", @"Squashed", @"Squished", @"Mashed"];
    _rankString = @[@"Fruit Eater", @"Fruit Puncher", @"Fruit Killer", @"Fruit Terminator", @"Fruit Ninja?", @"Fruit &!*#_$)@"];
    
#ifndef APPORTABLE
    _highScoreIdentifier = @"NNFFruitDestroyed";
    _achievementIdentifier = @[@"NNFFruitPuncher", @"NNFFruitKiller", @"NNFFruitTerminator", @"NNFFruitNinja", @"NNFFruitImpossible"];
#else
    _highScoreIdentifier = @"CgkI0OWxhJkTEAIQBQ";
    _achievementIdentifier = @[@"CgkI0OWxhJkTEAIQAA", @"CgkI0OWxhJkTEAIQAQ", @"CgkI0OWxhJkTEAIQAg", @"CgkI0OWxhJkTEAIQAw", @"CgkI0OWxhJkTEAIQBA"];
#endif
    
    _crushedLabel.string = [_crushedString objectAtIndex:(arc4random() % [_crushedString count])];
    
    _highScore = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"highScore"];
    _rankIndex = 0;
    _achievementSent = NO;
    
    [CCNode setAntialised:NO onNode:self];
}

#pragma mark - Properties
- (void)setFruit:(FruitType)f
{
    fruit = f;
    _fruitLabel.string = [_fruitString objectAtIndex:fruit];
    _fruitLabel.color = [Rainbow getCCColorFromRainbowColor:(RainbowColor)fruit];
}

- (int)getRankIndex:(int)s
{
    int rankIndex = 0;
    if (s >= 200) {
        rankIndex = (int)[_rankString count] - 1;
    }
    else if (s >= 100) {
        rankIndex = (int)[_rankString count] - 2;
    }
    else if (s >= 60) {
        rankIndex = (int)[_rankString count] - 3;
    }
    else {
        rankIndex = s / 20;
    }
    return rankIndex;
}

- (void)setScore:(int)s
{
    score = s;
    _scoreLabel.string = [NSString stringWithFormat:@"%d", score];
    
    _rankIndex = [self getRankIndex:score];
    _rankLabel.string = [_rankString objectAtIndex:_rankIndex];
    
    if (score > _highScore) {
        _highScore = score;
        
        [[NSUserDefaults standardUserDefaults] setInteger:score forKey:@"highScore"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    _bestLabel.string = [NSString stringWithFormat:@"%d", _highScore];
}

- (void)sendAchievements
{
    [GameCenterHelper sharedInstance].delegate = self;
    [[GameCenterHelper sharedInstance] authenticateLocalUser];
}

#pragma mark - Game Center Helper Delegate
- (void)didAuthenticate:(BOOL)isSuccess
{
    if (isSuccess) {
        if (!_achievementSent) {
            if (_highScore > 0) {
                [[GameCenterHelper sharedInstance] submitScore:_highScore withIdentifier:_highScoreIdentifier];
            }
            
            int highScoreRankIndex = [self getRankIndex:_highScore];
            if (highScoreRankIndex > 0) {
                for (int index = 0; index < highScoreRankIndex; index++) {
                    [[GameCenterHelper sharedInstance] submitAchievement:100.f withIdentifier:[_achievementIdentifier objectAtIndex:index]];
                }
            }
            _achievementSent = YES;
        }
        [[GameCenterHelper sharedInstance] showLeaderboardwithIdentifier:_highScoreIdentifier];
    }
}

@end
