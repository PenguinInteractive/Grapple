//
//  Game.mm
//  Grapple
//
//  Created by JP on 2018-02-24.
//  Copyright © 2018 Penguin Interactive. All rights reserved.
//

#import "Game.h"
#include <chrono>
#import "Generator.h"
#include <stdio.h>

//USE THIS IF YOU WANT COLLISION STUFF
//#include <Box2D/Box2D.h>

@interface Game() {
    std::chrono::time_point<std::chrono::steady_clock> lastTime;
    Renderer* render;
    Generator *generate;
    HighScores* hs;
    float timeElapsed;
    int times;
}

@end

@implementation Game

- (void)startGame:(Renderer*)renderer
{
    auto currentTime = std::chrono::steady_clock::now();
    lastTime = currentTime;
    
    Collisions* collide = [[Collisions alloc] init];
    [collide initWorld:self];
    
    generate = [[Generator alloc] init];
    
    [generate setup:renderer col:collide];
    
    hs = [[HighScores alloc] init];
    
    _mult=1;
    times = 0;
    render = renderer;
}

- (void)update
{
    auto currentTime = std::chrono::steady_clock::now();
    timeElapsed = std::chrono::duration_cast<std::chrono::milliseconds>(currentTime-lastTime).count();
    lastTime = currentTime;
    
    [render update];
    
    [self Losing];
    
    [generate Generate:timeElapsed];
    
    if([generate checkDespawn])
        [self grappleSpawn];
}

- (void)fireTongue:(float)x yPos:(float)y
{
    [generate fireTongue:x yPos:y];
}

- (void)pause
{
    if(_isPaused)
        lastTime = std::chrono::steady_clock::now();
        
    _isPaused = !_isPaused;
}

- (void)increaseScore {
    if(!_isPaused){
        _playerScore+=(20*_mult);
    }
}

- (void)grappleSpawn
{
    _mult=1;
}

- (void)collectGrapple:(int)i
{
    [self increaseScore];
    if(_mult<5){
        _mult++;
    }
    NSLog(@"%i",_mult);
    
    [generate collectGrapple:i];
}

- (void)setTimeelapsed : (float) te {
    timeElapsed = te;
}

- (float)timeElapsed{
    return timeElapsed;
}

- (void)attachTongue
{
    [generate attachTongue];
}

- (bool)Losing
{
    if([generate isLost])
    {
        [hs addScore:_playerScore called:(times)];
        return true;
    }
    return false;
}

@end

