//
//  Collisions.m
//  Grapple
//
//  Created by Colt King on 2018-04-05.
//  Copyright © 2018 Penguin Interactive. All rights reserved.
//

#import "Collisions.h"
#include <Box2D/Box2D.h>
#include "CContactListener.hpp"
#import "Game.h"

@implementation Collisions
{
    b2World* world;
    b2Body* player;
    b2Body* tongue;
    CContactListener* cListener;
    
    NSMutableArray* platforms;
    NSMutableArray* grapples;
    
    Game* game;
    int* objectCodes;
    int numCodes;
}

- (void)initWorld:(Game*)g
{
    game = g;
    
    b2Vec2 gravity(0, 0);
    
    objectCodes = (int*)malloc(42*sizeof(int));
    numCodes = 0;
    
    world = new b2World(gravity);
    cListener = new CContactListener();
    cListener->setup();
    world->SetContactListener(cListener);
    
    [self createWalls];
    
    platforms = [[NSMutableArray alloc] initWithCapacity:20];
    grapples = [[NSMutableArray alloc] initWithCapacity:20];
}

- (void)update:(float)deltaTime
{
    const float ts = 1.0f/60.0f;
    float t = 0;
    
    while(t+ts <= deltaTime)
    {
        world->Step(ts, 10, 10);
        [self checkCollisions];
        t += ts;
    }
    
    if(t < deltaTime)
    {
        world->Step(deltaTime-t, 10, 10);
        [self checkCollisions];
    }
}

- (void)createWalls
{
    //Make the walls
    b2BodyDef wallsDef;
    wallsDef.type = b2_staticBody;
    wallsDef.position.Set(0, 0);
    
    b2Body* walls = world->CreateBody(&wallsDef);
    
    //define fixture
    b2EdgeShape edge;
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &edge;
    fixtureDef.filter.categoryBits = (short)PLATFORM;
    fixtureDef.filter.maskBits = (short)PLAYER;
    
    
    edge.Set(b2Vec2(-7.5, -4), b2Vec2(7.5, -4));
    walls->CreateFixture(&fixtureDef);
    
    edge.Set(b2Vec2(7.5, -4), b2Vec2(7.5, 4));
    walls->CreateFixture(&fixtureDef);
    
    edge.Set(b2Vec2(7.5, 4), b2Vec2(-7.5, 4));
    walls->CreateFixture(&fixtureDef);
    
    edge.Set(b2Vec2(-7.5, 4), b2Vec2(-7.5, -4));
    walls->CreateFixture(&fixtureDef);
}

- (void)makeBody:(float)x yPos:(float)y width:(float)w height:(float)h type:(int)t
{
    //define body and set parameters
    b2BodyDef bodyDef;
    
    switch(t)
    {
        case PLATFORM:
            bodyDef.type = b2_kinematicBody;
            break;
        case GRAPPLE:
            bodyDef.type = b2_kinematicBody;
            break;
        case PLAYER:
            bodyDef.type = b2_dynamicBody;
            break;
        case TONGUE:
            bodyDef.type = b2_dynamicBody;
            break;
    }
    
    bodyDef.position.Set(x, y);
    
    b2Body* body = world->CreateBody(&bodyDef);
    
    //define floor fixture and needed parameters
    b2PolygonShape box;
    box.SetAsBox(w, h);
    
    //define fixture
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &box;
    fixtureDef.density = 1.0f;
    fixtureDef.friction = 0.3f;
    fixtureDef.restitution = 0.6f;
    
    //int data;
    
    switch(t)
    {
        case PLAYER:
            fixtureDef.filter.categoryBits = (short)PLAYER;
            fixtureDef.filter.maskBits = (short)PLATFORM;
            
            body->CreateFixture(&fixtureDef);
            player = body;
            break;
        case TONGUE:
            fixtureDef.filter.categoryBits = (short)PLAYER;
            fixtureDef.filter.maskBits = (short)PLATFORM;
            
            body->CreateFixture(&fixtureDef);
            tongue = body;
            break;
        case GRAPPLE:
            fixtureDef.filter.categoryBits = (short)PLATFORM;
            fixtureDef.filter.maskBits = (short)PLAYER;
            
            body->CreateFixture(&fixtureDef);
            [grapples addObject:[NSValue valueWithPointer:body]];
            break;
        case PLATFORM:
            fixtureDef.filter.categoryBits = (short)PLATFORM;
            fixtureDef.filter.maskBits = (short)PLAYER;
            
            body->CreateFixture(&fixtureDef);
            [platforms addObject:[NSValue valueWithPointer:body]];
            break;
    }
    
    numCodes++;
}

