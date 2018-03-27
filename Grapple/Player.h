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

@interface Player : NSObject

- (void)setup:(Renderer*)render;
- (void)movePlayer:(float)deltaTime;
- (void)fireTongue:(float)x yPos:(float)y;
- (void)grapple;

@end

#endif /* Player_h */
