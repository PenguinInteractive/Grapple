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
    GLKVector2 target, curDir, momentum;
    Renderer* renderer;
    
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
    
    [player setMMatrix:GLKMatrix4Translate(player.mMatrix, 0.4, 0, 0)];
    [tongue setMMatrix:GLKMatrix4Translate(tongue.mMatrix, 0.35, -0.2, 0)];
    
    target = GLKVector2Make(0, 0);
    curDir = GLKVector2Make(0, 0);
    momentum = GLKVector2Make(0,0);
    
    
}

- (void)movePlayer:(float)deltaTime
{
    float screenShift = -0.001f * deltaTime;
    //NSLog(@"Time: %f", deltaTime);
    
    //Shift everything to the left
    [player setMMatrix:GLKMatrix4Translate(player.mMatrix, screenShift, 0, 0)];
    [tongue setMMatrix:GLKMatrix4Translate(tongue.mMatrix, screenShift, 0, 0)];
    target.x += screenShift;
    
    /*
    if(tongue.x != target.x || tongue.y != target.y){
        NSLog(@"A");
        if(tongue.x - target.x <= 0.1f && tongue.x - target.x >= -0.1f){
            tongue.x = target.x;
        }
        if(tongue.y - target.y <= 0.1f && tongue.y - target.y >= -0.1f){
            tongue.y = target.y;
        }
    }
    else if(player.x != target.x || player.y != target.y){
        NSLog(@"B");
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
    else{
        NSLog(@"C");
    }
    */
    
    [renderer render:player];
    [renderer render:tongue];
}

- (void)fireTongue:(float)x yPos:(float)y
{
    /*
    target.x = x;
    target.y = y;
    NSLog([NSString stringWithFormat:@"Target: x=%1.2f y=%1.2f", target.x, target.y]);
    
    if(tongue.x != target.x){
        tongue.x += 0.1f;
    }
    else{
        NSLog(@"!!-!!");
    }
    if(tongue.y != target.y){
        tongue.y += 0.1f;
    }
    else{
        NSLog(@"-!!-");
    }

    NSLog([NSString stringWithFormat:@"Tounge: x=%1.2f y=%1.2f", tongue.x, tongue.y]);
    */
}

- (void)grapple
{
    /*
    if(target.x == tongue.x && target.y == tongue.y){
        if(player.x != tongue.x){
            player.x += 0.1f;
        }
        if(player.y != tongue.y){
            player.y += 0.1f;
        }
    }
    */
}

@end
