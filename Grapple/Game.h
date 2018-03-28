//
//  Game.h
//  Grapple
//
//  Created by JP on 2018-02-24.
//  Copyright © 2018 JP. All rights reserved.
//

#ifndef Game_h
#define Game_h
#import <GLKit/GLKit.h>
#import "Generator.h"
#include <stdio.h>
#import "Renderer.h"
#import "HighScore.h"

@interface Game : NSObject

@property bool isPaused;
@property int playerScore;
@property int mult;
@property float tapX;
@property float tapY;

- (void)update;
- (void)pause;

- (void)startGame:(Renderer*)render;

- (void)setTimeelapsed : (float) te;
- (float)timeElapsed;

- (void)increaseScore;
- (void)grappleSpawn;
- (void)collectGrapple;
- (void)fireTongue:(float)x yPos:(float)y;
- (void)letGo;

@end
#endif /* Game_h */

