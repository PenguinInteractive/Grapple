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
#import "Player.h"
#import "Model.h"

@interface Generator()
{
    Player* player;
    Renderer *render;
    Collisions* collide;
    
    NSMutableArray* platforms;
    NSMutableArray* grapples;
    Model* playerModel;
    Model* tongue;
    float screenSpeed;
    bool despawn;
}
@end


@implementation Generator

//Setup platforms with a reasonable capacity later
- (void)setup:(Renderer*)renderer col:(Collisions*)collider
{
    //screenSpeed = -0.001f;
    despawn = false;
    
    render = renderer;
    player = [[Player alloc] init];
    
    //playerModel = [render genCube];
    playerModel = [Model readObj:@"Frog"];
    
    tongue = [render genCube];
    
    collide = collider;
    
    [playerModel translate:0.4 y:0 z:0];
    [playerModel setColour:GLKVector3Make(20,170,230)];
    [collide makeBody:0.4 yPos:0 width:0.5 height:0.5 type:PLAYER];
    
    [tongue translate:0.35 y:0 z:0];
    [tongue setColour:GLKVector3Make(255,180,255)];
    [collide makeBody:0.35 yPos:0 width:0.5 height:0.5 type:TONGUE];
    
    [player setup:playerModel tongue:tongue collide:collide];
    
    platforms = [[NSMutableArray alloc] initWithCapacity:20];
    grapples = [[NSMutableArray alloc] initWithCapacity:20];
    
    //Generate a cube with the genCube function in Model once that works
    
    //Platforms
    [self spawnPlatform];
    
    //Grapples
    
    [self spawnGrapple];
    
}

-(void) Generate:(float)deltaTime
{
    float screenShift = screenSpeed * deltaTime;
    [collide shiftAll:screenShift];
    
    [player movePlayer:deltaTime shift:screenShift];
    [self movePlatforms];
    
    //determine if platforms should be spawned
        //if you need a new platform call SpawnPlatform or something
    
    for(int i = 0; i < platforms.count; i++)
    {
        if(platforms[i] == NULL)
            continue;
        [render render:platforms[i]];
    }
    for(int j = 0; j < grapples.count; j++)
    {
        if(grapples[j] == NULL)
            continue;
        [render render:grapples[j]];
    }
    
    [render render:playerModel];
    [render render:tongue];
}


-(void) movePlatforms
{
    for(int i = 0; i < [platforms count]; i++)
    {
        if(platforms[i] == NULL)
            continue;
        
        GLKVector2 newPos = [collide getPosition:PLATFORM index:i];
        
        if(newPos.x < -6)
        {
            [collide removeBody:PLATFORM index:i];
        }
        else
        {
            [platforms[i] moveTo:newPos.x y:newPos.y z:0];
        }
    }
    for(int j = 0; j < grapples.count; j++)
    {
        if(grapples[j] == NULL)
            continue;
        
        GLKVector2 newPos = [collide getPosition:GRAPPLE index:j];
        [grapples[j] moveTo:newPos.x y:newPos.y z:0];
    }
}

- (void)fireTongue:(float)x yPos:(float)y
{
    [player fireTongue:x yPos:y];
}

- (void)spawnPlatform
{
    //SpawnPlatform will pick a random y value then add a new vector2 with the xposition equal to the right side of the screen and yposition equal to the random y
    Model* model;
    
    model = [render genCube];
    [model translate:1.0 y:1.5 z:0];
    [model setColour:GLKVector3Make(160,120,40)];
    [platforms addObject:model];
    [collide makeBody:1.0 yPos:1.5 width:0.5 height:0.5 type:PLATFORM];
    
    model = [render genCube];
    [model translate:10 y:-1.5 z:0];
    [model setColour:GLKVector3Make(160,120,40)];
    [platforms addObject:model];
    [collide makeBody:10 yPos:-1.5 width:0.5 height:0.5 type:PLATFORM];
    
    model = [render genCube];
    [model translate:6 y:1 z:0];
    [model setColour:GLKVector3Make(160,120,40)];
    [platforms addObject:model];
    [collide makeBody:6 yPos:1 width:0.5 height:0.5 type:PLATFORM];
    
    model = [render genCube];
    [model translate:4 y:-1.5 z:0];
    [model setColour:GLKVector3Make(160,120,40)];
    [platforms addObject:model];
    [collide makeBody:4 yPos:-1.5 width:0.5 height:0.5 type:PLATFORM];
    
    model = [render genCube];
    [model translate:7 y:-3 z:0];
    [model setColour:GLKVector3Make(160,120,40)];
    [platforms addObject:model];
    [collide makeBody:7 yPos:-3 width:0.5 height:0.5 type:PLATFORM];
}

-(void)spawnGrapple
{
    Model* model;
    
    model = [render genCube];
    [model translate:0 y:1.5 z:0];
    [model setColour:GLKVector3Make(170,30,190)];
    [grapples addObject:model];
    [collide makeBody:0 yPos:1.5 width:0.5 height:0.5 type:GRAPPLE];
    
    model = [render genCube];
    [model translate:8 y:1.2 z:0];
    [model setColour:GLKVector3Make(170,30,190)];
    [grapples addObject:model];
    [collide makeBody:8 yPos:1.2 width:0.5 height:0.5 type:GRAPPLE];
    
    model = [render genCube];
    [model translate:2 y:1.5 z:0];
    [model setColour:GLKVector3Make(170,30,190)];
    [grapples addObject:model];
    [collide makeBody:2 yPos:1.5 width:0.5 height:0.5 type:GRAPPLE];
}

- (void)collectGrapple:(int)i
{
    [grapples removeObjectAtIndex:i];
    [collide removeBody:GRAPPLE index:i];
    [player retractTongue];
}

- (void)attachTongue
{
    [player attachTongue];
}

- (bool)checkDespawn
{
    if(despawn)
    {
        despawn = false;
        return true;
    }
    return false;
}

@end