- (void)checkCollisions
{
    //If there are any unhandled collisions
    if(cListener->hasCollided() == 0)
        return;
    
    b2Body** dynamics = cListener->getDynamic();
    b2Body** kinematics = cListener->getKinematic();
    
    for(int i = 0; i < cListener->hasCollided(); i++)
    {
        b2Body* d = dynamics[i];
        b2Body* k = kinematics[i];
        
        bool wasTongue = false;
        
        //Determine whether collision involved player or tongue
        if(d->GetPosition().x == tongue->GetPosition().x
           && d->GetPosition().y == tongue->GetPosition().y)
            wasTongue = true;
        /*else if(d->GetPosition().x == player->GetPosition().x
                && d->GetPosition().y == player->GetPosition().y)
            wasTongue = false;
        else
            NSLog(@"Neither dynamic matches");*/
        
        //Determine which terrain object was involved in the collision
        int which = [self whichGrapple:k->GetPosition().x yPos:k->GetPosition().y];
        
        //if it's a grapple, collect it
        if(which >= 0)
        {
            //NSLog(@"COLLECTED GRAPPLE");
            [game collectGrapple:which];
        }
        else
        {
            //if the player collided with a platform nothing happens
            if(!wasTongue)
                continue;
            
            //NSLog(@"ATTACHED TONGUE");
            [game attachTongue];
        }
    }
    
    cListener->resetCollided();
}

- (int)whichGrapple:(float)x yPos:(float)y
{
    for(int i = 0; i < [grapples count]; i++)
    {
        b2Vec2 pos = ((b2Body*)[[grapples objectAtIndex:i] pointerValue])->GetPosition();
        if(pos.x == x && pos.y == y)
            return i;
    }
    return -1;
}

- (GLKVector2)getPosition:(int)type index:(int)i
{
    b2Body* body;
    
    switch(type)
    {
        case PLAYER:
            body = player;
            break;
        case TONGUE:
            body = tongue;
            break;
        case PLATFORM:
            body = (b2Body*)[[platforms objectAtIndex:i] pointerValue];
            break;
        case GRAPPLE:
            body = (b2Body*)[[grapples objectAtIndex:i] pointerValue];
            break;
        default:
            body = player;
    }
    
    b2Vec2 pos = body->GetPosition();
    
    return GLKVector2Make(pos.x, pos.y);
}

- (void)removeBody:(int)type index:(int)i
{
    switch(type)
    {
        case PLAYER:
            player = NULL;
            break;
        case TONGUE:
            tongue = NULL;
            break;
        case PLATFORM:
            [platforms removeObjectAtIndex:(NSUInteger)i];
            break;
        case GRAPPLE:
            [grapples removeObjectAtIndex:(NSUInteger)i];
            break;
        default:
            break;
    }
}

- (void)shiftAll:(float)screenShift
{
    for(int i = 0; i < [platforms count]; i++)
    {
        b2Body* body = (b2Body*)[[platforms objectAtIndex:i] pointerValue];
        b2Vec2 pos = body->GetPosition();
        pos.x += screenShift;
        body->SetTransform(pos, 0);
    }
    
    for(int i = 0; i < [grapples count]; i++)
    {
        b2Body* body = (b2Body*)[[grapples objectAtIndex:i] pointerValue];
        b2Vec2 pos = body->GetPosition();
        pos.x += screenShift;
        body->SetTransform(pos, 0);
    }
    
    b2Vec2 pos = player->GetPosition();
    pos.x += screenShift;
    player->SetTransform(pos, 0);
    
    pos = tongue->GetPosition();
    pos.x += screenShift;
    tongue->SetTransform(pos, 0);
}

- (void)setTongueVelocity:(float)x vY:(float)y
{
    tongue->SetLinearVelocity(b2Vec2(x, y));
}

- (void)setPlayerVelocity:(float)x vY:(float)y
{
    player->SetLinearVelocity(b2Vec2(x, y));
}

- (void)setPlayerPos:(float)x yPos:(float)y
{
    b2Vec2 pos = b2Vec2(x, y);
    player->SetTransform(pos, 0);
}

- (void)setTonguePos:(float)x yPos:(float)y
{
    b2Vec2 pos = b2Vec2(x, y);
    tongue->SetTransform(pos, 0);
}

- (void)retractTongue
{
    b2Vec2 pos = player->GetPosition();
    tongue->SetTransform(pos, 0);
}

@end
