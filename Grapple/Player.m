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

float drag = 0.01;

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
    
    target = GLKVector3Make(0, 0, 0);
    curDir = GLKVector3Make(0, 0, 0);
    velocity = GLKVector3Make(0, 0, 0);
}

- (void)movePlayer:(float)deltaTime shift:(float)screenShift
{
    GLKVector2 newPos = [collide getPosition:PLAYER index:0];
    [player moveTo:newPos.x y:newPos.y z:0];
    newPos = [collide getPosition:TONGUE index:0];
    [tongue moveTo:newPos.x y:newPos.y z:0];
    
    target.x += screenShift;
    
    if(playerState == STATE_FIRING)
    {
        //Once collision is implemented, set target to collision point and swap to grappling
        
        //If the tongue is close enough to the target just set them to be the same
        if(tongue.position.x - target.x <= 0.1f && tongue.position.x - target.x >= -0.1f)
        {
            [collide adjustTonguePos:target.x-tongue.position.x yPos:0];
            [player translate:target.x-tongue.position.x y:0 z:0];
        }
        if(tongue.position.y - target.y <= 0.1f && tongue.position.y - target.y >= -0.1f)
        {
            [collide adjustTonguePos:0 yPos:target.y-tongue.position.y];
            [player translate:0 y:target.y-tongue.position.y z:0];
        }
        
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
            
            [collide setTongueVelocity:direction.x vY:direction.y];
            NSLog(@"Tongue Dir: x=%1.2f y=%1.2f", direction.x, direction.y);
            NSLog(@"Tongue: x=%1.2f y=%1.2f", tongue.position.x, tongue.position.y);
        }
    }
    else if(playerState == STATE_GRAPPLING)
    {
        //If the player is close enough to the target just set them to be the same
        if(player.position.x - target.x <= 0.1f && player.position.x - target.x >= -0.1f)
        {
            [collide adjustPlayerPos:target.x-player.position.x yPos:0];
            [player translate:target.x-player.position.x y:0 z:0];
        }
        if(player.position.y - target.y <= 0.1f && player.position.y - target.y >= -0.1f)
        {
            [collide adjustPlayerPos:0 yPos:target.y-player.position.y];
            [player translate:0 y:target.y-player.position.y z:0];
        }
        
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
        }
    }
    else
    {
        //Reduce velocity by a drag factor
        if(velocity.x >= drag)
            velocity.x -= drag;
        else if(velocity.x <= -drag)
            velocity.x += drag;
    }
    
    //NSLog(@"Velocity = %1.2f, %1.2f", velocity.x, velocity.y);
    
    [collide setPlayerVelocity:velocity.x vY:velocity.y];
    
    //RUN THE COLLISIONS UPDATE LOOP
    [collide update:deltaTime];
    
    if(playerState == STATE_FREEFALL)
        [collide retractTongue];
    
    //Update the actual positions of the player and tongue
    newPos = [collide getPosition:PLAYER index:0];
    [player moveTo:newPos.x y:newPos.y z:0];
    newPos = [collide getPosition:TONGUE index:0];
    [tongue moveTo:newPos.x y:newPos.y z:0];
    
    //NSLog(@"Player: x=%1.2f y=%1.2f", player.position.x, player.position.y);
    //NSLog(@"Tongue: x=%1.2f y=%1.2f", tongue.position.x, tongue.position.y);
}

- (void)fireTongue:(float)x yPos:(float)y
{
    if(playerState == STATE_FIRING)
    {
        playerState = STATE_FREEFALL;
        NSLog(@"FREEFALL");
        //Retract tongue
        [collide retractTongue];
    }
    else if(playerState == STATE_GRAPPLING)
    {
        playerState = STATE_FREEFALL;
        NSLog(@"FREEFALL");
        //Retract tongue
        [collide retractTongue];
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
