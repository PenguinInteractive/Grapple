//
//  Game.mm
//  Grapple
//
//  Created by JP on 2018-02-24.
//  Copyright © 2018 Penguin Interactive. All rights reserved.
//

#include <stdio.h>
#import "Game.h"
#include <chrono>

@interface Game() {
    std::chrono::time_point<std::chrono::steady_clock> lastTime;
    
    Generator *generate;
    float timeElapsed;
}

@end

@implementation Game

- (void) update {
    auto currentTime = std::chrono::steady_clock::now();
    timeElapsed = std::chrono::duration_cast<std::chrono::milliseconds>(currentTime-lastTime).count();
    lastTime = currentTime;
    _mult=2;
    
    [generate Generate:timeElapsed];
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

- (void) startGame{
    
    generate = [[Generator alloc] init];
}
@end

