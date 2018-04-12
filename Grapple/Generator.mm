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
#include <Box2D/Box2D.h>

float screenSpeed = -0.001f;

@interface Generator()
{
    Player* player;
    Renderer *render;
    Collisions* collide;
    
    NSMutableArray* platforms;
    NSMutableArray* grapples;
    Model* playerModel;
    Model* tongue;
}
@end


@implementation Generator

//Setup platforms with a reasonable capacity later
//EACH MODEL NEEDS TO HAVE ITS POSITION AND HITBOX FED INTO THE COLLISIONS CLASS THEN YOU NEED TO SAVE THE BODY IN THE MODEL
- (void)setup:(Renderer*)renderer
{
    render = renderer;
    player = [[Player alloc] init];
    
    playerModel = [render genCube];
    tongue = [render genCube];
    
    [playerModel translate:0.4 y:0 z:0];
    [playerModel setColour:GLKVector3Make(20,170,230)];
    [tongue translate:0.35 y:-0.2 z:0];
    [tongue setColour:GLKVector3Make(255,180,255)];
    
    [player setup:playerModel tongue:tongue];
    
    collide = [[Collisions alloc] init];
    [collide initWorld];
    
    platforms = [[NSMutableArray alloc] initWithCapacity:5];
    grapples = [[NSMutableArray alloc] initWithCapacity:3];
    
    //Generate a cube with the genCube function in Model once that works
    Model* model = [renderer genCube];
    
    //Platforms
    [model translate:1.0 y:1.5 z:0];
    [model setColour:GLKVector3Make(160,120,40)];
    
    [collide makeBody:1.0 yPos:1.5 width:1.0 height:1.0 type:b2_staticBody];
    [platforms addObject:model];
    
    model = [renderer genCube];
    [model setColour:GLKVector3Make(160,120,40)];
    [model translate:10 y:-1.5 z:0];
    [platforms addObject:model];

    model = [renderer genCube];
    [model translate:6 y:1 z:0];
    [model setColour:GLKVector3Make(160,120,40)];
    [platforms addObject:model];
    
    model = [renderer genCube];
    [model translate:4 y:-1.5 z:0];
    [model setColour:GLKVector3Make(160,120,40)];
    [platforms addObject:model];
    
    model = [renderer genCube];
    [model translate:7 y:-3 z:0];
    [model setColour:GLKVector3Make(160,120,40)];
    [platforms addObject:model];
    
    //Grapples
    
    model = [renderer genCube];
    [model translate:0 y:1.5 z:0];
    [model setColour:GLKVector3Make(170,30,190)];
    [grapples addObject:model];

    model = [renderer genCube];
    [model translate:8 y:1.2 z:0];
    [model setColour:GLKVector3Make(170,30,190)];
    [grapples addObject:model];
    
    model = [renderer genCube];
    [model translate:2 y:1.5 z:0];
    [model setColour:GLKVector3Make(170,30,190)];
    [grapples addObject:model];
    
}

-(void) Generate:(float)deltaTime
{
    [player movePlayer:deltaTime scrnSpd:screenSpeed];
    [self movePlatforms:deltaTime];
    
    //GLKVector2 move = GLKVector2DivideScalar([collide getBodyMove], 100);
    //GLKMatrix4 moveM = GLKMatrix4Translate(GLKMatrix4Identity, move.x, 0, move.y);
    //[testCollisions setPosition:GLKMatrix4Multiply(moveM, testCollisions.position)];
    
    //determine if platforms should be spawned
        //if you need a new platform call SpawnPlatform or something
    
   for(int i = 0; i < platforms.count; i++)
    {
        [render render:platforms[i]];
    }
    for(int j = 0; j < grapples.count; j++)
    {
        [render render:grapples[j]];
    }
    
    [render render:playerModel];
    [render render:tongue];
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

- (void)spawnPlatform
{
    //SpawnPlatform will pick a random y value then add a new vector2 with the xposition equal to the right side of the screen and yposition equal to the random y
    //Store it in the array
}

-(void)spawnGrapple{

}

@end
