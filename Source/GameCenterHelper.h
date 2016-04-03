//
//  GameCenterHelper.h
//  NomNomFruiteors
//
//  Created by Calvin Ng on 4/21/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@protocol GameCenterHelperDelegate <NSObject>

@required
- (void)didAuthenticate:(BOOL)isSuccess;

@optional
- (void)didShowLeaderboard;
- (void)didDismissLeaderboard;

@end

@interface GameCenterHelper : NSObject <GKLeaderboardViewControllerDelegate>

@property (assign, nonatomic) id<GameCenterHelperDelegate> delegate;
@property (assign, nonatomic, readonly) BOOL gameCenterAvailable;

+ (GameCenterHelper *)sharedInstance;

- (void)authenticateLocalUser;

- (void)submitScore:(int)score withIdentifier:(NSString *)identifier;
- (void)submitAchievement:(float)percentage withIdentifier:(NSString *)identifier;

- (void)showLeaderboardwithIdentifier:(NSString *)identifier;

@end