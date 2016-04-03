//
//  CCNode+ContentSizeUpdate.m
//  ThroughTheFruiteors
//
//  Created by Calvin Ng on 4/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode+ContentSizeUpdate.h"

typedef struct {
    float x1, y1, x2, y2;
} BBox;

@implementation CCNode (ContentSizeUpdate)

+ (void)setContentSize:(CCNode *)node
{
    BBox outline = {0, 0, 0, 0};
    
    for (CCNode* child in node.children) {
        [CCNode setContentSize:child];
        
        CGPoint position = child.position;
        CGSize  size = child.contentSize;
        CGPoint anchorPoint = child.anchorPoint;
        BBox bbox;
        bbox.x1 = position.x - size.width * anchorPoint.x;
        bbox.y1 = position.y - size.height * anchorPoint.y;
        bbox.x2 = position.x + size.width * (1-anchorPoint.x) ;
        bbox.y2 = position.y + size.height * (1-anchorPoint.y);
        if (bbox.x1 < outline.x1) {
            outline.x1 = bbox.x1;
        }
        if (bbox.y1 < outline.y1) {
            outline.y1 = bbox.y1;
        }
        if (bbox.x2 > outline.x2) {
            outline.x2 = bbox.x2;
        }
        if (bbox.y2 > outline.y2) {
            outline.y2 = bbox.y2;
        }
    }
    
    if (node.children > 0)
    {
        CGSize newContentSize;
        newContentSize.width = (outline.x2 - outline.x1);
        newContentSize.height = (outline.y2 - outline.y1);
        node.contentSize = newContentSize;
    }
}

@end
