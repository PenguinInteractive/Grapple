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
#include <chrono>

@interface Game() {
    std::chrono::time_point<std::chrono::steady_clock> lastTime;
    Renderer* render;
    Generator *generate;
    Player* player;
    float timeElapsed;
}

@end

@implementation Game

- (void) update {
    auto currentTime = std::chrono::steady_clock::now();
    timeElapsed = std::chrono::duration_cast<std::chrono::milliseconds>(currentTime-lastTime).count();
    lastTime = currentTime;
    _mult=2;
    
    [self increaseScore];
    
    [player movePlayer:timeElapsed];
    [generate Generate:timeElapsed];
    
    [render update];
}

- (void) pause {
    _isPaused = !_isPaused;
}

-(void) increaseScore {
    if(!_isPaused){
        _playerScore++;
    }
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
    
    render = renderer;
}
@end

