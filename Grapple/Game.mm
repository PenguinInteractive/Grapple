//
//  Game.mm
//  Grapple
//
//  Created by JP on 2018-02-24.
//  Copyright © 2018 Penguin Interactive. All rights reserved.
//

#include <stdio.h>
#import "Game.h"
#import "Renderer.h"
#import "Player.h"
#import "HighScore.h"
#include <chrono>

@interface Game() {
    std::chrono::time_point<std::chrono::steady_clock> lastTime;
    Renderer* render;
    Generator *generate;
    Player* player;
    HighScore* hs;
    float timeElapsed;
}

@end

@implementation Game

- (void) update {
    auto currentTime = std::chrono::steady_clock::now();
    timeElapsed = std::chrono::duration_cast<std::chrono::milliseconds>(currentTime-lastTime).count();
    lastTime = currentTime;
    
    [render update];
    
    [player movePlayer:timeElapsed];
    [generate Generate:timeElapsed];
}

- (void) pause {
    _isPaused = !_isPaused;
}

-(void) increaseScore {
    if(!_isPaused){
        _playerScore+=(20*_mult);
    }
}

-(void) grappleSpawn{
    /*
     if gapple is offscrean
     mult=1;
     */
    _mult=1;
    [hs addScore:_playerScore];
}

-(void) collectGrapple{
    [self increaseScore];
    if(_mult<5){
        _mult++;
    }
    NSLog(@"%i",_mult);

}

-(void) setTimeelapsed : (float) te {
    timeElapsed = te;
}

-(float) timeElapsed{
    return timeElapsed;
}

- (void) startGame:(Renderer*)renderer
{
    generate = [[Generator alloc] init];
    [generate setup:renderer];
    
    player = [[Player alloc] init];
    [player setup:renderer];
    _mult=1;
    render = renderer;
}
@end

