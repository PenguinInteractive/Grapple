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
#include <stdlib.h>

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
    
    playerModel = [Model readObj:@"Frog" scale: 0.01 x:0 y:0];
    tongue = [Model readObj:@"tongue" scale:0.1 x:0 y:0];
    
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
    
    //Platforms
    [self spawnPlatform];
    
    //Grapples
    
    //[self spawnGrapple];
    
}

-(void) Generate:(float)deltaTime
{
    float screenShift = screenSpeed * deltaTime;
    [collide shiftAll:screenShift];
    
    [player movePlayer:deltaTime shift:screenShift];
    [self movePlatforms];
    
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

//0.25 horiztonal gap
//1.25 vertical gap
//vertical range: -4 to 3.25
- (float) generateNumber:(float)smallNumber a:(float)bigNumber
{
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}

float coordY[5] = {-2.75,-1.5,-0.25,1,2.25};
float coordX[10] = {-6,-4.75,-3.5,-2.25,-1,0.25,1.5,2.75,4,5.25};
bool occupied[5][10] = {false};

- (void)spawnPlatform
{
    Model* model;
    
    for(int i = 0; i < 10; i++)
    {
        for(int j = 0; j < 5; j++)
        {
            int ran = arc4random_uniform(2);
            
            if(ran == 1){
                if(occupied[i][j-1]==false)
                {
                    model = [render genCube];
                    [model translate:coordX[i] y:coordY[j] z:0];
                    [model setColour:GLKVector3Make(160,120,40)];
                    [platforms addObject:model];
                    [collide makeBody:coordX[i] yPos:coordY[j] width:0.5 height:0.5 type:PLATFORM];
                    occupied[i][j] = true;
                    //NSLog(@"PLATFORM COORDINATES: %f, %f", coordX[i],coordY[j]);
                }
            }
        }
    }
}

-(void)spawnGrapple
{
    Model* model;
    
    for(int i = 0; i < 10; i++)
    {
        for(int j = 0; j < 5; j++)
        {
            int ran = arc4random_uniform(2);
            
            if(ran == 1)
            {
                if(occupied[i][j]==false)
                {
                    model = [render genCube];
                    [model translate:coordX[i] y:coordY[j] z:0];
                    [model setColour:GLKVector3Make(160,120,40)];
                    [platforms addObject:model];
                    [collide makeBody:coordX[i] yPos:coordY[j] width:0.5 height:0.5 type:GRAPPLE];
                    occupied[i][j] = true;
                    //NSLog(@"GRAPPLE COORDINATES: %f, %f", coordX[i],coordY[j]);
                    j++;
                }
            }
        }
    }
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

- (bool)isLost
{
    return [player isLost];
}

- (void)grappleRespawn
{
    
}

- (void)platformRespawn
{
    
}

@end
