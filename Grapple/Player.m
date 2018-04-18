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
    GLKVector3 target, velocity, gravity, tongueStart, playerStart;
    Renderer* renderer;
    Collisions* collide;
    int playerState;
    float speed, drag, tongue2Target, player2Tongue;
    
    Model* player;
    Model* tongue;
    
    float screenWidth, screenHeight;
}

@end

@implementation Player

- (void)setup:(Model*)p tongue:(Model*)t collide:(Collisions*)c
{
    player = p;
    tongue = t;
    collide = c;
    
    speed = 0.02;
    drag = 0.005;
    
    target = GLKVector3Make(0, 0, 0);
    velocity = GLKVector3Make(0, 0, 0);
    gravity = GLKVector3Make(0, -0.001, 0);
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width / 2;
    screenHeight = screenRect.size.height / 2;
}

- (void)movePlayer:(float)deltaTime shift:(float)screenShift
{
    GLKVector2 newPos;
    //GLKVector2 newPos = [collide getPosition:PLAYER index:0];
    //[player moveTo:newPos.x y:newPos.y z:0];
    //newPos = [collide getPosition:TONGUE index:0];
    //[tongue moveTo:newPos.x y:newPos.y z:0];
    
    //target.x += screenShift;
    
    if(playerState == STATE_FIRING)
    {
        //Once collision is implemented, set target to collision point and swap to grappling
        
        //NSLog(@"Target Pos: x=%1.2f y=%1.2f", target.x, target.y);
        
        //If the tongue has reached or passed the target set the tongue to the target
        //NSLog(@"tongue2Target: %1.2f", GLKVector3Length(GLKVector3Subtract(tongue.position, tongueStart)));
        if(GLKVector3Length(GLKVector3Subtract(tongue.position, tongueStart)) >= tongue2Target)
        {
            //[collide setTonguePos:target.x yPos:target.x];
            [collide setTongueVelocity:0 vY:0];
            [collide setPlayerVelocity:0 vY:0];
            
            playerState = STATE_GRAPPLING;
            //NSLog(@"GRAPPLING");
            
            player2Tongue = GLKVector3Length(GLKVector3Subtract(tongue.position, player.position)) - 0.1;
            playerStart = player.position;
            //NSLog(@"playerStart: x=%1.2f y=%1.2f", playerStart.x, playerStart.y);
            //NSLog(@"player2Tongue INITIAL: %1.2f", player2Tongue);
        }
        else
        {
            //Move tongue towards target
            //Find unit vector of tongue to target and multiply by speed
            GLKVector3 direction = GLKVector3Normalize(GLKVector3Subtract(target, tongue.position));
            //NSLog(@"Tongue Direction: x=%1.2f y=%1.2f", direction.x, direction.y);
            direction = GLKVector3MultiplyScalar(direction, speed);
            
            [collide setTongueVelocity:direction.x vY:direction.y];
            //NSLog(@"Tongue Velocity: x=%1.2f y=%1.2f", direction.x, direction.y);
            
            velocity = GLKVector3Add(velocity, gravity);
            
            [collide setPlayerVelocity:velocity.x vY:velocity.y];
        }
    }
    if(playerState == STATE_GRAPPLING)
    {
        //NSLog(@"player2Tongue: %1.2f", GLKVector3Length(GLKVector3Subtract(player.position, playerStart)));
        //If the player is close enough to the target just set them to be the same
        if(GLKVector3Length(GLKVector3Subtract(player.position, playerStart)) >= player2Tongue)
        {
            newPos = [collide getPosition:PLAYER index:0];
            [collide setTonguePos:newPos.x yPos:newPos.y];
            
            [collide setPlayerVelocity:velocity.x vY:velocity.y];
            [collide setTongueVelocity:velocity.x vY:velocity.y];
            
            playerState = STATE_FREEFALL;
            //NSLog(@"FREEFALL");
        }
        else
        {
            //Modify velocity of player based on direction towards target
            //Find unit vector of player to target and multiply by speed
            velocity = GLKVector3Normalize(GLKVector3Subtract(target, player.position));
            velocity = GLKVector3MultiplyScalar(velocity, speed);
            
            [collide setPlayerVelocity:velocity.x vY:velocity.y];
            //NSLog(@"Player Velocity = %1.2f, %1.2f", velocity.x, velocity.y);
        }
    }
    if(playerState == STATE_FREEFALL)
    {
        velocity = GLKVector3Add(velocity, gravity);
        
        //Reduce velocity by a drag factor
        if(velocity.x >= drag)
            velocity.x -= drag;
        else if(velocity.x <= -drag)
            velocity.x += drag;
        
        [collide setPlayerVelocity:velocity.x vY:velocity.y];
        [collide setTongueVelocity:velocity.x vY:velocity.y];
    }
    
    //RUN THE COLLISIONS UPDATE LOOP
    [collide update:deltaTime];
    
    if(playerState == STATE_FREEFALL)
        [collide retractTongue];
    
    //Update the actual positions of the player and tongue
    newPos = [collide getPosition:PLAYER index:0];
    [player moveTo:newPos.x y:newPos.y z:0];
    newPos = [collide getPosition:TONGUE index:0];
    [tongue moveTo:newPos.x y:newPos.y z:0];
    //NSLog(@"Tongue: x=%1.2f y=%1.2f", tongue.position.x, tongue.position.y);
    //NSLog(@"Target: x=%1.2f y=%1.2f", target.x, target.y);
    
    //NSLog(@"Player: x=%1.2f y=%1.2f", player.position.x, player.position.y);
    //NSLog(@"Tongue: x=%1.2f y=%1.2f", tongue.position.x, tongue.position.y);
}

- (void)fireTongue:(float)x yPos:(float)y
{
    if(playerState == STATE_FIRING)
    {
        playerState = STATE_FREEFALL;
        //NSLog(@"FREEFALL");
        //Retract tongue
        [collide retractTongue];
    }
    else if(playerState == STATE_GRAPPLING)
    {
        playerState = STATE_FREEFALL;
        //NSLog(@"FREEFALL");
        //Retract tongue
        [collide retractTongue];
    }
    else
    {
        target.x = (x-screenWidth)/screenWidth*6.5;
        target.y = -(y-screenHeight)/screenHeight*3.5;
        
        tongue2Target = GLKVector3Length(GLKVector3Subtract(target, tongue.position)) - 0.1;
        tongueStart = tongue.position;
        //NSLog(@"tongueStart: x=%1.2f y=%1.2f", tongueStart.x, tongueStart.y);
        //NSLog(@"tongue2Target INITIAL: %1.2f", tongue2Target);
        
        playerState = STATE_FIRING;
        //NSLog(@"FIRING");
        
        //NSLog(@"Target: x=%1.2f y=%1.2f", target.x, target.y);
    }
}

- (void)attachTongue
{
    if(player.position.x == tongue.position.x && player.position.y == tongue.position.y)
        return;
    
    [collide setTongueVelocity:0 vY:0];
    [collide setPlayerVelocity:0 vY:0];
    
    playerState = STATE_GRAPPLING;
    //NSLog(@"GRAPPLING");
    
    GLKVector2 tonPos = [collide getPosition:TONGUE index:0];
    GLKVector3 tonPos3 = GLKVector3Make(tonPos.x, tonPos.y, 0);
    
    player2Tongue = GLKVector3Length(GLKVector3Subtract(tonPos3, player.position)) - 0.1;
    playerStart = player.position;
}

- (void)retractTongue
{
    playerState = STATE_FREEFALL;
    //NSLog(@"FREEFALL");
    //Retract tongue
    [collide retractTongue];
}

@end
