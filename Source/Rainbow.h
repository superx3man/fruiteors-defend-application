//
//  Rainbow.h
//  ThroughTheFruiteors
//
//  Created by Calvin Ng on 4/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

typedef NS_ENUM(NSInteger, RainbowColor)
{
    RainbowColorPurple,
    RainbowColorGreen,
    RainbowColorYellow,
    RainbowColorOrange,
    RainbowColorRed
};

@interface Rainbow : CCNode

@property (readonly, nonatomic, assign) RainbowColor currentColor;

- (void)moveColorsDown;
- (void)moveColorsUp;

+ (CCColor *)getCCColorFromRainbowColor:(RainbowColor)color;

@end
