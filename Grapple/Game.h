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
#import "Renderer.h"

@interface Game : NSObject

@property bool isPaused;
@property int playerScore;
@property int mult;

- (void) update;
- (void) pause;
- (void) increaseScore;

-(void) startGame;

-(void) setTimeelapsed : (float) te;
-(float) timeElapsed;
@end
#endif /* Game_h */

