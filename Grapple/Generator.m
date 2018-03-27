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
    
    platforms = [[NSMutableArray alloc] initWithCapacity:5];
    grapples = [[NSMutableArray alloc] initWithCapacity:3];
    
    //Generate a cube with the genCube function in Model once that works
    Model* model = [renderer genCube];
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
    
    ///
    
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
    [player movePlayer:deltaTime];
    [self movePlatforms:deltaTime];
    //determine if platforms should be spawned
        //if you need a new platform call SpawnPlatform or something
    
    //[self movePlatforms:deltaTime];
    
    
   for(int i = 0; i < platforms.count; i++)
    {
        
        [render render:platforms[i]];
    }
    for(int j = 0; j <grapples.count; j++){
        [render render:grapples[j]];
    }
    
/*    for(int i = 0; i < grapples.count; i++)
    {
       Model *d;
        d = grapples[i];
        [render render:d];
        
        [d setPosition:GLKVector3Make(5, 5, 5)];
        
        [render render:grapples[i]];
        NSLog(@"Grapple #%d",i);
    }*/
}


-(void) movePlatforms:(float)deltaTime
{
    float moveAmount = deltaTime * -0.001;
    
    for(int i = 0; i < [platforms count]; i++)
    {
        //platforms[i].mMatrix = [GLKMatrix4Translate(platforms[i].mMatrix, moveAmount, 0, 0)]; IDK HOW TO USE NSARRAYS
//        [GLKMatrix4Translate(d.mMatrix, moveAmount, 0, 0)];
         [platforms[i] translate:moveAmount y:0 z:0];
    }
    for(int j = 0; j < grapples.count; j++)
    {
        [grapples[j] translate:moveAmount y:0 z:0];
    }
    
    //render all the platforms and grapples
    /*
    for(all)
        [renderer render:platform[i]];
    
    for(all)
        [renderer render:grapple[i]];
    */
}

- (void)spawnPlatform
{
    //SpawnPlatform will pick a random y value then add a new vector2 with the xposition equal to the right side of the screen and yposition equal to the random y
    //Store it in the array
}

-(void)spawnGrapple{

}

@end
