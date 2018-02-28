//
//  Generator.m
//  Grapple
//
//  Created by BCIT Student on 2018-02-25.
//  Copyright © 2018 Penguin Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Generator.h"
#import "Renderer.h"
#import <GLKit/GLKit.h>




@interface Generator(){
    
    Renderer *render;
    NSMutableArray *platformsX;
    NSMutableArray *platformsY;
}
@end


@implementation Generator

//Setup platforms with a reasonable capacity later
- (void)setup:(Renderer*)renderer
{
    render = renderer;
    
    platformsX = [[NSMutableArray alloc] initWithCapacity:2];
    platformsY = [[NSMutableArray alloc] initWithCapacity:2];
    
    //I'm just going to hardcode this for now
    [platformsX addObject:[[NSNumber alloc] initWithFloat:0]];
    [platformsY addObject:[[NSNumber alloc] initWithFloat:0]];
    [platformsX addObject:[[NSNumber alloc] initWithFloat:0]];
    [platformsY addObject:[[NSNumber alloc] initWithFloat:0.1f]];
}

-(void) Generate:(float)deltaTime{
    
    //determine if platforms should be spawned
        //if you need a new platform call SpawnPlatform or something
    
    //[self movePlatforms:deltaTime];
    
    for(int i = 0; i < [platformsX count]; i++)
    {
        //NSLog([NSString stringWithFormat:@"x=%1.2f y=%1.2f", [platformsX[i] floatValue], [platformsY[i] floatValue]]);
        [render renderCube:[platformsX[i] floatValue] yPos:[platformsY[i] floatValue]];
    }
}


-(void) movePlatforms:(float)deltaTime
{
    for(int i = 0; i < [platformsX count]; i++)
    {
        platformsX[i] = [[NSNumber alloc] initWithFloat:[platformsX[i] floatValue]+(0.1f*deltaTime)];
    }
}

- (void)spawnPlatform
{
    //SpawnPlatform will pick a random y value then add a new vector2 with the xposition equal to the right side of the screen and yposition equal to the random y
    //Store it in the array
}

@end
