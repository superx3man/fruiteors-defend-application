//
//  Multiplier.m
//  ThroughTheFruiteors
//
//  Created by Calvin Ng on 4/19/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Multiplier.h"

@implementation Multiplier
{
    CCLabelTTF *_multiplierLabel;
    
    NSArray *_labelList;
    NSArray *_maxLabelList;
}

@synthesize multiplier;

- (void)didLoadFromCCB
{
    _labelList = @[@"Nice", @"Good", @"Amazing", @"Awesome", @"Perfect"];
    _maxLabelList = @[@"Woah", @"!!!!!", @"*Applause*", @"OMG", @"Cookie For You"];
}

#pragma mark - Properties
- (void)setMultiplier:(int)num
{
    multiplier = num;
    _multiplierLabel.string = (num < [_labelList count]) ? [_labelList objectAtIndex:num] : [_maxLabelList objectAtIndex:(arc4random() % [_maxLabelList count])];
}

@end
