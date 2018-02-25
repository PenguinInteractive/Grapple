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
    
    BOOL gameStarted;
    
}

@end

@implementation Game


float timeElapsed;
float currentTime =0;
float newTime = 0;

- (void) update {
    auto currentTime = std::chrono::steady_clock::now();
    auto elapsedTime = std::chrono::duration_cast<std::chrono::milliseconds>(currentTime-lastTime).count();
    lastTime=currentTime;
    _mult=2;
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
    
    generate = [[Generator alloc] init];    gameStarted = true;
    while (gameStarted == true) {
        
        
        newTime = currentTime += 0.001;
        //NSLog(@"%.3f", timeElapsed);
        [self setTimeelapsed:newTime];
        [generate generatePlatforms];
    }
    
    
    
}
@end

