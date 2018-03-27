//
//  Player.m
//  Grapple
//
//  Created by Colt King on 2018-02-27.
//  Copyright © 2018 Penguin Interactive. All rights reserved.
//

#import "Player.h"

@interface Player()
{
    GLKVector2 target, curDir;
    Renderer* renderer;
    
    Model* player;
    Model* tongue;
}

@end

@implementation Player

- (void)setup:(Renderer*)render
{
    renderer = render;
    
    //USE CREATE CUBE FUNCTION IN MODEL TO INITIALIZE PLAYER AND TONGUE
    
    target = GLKVector2Make(0, 0);
    curDir = GLKVector2Make(0, 0);
}

- (void)movePlayer:(float)deltaTime
{
    float screenShift = 0.001f * deltaTime;
    
    //Shift everything to the left
    //player.x += screenShift; DO THIS TO MMATRICES
    //tongue.x += screenShift;
    target.x += screenShift;
    
    /*
    //If the tongue is not yet at the target move it towards the target
    if(tongue.x != target.x || tongue.y != target.y)
    {
        //find unit vector of tongue to target and multiply by speed
    }
    //If the tongue is at the target but the player is not move the player towards the target
    else if(player.x != target.x || player.y != target.y)
    {
        if(player.x - target.x <= 0.1f && player.x - target.x >= -0.1f)
            player.x = target.x;
        if(player.y - target.y <= 0.1f && player.y - target.y >= -0.1f)
            player.y = target.y;
        
        //find unit vector of player to tongue and multiply by speed
        GLKVector2 direction = GLKVector2Normalize(GLKVector2Subtract(target, player));
        direction = GLKVector2MultiplyScalar(direction, 0.1f);
        
        player = GLKVector2Add(player, direction);
        
        //set curDir to allow momentum
    }
    //If the player is not grappling at all just add the "momentum"
    else
    {
        
    }
    */
    
    [renderer render:player];
    [renderer render:tongue];
}

- (void)fireTongue:(float)x yPos:(float)y
{
    target.x = x;
    target.y = y;
    
    //don't do this later once actual tongue firing is implemented
    //tongue.x = x;
    //tongue.y = y;
}

- (void)grapple
{
    //target.x = player.x;
    //tongue.x = player.x;
    //target.y = player.y;
    //tongue.y = player.y;
}

@end
