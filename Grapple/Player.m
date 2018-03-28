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

@interface Player()
{
    GLKVector3 target, curDir, velocity, gravity;
    Renderer* renderer;
    int playerState;
    
    Model* player;
    Model* tongue;
}

@end

@implementation Player

- (void)setup:(Renderer*)render
{
    renderer = render;
    
    player = [renderer genCube];
    tongue = [renderer genCube];
    
    [player translate:0.4 y:0 z:0];
    [tongue translate:0.35 y:-0.2 z:0];
    
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
        
        NSLog(@"FIRING");
        //If the tongue is close enough to the target just set them to be the same
        if(tongue.position.x - target.x <= 0.1f && tongue.position.x - target.x >= -0.1f)
            [tongue translate:target.x-tongue.position.x y:0 z:0];
        if(tongue.position.y - target.y <= 0.1f && tongue.position.y - target.y >= -0.1f)
            [tongue translate:0 y:target.y-tongue.position.y z:0];
        
        //If the tongue reached the target successfully
        if(tongue.position.x == target.x && tongue.position.y == target.y)
        {
            playerState = STATE_GRAPPLING;
        }
        else
        {
            //Move tongue towards target
            //Find unit vector of tongue to target and multiply by speed
            GLKVector3 direction = GLKVector3Normalize(GLKVector3Subtract(target, tongue.position));
            direction = GLKVector3MultiplyScalar(direction, 0.1f);
            
            [tongue translate:direction.x y:direction.y z:direction.z];
        }
    }
    else if(playerState == STATE_GRAPPLING)
    {
        NSLog(@"GRAPPLING");
        //If the player is close enough to the target just set them to be the same
        if(player.position.x - target.x <= 0.1f && player.position.x - target.x >= -0.1f)
            [player translate:target.x-player.position.x y:0 z:0];
        if(player.position.y - target.y <= 0.1f && player.position.y - target.y >= -0.1f)
            [player translate:0 y:target.y-player.position.y z:0];
        
        //If the player reached the target successfully
        if(player.position.x == target.x && player.position.y == target.y)
        {
            playerState = STATE_FREEFALL;
        }
        else
        {
            //Modify velocity of player based on direction towards target
            //Find unit vector of player to target and multiply by speed
            GLKVector3 direction = GLKVector3Normalize(GLKVector3Subtract(target, player.position));
            direction = GLKVector3MultiplyScalar(direction, 0.1f);
            
            velocity = GLKVector3Add(velocity, direction);
        }
    }
    else
    {
        //NSLog(@"FREEFALL");
        velocity = GLKVector3Add(velocity, GLKVector3MultiplyScalar(gravity, deltaTime));
        
        //Eventually reduce velocity by a drag factor
    }
    
    [player translate:velocity.x y:velocity.y z:velocity.z];
    
    if(player.position.y < -3)
    {
        [player translate:0 y:-3-player.position.y z:0];
    }
    
    [renderer render:player];
    [renderer render:tongue];
}

- (void)fireTongue:(float)x yPos:(float)y
{
    target.x = x;
    target.y = y;
    
    playerState = STATE_FIRING;
    NSLog(@"STARTED FIRING");
    
    NSLog(@"Target: x=%1.2f y=%1.2f", x, y);
}

- (void)letGo
{
    if(playerState == STATE_FIRING)
    {
        playerState = STATE_FREEFALL;
        //Retract tongue
        [tongue translate:tongue.position.x-player.position.x y:tongue.position.y-player.position.y z:0];
    }
    else if(playerState == STATE_GRAPPLING)
    {
        playerState = STATE_FREEFALL;
        [tongue translate:tongue.position.x-player.position.x y:tongue.position.y-player.position.y z:0];
    }
}

@end
