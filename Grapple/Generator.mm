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
}
@end


@implementation Generator
Model* model;

//Setup platforms with a reasonable capacity later
- (void)setup:(Renderer*)renderer p:(Player *)plar
{
    screenSpeed = -0.001f;
    
    render = renderer;
    player = plar;
    
    playerModel = [render genCube];
    tongue = [render genCube];
    
    collide = [[Collisions alloc] init];
    [collide initWorld];
    
    [playerModel translate:0.4 y:0 z:0];
    [playerModel setColour:GLKVector3Make(20,170,230)];
    [collide makeBody:0.4 yPos:0 width:0.5 height:0.5 type:PLAYER];
    
    [tongue translate:0.35 y:-0.2 z:0];
    [tongue setColour:GLKVector3Make(255,180,255)];
    [collide makeBody:0.35 yPos:-0.2 width:0.5 height:0.5 type:TONGUE];
    
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
    [player movePlayer:deltaTime scrnSpd:screenSpeed];
    [self movePlatforms:deltaTime];
    
 //   NSLog(@"Player Position X: %f", [player getPositionX]);
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
    float screenShift = screenSpeed * deltaTime;
    [collide shiftAll:screenShift];
    
    for(int i = 0; i < [platforms count]; i++)
    {
        //GLKVector2 newPos = [collide getPosition:PLATFORM index:i];
        //[platforms[i] translate:newPos.x y:0 z:0];
        [platforms[i] translate:screenShift y:0 z:0];
    }
    for(int j = 0; j < grapples.count; j++)
    {
        //GLKVector2 newPos = [collide getPosition:GRAPPLE index:j];
        //[grapples[j] translate:newPos.x y:0 z:0];
        [grapples[j] translate:screenShift y:0 z:0];
    }
}

- (void)fireTongue:(float)x yPos:(float)y
{
    [player fireTongue:x yPos:y];
}
//0.25 horiztonal gap
//1.25 vertical gap
//vertical range: -4 to 3.25

- (float) generateNumber:(float)smallNumber a:(float)bigNumber{
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}

float coordY[5] = {-2.75,-1.5,-0.25,1,2.25};
float coordX[10] = {-6,-4.75,-3.5,-2.25,-1,0.25,1.5,2.75,4,5.25};
bool occupied[5][10] = {false};

- (void)spawnPlatform
{
    //SpawnPlatform will pick a random y value then add a new vector2 with the xposition equal to the right side of the screen and yposition equal to the random y
    //Store it in the array
    
    for(int i = 0; i < 10; i++){
        for(int j = 0; j < 5; j++){
            int ran = arc4random_uniform(2);
            if(ran == 1){
                if(occupied[i][j-1]==false){
                    model = [render genCube];
                    [model translate:coordX[i] y:coordY[j] z:0];
                    [model setColour:GLKVector3Make(160,120,40)];
                    [platforms addObject:model];
                    occupied[i][j] = true;
                    NSLog(@"PLATFORM COORDANATES: %f, %f", coordX[i],coordY[j]);
                }
            }
        }

    }
}

-(void)spawnGrapple{
    for(int i = 0; i < 10; i++){
        for(int j = 0; j < 5; j++){
            int ran = arc4random_uniform(2);
                
            if(ran == 1){
                if(occupied[i][j]==false){
                    model = [render genCube];
                    [model translate:coordX[i] y:coordY[j] z:0];
                    [model setColour:GLKVector3Make(160,120,40)];
                    [platforms addObject:model];
                    NSLog(@"B GRAPPLE COORDANATES: %f, %f", coordX[i],coordY[j]);
                    j++;
                }
            }
            
            NSLog(@"j = %d", j);
        }
        
    }

}

@end
