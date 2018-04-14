//
//  Collisions.h
//  Grapple
//
//  Created by Colt King on 2018-04-05.
//  Copyright © 2018 Penguin Interactive. All rights reserved.
//

#ifndef Collisions_h
#define Collisions_h
#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

enum
{
    PLATFORM,
    GRAPPLE,
    PLAYER,
    TONGUE
};

@interface Collisions : NSObject
{
    
}

- (void)initWorld;

- (void)makeBody:(float)x yPos:(float)y width:(float)w height:(float)h type:(int)t;

- (GLKVector2)getPosition:(int)type index:(int)i;

- (void)removeBody:(int)type index:(int)i;

- (void)shiftAll:(float)screenShift;

- (void)setTongueVelocity:(float)x vY:(float)y;

- (void)setPlayerVelocity:(float)x vY:(float)y;

@end

#endif /* Collisions_h */
