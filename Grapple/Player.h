//
//  Player.h
//  Grapple
//
//  Created by Colt King on 2018-02-27.
//  Copyright © 2018 Penguin Interactive. All rights reserved.
//

#ifndef Player_h
#define Player_h

#import <GLKit/GLKit.h>
#import "Renderer.h"
#import "Model.h"
#import "Collisions.h"

@interface Player : NSObject

- (void)setup:(Model*)p tongue:(Model*)t collide:(Collisions*)c;
- (void)movePlayer:(float)deltaTime shift:(float)screenShift;
- (void)fireTongue:(float)x yPos:(float)y;
- (void)attachTongue;

@end

#endif /* Player_h */
