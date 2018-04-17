//
//  Player.m
//  Grapple
//
//  Created by Colt King on 2018-02-27.
//  Copyright © 2018 Penguin Interactive. All rights reserved.
//

#import "Player.h"

enum
{
    STATE_FREEFALL,
    STATE_FIRING,
    STATE_GRAPPLING,
    NUM_STATES
};

float moveSpeed = 0.008;
float drag = 0.00001;

@interface Player()
{
    GLKVector3 target, curDir, velocity, gravity;
    Renderer* renderer;
    Collisions* collide;
    int playerState;
    
    Model* player;
    Model* tongue;
}

@end

@implementation Player

- (void)setup:(Model*)p tongue:(Model*)t collide:(Collisions*)c
{
    player = p;
    tongue = t;
    collide = c;
    
    _isLost = false;
    
    target = GLKVector3Make(0, 0, 0);
    curDir = GLKVector3Make(0, 0, 0);
    velocity = GLKVector3Make(0, 0, 0);
    gravity = GLKVector3Make(0, -0.001, 0);
}

- (void)movePlayer:(float)deltaTime scrnSpd:(float)screenSpeed
{
    float screenShift = screenSpeed * deltaTime;
    //NSLog(@"Screenshift: %f", screenShift);
    
    //Shift everything to the left
    [player translate:screenShift y:0 z:0];
    //NSLog(@"player: %f, %f, %f", player.position.x, player.position.y, player.position.z);
    [tongue translate:screenShift y:0 z:0];
    //NSLog(@"tongue: %f, %f, %f", tongue.position.x, tongue.position.y, tongue.position.z);
    target.x += screenShift;
    
    if(playerState == STATE_FIRING)
    {
        //Once collision is implemented, set target to collision point and swap to grappling
        
        //If the tongue is close enough to the target just set them to be the same
        if(tongue.position.x - target.x <= 0.1f && tongue.position.x - target.x >= -0.1f)
            [tongue translate:target.x-tongue.position.x y:0 z:0];
        if(tongue.position.y - target.y <= 0.1f && tongue.position.y - target.y >= -0.1f)
            [tongue translate:0 y:target.y-tongue.position.y z:0];
        
        //If the tongue reached the target successfully
        if(GLKVector3Distance(tongue.position, target) <= 0.1f)
        {
            playerState = STATE_GRAPPLING;
            NSLog(@"GRAPPLING");
        }
        else
        {
            //Move tongue towards target
            //Find unit vector of tongue to target and multiply by speed
            GLKVector3 direction = GLKVector3Normalize(GLKVector3Subtract(target, tongue.position));
            direction = GLKVector3MultiplyScalar(direction, deltaTime*moveSpeed);
            
            [tongue translate:direction.x y:direction.y z:direction.z];
            //NSLog(@"Tongue: x=%1.2f y=%1.2f", tongue.position.x, tongue.position.y);
        }
    }
    else if(playerState == STATE_GRAPPLING)
    {
        //If the player is close enough to the target just set them to be the same
        if(player.position.x - target.x <= 0.1f && player.position.x - target.x >= -0.1f)
            [player translate:target.x-player.position.x y:0 z:0];
        if(player.position.y - target.y <= 0.1f && player.position.y - target.y >= -0.1f)
            [player translate:0 y:target.y-player.position.y z:0];
        
        //If the player reached the target successfully
        if(GLKVector3Distance(player.position, target) <= 0.1f)
        {
            playerState = STATE_FREEFALL;
        }
        else
        {
            //Modify velocity of player based on direction towards target
            //Find unit vector of player to target and multiply by speed
            velocity = GLKVector3Normalize(GLKVector3Subtract(target, player.position));
            velocity = GLKVector3MultiplyScalar(velocity, deltaTime*moveSpeed);
        }
    }
    else
    {
        velocity = GLKVector3Add(velocity, GLKVector3MultiplyScalar(gravity, deltaTime));
        
        //Reduce velocity by a drag factor
        if(velocity.x >= drag*deltaTime)
            velocity.x -= drag*deltaTime;
        else if(velocity.x <= -drag*deltaTime)
            velocity.x += drag*deltaTime;
    }
    
    [player translate:velocity.x y:velocity.y z:velocity.z];
    
    if(player.position.y < -3)
    {
        [player translate:0 y:-3-player.position.y z:0];
        velocity.x = 0;
    }
    
    if(playerState == STATE_FREEFALL)
    {
        [tongue setMMatrix:player.mMatrix];
        [tongue setPosition:player.position];
    }
    
    if(player.position.x < -6.5){
        NSLog(@"LOSE");
        [self setIsLost:true];
    }
    else{
        NSLog(@"Keep Playing");
    }
    
}

- (void)fireTongue:(float)x yPos:(float)y
{
    if(playerState == STATE_FIRING)
    {
        playerState = STATE_FREEFALL;
        NSLog(@"FREEFALL");
        //Retract tongue
        [tongue setMMatrix:player.mMatrix];
        [tongue setPosition:player.position];
    }
    else if(playerState == STATE_GRAPPLING)
    {
        playerState = STATE_FREEFALL;
        NSLog(@"FREEFALL");
        //Retract tongue
        [tongue setMMatrix:player.mMatrix];
        [tongue setPosition:player.position];
    }
    else
    {
        target.x = x/700*14-7;
        target.y = -(y/400*14-5);
        
        playerState = STATE_FIRING;
        NSLog(@"FIRING");
        
        NSLog(@"Target: x=%1.2f y=%1.2f", target.x, target.y);
    }
}

@end
