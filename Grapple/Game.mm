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
    
<<<<<<< HEAD
=======
    Generator *generate;
    float timeElapsed;
>>>>>>> parent of 78ffca3... Testing Addition
}

@end

@implementation Game

- (void) update {
    auto currentTime = std::chrono::steady_clock::now();
    auto elapsedTime = std::chrono::duration_cast<std::chrono::milliseconds>(currentTime-lastTime).count();
    lastTime=currentTime;
    _mult=2;
<<<<<<< HEAD
=======
    
    [generate Generate:timeElapsed];
>>>>>>> parent of 78ffca3... Testing Addition
}

- (void) pause {
    _isPaused = !_isPaused;
}

-(void) increaseScore {
    if(!_isPaused){
        _playerScore++;
    }
}

@end

