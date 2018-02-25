//
//  Game.m
//  Grapple
//
//  Created by BCIT Student on 2018-02-24.
//  Copyright © 2018 Penguin Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Game.h"



@interface Game(){
    
    Generator *generate;
    
    BOOL gameStarted;
    
    
}
@end


@implementation Game


float timeElapsed;
float currentTime =0;
float newTime = 0;


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
