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
    GLKVector3 target, curDir, momentum;
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
    
    [player translate:0.4 y:0 z:0];
    [tongue translate:0.35 y:-0.2 z:0];
    
    target = GLKVector3Make(0, 0, 0);
    curDir = GLKVector3Make(0, 0, 0);
    momentum = GLKVector3Make(0, 0, 0);
}

- (void)movePlayer:(float)deltaTime
{
    float screenShift = -0.001f * deltaTime;
    NSLog(@"Screenshift: %f", screenShift);
    
    //Shift everything to the left
    [player translate:screenShift y:0 z:0];
    NSLog(@"player: %f, %f, %f", player.position.x, player.position.y, player.position.z);
    [tongue translate:screenShift y:0 z:0];
    NSLog(@"tongue: %f, %f, %f", tongue.position.x, tongue.position.y, tongue.position.z);
    target.x += screenShift;
    
    if(tongue.position.x != target.x || tongue.position.y != target.y){
        NSLog(@"A");
        if(tongue.position.x - target.x <= 0.1f && tongue.position.x - target.x >= -0.1f){
            [tongue translate:target.x-tongue.position.x y:0 z:0];
        }
        if(tongue.position.y - target.y <= 0.1f && tongue.position.y - target.y >= -0.1f){
            [tongue translate:0 y:target.y-tongue.position.y z:0];
        }
    }
    else if(player.position.x != target.x || player.position.y != target.y){
        NSLog(@"B");
        if(player.position.x - target.x <= 0.1f && player.position.x - target.x >= -0.1f)
            [player translate:target.x-player.position.x y:0 z:0];
        if(player.position.y - target.y <= 0.1f && player.position.y - target.y >= -0.1f)
            [player translate:0 y:target.y-player.position.y z:0];
        //find unit vector of player to tongue and multiply by speed
        GLKVector3 direction = GLKVector3Normalize(GLKVector3Subtract(target, player.position));
        direction = GLKVector3MultiplyScalar(direction, 0.1f);
        
        [player translate:direction.x y:direction.y z:direction.z];
        
        //set curDir to allow momentum
    }
    else{
        NSLog(@"C");
    }
    
    [renderer render:player];
    [renderer render:tongue];
}

- (void)fireTongue:(float)x yPos:(float)y
{
    target.x = x;
    target.y = y;
    //NSLog([NSString stringWithFormat:@"Target: x=%1.2f y=%1.2f", target.x, target.y]);
    
    if(tongue.position.x != target.x){
        [tongue translate:0.1 y:0 z:0];
    }
    else{
        NSLog(@"!!-!!");
    }
    if(tongue.position.y != target.y){
        [tongue translate:0 y:0.1 z:0];
    }
    else{
        NSLog(@"-!!-");
    }

    //NSLog([NSString stringWithFormat:@"Tounge: x=%1.2f y=%1.2f", tongue.position.x, tongue.position.y]);
}

- (void)grapple
{
    if(target.x == tongue.position.x && target.y == tongue.position.y){
        if(player.position.x != tongue.position.x){
            [player translate:0.1 y:0 z:0];
        }
        if(player.position.y != tongue.position.y){
            [player translate:0 y:0.1 z:0];
        }
    }
}

@end
