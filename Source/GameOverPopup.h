//
//  GameOverPopup.h
//  ThroughTheFruiteors
//
//  Created by Calvin Ng on 4/20/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

#import "GameCenterHelper.h"

#import "Fruit.h"

@interface GameOverPopup : CCNode <GameCenterHelperDelegate>

@property (nonatomic, assign, setter = setScore:) int score;
@property (nonatomic, assign, setter = setFruit:) FruitType fruit;

- (void)sendAchievements;

@end
