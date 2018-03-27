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
    
    platforms = [[NSMutableArray alloc] initWithCapacity:2];
    grapples = [[NSMutableArray alloc] initWithCapacity:2];
    
    //Generate a cube with the genCube function in Model once that works
    Model* model = [renderer genCube];
    [platforms addObject:model];
    model = [renderer genCube];
    [platforms addObject:model];
    model = [renderer genCube];
    [grapples addObject:model];
    model = [renderer genCube];
    [grapples addObject:model];
}

-(void) Generate:(float)deltaTime
{
    [player movePlayer:deltaTime];
    
    //determine if platforms should be spawned
        //if you need a new platform call SpawnPlatform or something
    
    //[self movePlatforms:deltaTime];
    
    /*
    for(int i = 0; i < [platformsX count]; i++)
    {
        
        [render renderCube:[platformsX[i] floatValue] yPos:[platformsY[i] floatValue]];
    }
    */
}


-(void) movePlatforms:(float)deltaTime
{
    float moveAmount = deltaTime * 0.0001;
    
    for(int i = 0; i < [platforms count]; i++)
    {
        //platforms[i].mMatrix = [GLKMatrix4Translate(platforms[i].mMatrix, moveAmount, 0, 0)]; IDK HOW TO USE NSARRAYS
    }
    
    //render all the platforms and grapples
    /*
    for(all)
        [renderer render:platform[i]];
    
    for(all)
        [renderer render:grapple[i]];
    */
    
    [player movePlayer:deltaTime];
}

- (void)spawnPlatform
{
    //SpawnPlatform will pick a random y value then add a new vector2 with the xposition equal to the right side of the screen and yposition equal to the random y
    //Store it in the array
}

@end
