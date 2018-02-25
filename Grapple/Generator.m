//
//  Generator.m
//  Grapple
//
//  Created by BCIT Student on 2018-02-24.
//  Copyright © 2018 Penguin Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Generator.h"
#import "Game.h"





@interface Generator(){
    
    Game *game;
    //Renderer *render;
}
@end


@implementation Generator


float xpos; // the X-axis position of the platform
float ypos; // the Y-axis position of the platform

-(void) generatePlatforms{
    Game *game =[[Game alloc] init];
    xpos = 0.1 * game.timeElapsed;
    if(xpos <= -10){
        
        
        
        
        xpos = 10;
        ypos = arc4random_uniform(3);
        
        //[render position: xpos, ypos]    }
    
    
    
    
    
}
}
    
-(void)setXpos:(float)xp {
    xpos = xp;
    
}
-(float) xpos {
    return xpos;
}

-(void)setYpos:(float)yp {
    ypos = yp;
}

-(float) ypos {
    return ypos;
}



@end
