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

float screenSpeed = -0.001f;

@interface Generator()
{
    Player* player;
    Renderer *render;
    
    NSMutableArray* platforms;
    NSMutableArray* grapples;
}
@end


@implementation Generator

//Setup platforms with a reasonable capacity later
- (void)setup:(Renderer*)renderer
{
    render = renderer;
    player = [[Player alloc] init];
    [player setup:renderer];
    
    platforms = [[NSMutableArray alloc] initWithCapacity:5];
    grapples = [[NSMutableArray alloc] initWithCapacity:3];
    
    //Generate a cube with the genCube function in Model once that works
    Model* model = [renderer genCube];
    
    //Platforms
    [model translate:1.0 y:1.5 z:0];
    [platforms addObject:model];
    
    model = [renderer genCube];
    [model translate:10 y:-1.5 z:0];
    [platforms addObject:model];

    model = [renderer genCube];
    [model translate:1.25 y:-1 z:0];
    [platforms addObject:model];
    
    model = [renderer genCube];
    [model translate:4 y:-1.5 z:0];
    [platforms addObject:model];
    
    model = [renderer genCube];
    [model translate:7 y:-3 z:0];
    [platforms addObject:model];
    
    //Grapples
    
    model = [renderer genCube];
    [model translate:0.5 y:1.5 z:0];
    [grapples addObject:model];

    model = [renderer genCube];
    [model translate:1.5 y:-2.5 z:0];
    [grapples addObject:model];
    
    model = [renderer genCube];
    [model translate:1.5 y:1.5 z:0];
    [grapples addObject:model];
    
}

-(void) Generate:(float)deltaTime
{
    [player movePlayer:deltaTime scrnSpd:screenSpeed];
    [self movePlatforms:deltaTime];
    
    //determine if platforms should be spawned
        //if you need a new platform call SpawnPlatform or something
    
   for(int i = 0; i < platforms.count; i++)
    {
        [render render:platforms[i]];
    }
    for(int j = 0; j <grapples.count; j++)
    {
        [render render:grapples[j]];
    }
}


-(void) movePlatforms:(float)deltaTime
{
    float screenShift = deltaTime * screenSpeed;
    
    for(int i = 0; i < [platforms count]; i++)
    {
         [platforms[i] translate:screenShift y:0 z:0];
    }
    for(int j = 0; j < grapples.count; j++)
    {
        [grapples[j] translate:screenShift y:0 z:0];
    }
}

- (void)fireTongue:(float)x yPos:(float)y
{
    [player fireTongue:x yPos:y];
}

- (void)letGo
{
    
}

- (void)spawnPlatform
{
    //SpawnPlatform will pick a random y value then add a new vector2 with the xposition equal to the right side of the screen and yposition equal to the random y
    //Store it in the array
}

-(void)spawnGrapple{

}

@end
