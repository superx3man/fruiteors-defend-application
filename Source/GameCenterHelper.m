//
//  GameCenterHelper.m
//  NomNomFruiteors
//
//  Created by Calvin Ng on 4/21/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameCenterHelper.h"

static GameCenterHelper *sharedHelper = nil;

@implementation GameCenterHelper
{
    BOOL _userAuthenticated;
    NSString *_playerId;
    
    UIViewController *_authenticationController;
}

@synthesize delegate, gameCenterAvailable;

#pragma mark - Initialization
+ (GameCenterHelper *)sharedInstance
{
    if (!sharedHelper) {
        sharedHelper = [[GameCenterHelper alloc] init];
    }
    return sharedHelper;
}

- (id)init
{
    if ((self = [super init])) {
        _userAuthenticated = NO;
        _playerId = @"";
        _authenticationController = nil;
        
        gameCenterAvailable = [self isGameCenterAvailable];
        
#ifndef APPORTABLE
        if (gameCenterAvailable) {
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            [nc addObserver:self selector:@selector(authenticationChanged) name:GKPlayerAuthenticationDidChangeNotificationName object:nil];
        }
#endif
    }
    return self;
}

#pragma mark - Game Center Helper
- (BOOL)isGameCenterAvailable
{
#ifndef APPORTABLE
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
#else
    return YES;
#endif
}

- (void)authenticationChanged
{
    if (_userAuthenticated != [GKLocalPlayer localPlayer].authenticated || ![_playerId isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
        _userAuthenticated = [GKLocalPlayer localPlayer].authenticated;
        NSLog(@"game center: authentication %d", _userAuthenticated);
        if (_userAuthenticated) {
            _playerId = [GKLocalPlayer localPlayer].playerID;
        }
        
        if (_authenticationController && [CCDirector sharedDirector].presentedViewController == _authenticationController) {
            [[CCDirector sharedDirector] dismissViewControllerAnimated:YES completion:^
             {
                 _authenticationController = nil;
                 [delegate didAuthenticate:_userAuthenticated];
             }];
        }
        else {
            [delegate didAuthenticate:_userAuthenticated];
        }
    }
}

#pragma mark - User Functions
- (void)authenticateLocalUser
{
    if (gameCenterAvailable) {
        if (!_userAuthenticated) {
            NSLog(@"game center: authenticating");
#ifndef APPORTABLE
            [GKLocalPlayer localPlayer].authenticateHandler = ^(UIViewController *viewController, NSError *error)
            {
                if (viewController != nil) {
                    _authenticationController = viewController;
                    [[CCDirector sharedDirector] presentViewController:viewController animated:YES completion:nil];
                }
            };
#else
            [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error)
             {
                 [self authenticationChanged];
             }];
#endif
        }
        else {
            [delegate didAuthenticate:_userAuthenticated];
        }
    }
}

- (void)submitScore:(int)score withIdentifier:(NSString *)identifier
{
    if (_userAuthenticated) {
#ifndef APPORTABLE
        GKScore *gkScore = (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) ? [[GKScore alloc] initWithCategory:identifier] : [[GKScore alloc] initWithLeaderboardIdentifier:identifier];
        gkScore.value = score;
        [GKScore reportScores:@[gkScore] withCompletionHandler:^(NSError *error)
         {
             NSLog(@"game center: sent score %d", (error == nil));
         }];
#else
        GKScore *gkScore = [[GKScore alloc] initWithCategory:identifier];
        gkScore.value = score;
        [gkScore reportScoreWithCompletionHandler:^(NSError *error)
         {
             NSLog(@"game center: sent score %d", (error == nil));
         }];
#endif
    }
}

- (void)submitAchievement:(float)percentage withIdentifier:(NSString *)identifier
{
    if (_userAuthenticated) {
#ifndef APPORTABLE
        GKAchievement *gkAchievement = [[GKAchievement alloc] initWithIdentifier:identifier];
        gkAchievement.percentComplete = percentage;
        [GKAchievement reportAchievements:@[gkAchievement] withCompletionHandler:^(NSError *error)
         {
             NSLog(@"game center: sent achievement %@ %d", identifier, (error == nil));
         }];
#else
        [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements, NSError *error)
         {
             GKAchievement *gkAchievement = [[GKAchievement alloc] initWithIdentifier:identifier];
             gkAchievement.percentComplete = percentage;
             [gkAchievement reportAchievementWithCompletionHandler:^(NSError *error)
              {
                  NSLog(@"game center: sent achievement %@ %d", identifier, (error == nil));
              }];
         }];
#endif
    }
}

- (void)showLeaderboardwithIdentifier:(NSString *)identifier
{
    GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
    leaderboardController.category = identifier;
    leaderboardController.leaderboardDelegate = self;
    leaderboardController.timeScope = GKLeaderboardTimeScopeAllTime;
    [[CCDirector sharedDirector] presentViewController:leaderboardController animated:YES completion:^
     {
         if ([delegate respondsToSelector:@selector(didShowLeaderboard)]) {
             [delegate didShowLeaderboard];
         }
     }];
}

#pragma mark - Leaderboard Delegate
- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:^
     {
         if ([delegate respondsToSelector:@selector(didDismissLeaderboard)]) {
             [delegate didDismissLeaderboard];
         }
     }];
}

@end
