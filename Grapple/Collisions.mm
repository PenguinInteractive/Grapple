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
    
    NSMutableArray* platforms;
    NSMutableArray* grapples;
    
    Game* game;
}

- (void)initWorld:(Game*)g
{
    game = g;
    
    b2Vec2 gravity(0, -0.1);
    
    world = new b2World(gravity);
    world->SetContactListener(new CContactListener());
    
    [self createWalls];
    
    platforms = [[NSMutableArray alloc] initWithCapacity:20];
    grapples = [[NSMutableArray alloc] initWithCapacity:20];
}

- (void)update:(float)deltaTime
{
    const float ts = 1.0f/6.0f;
    float t = 0;
    
    while(t+ts <= deltaTime)
    {
        world->Step(ts, 10, 10);
        t += ts;
    }
    
    if(t < deltaTime)
        world->Step(deltaTime-t, 10, 10);
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
    
    
    edge.Set(b2Vec2(-10, -3.5), b2Vec2(10, -3.5));
    walls->CreateFixture(&fixtureDef);
    
    edge.Set(b2Vec2(10, -3.5), b2Vec2(10, 10));
    walls->CreateFixture(&fixtureDef);
    
    edge.Set(b2Vec2(10, 10), b2Vec2(-10, 10));
    walls->CreateFixture(&fixtureDef);
    
    edge.Set(b2Vec2(-10, 10), b2Vec2(-10, -3.5));
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
    
    switch(t)
    {
        case PLAYER:
            fixtureDef.filter.categoryBits = (short)PLAYER;
            fixtureDef.filter.maskBits = (short)PLATFORM;
            body->CreateFixture(&fixtureDef)->SetUserData((int*)PLAYER);
            player = body;
            break;
        case TONGUE:
            fixtureDef.filter.categoryBits = (short)PLAYER;
            fixtureDef.filter.maskBits = (short)PLATFORM;
            body->CreateFixture(&fixtureDef)->SetUserData((int*)TONGUE);
            tongue = body;
            break;
        case GRAPPLE:
            fixtureDef.filter.categoryBits = (short)PLATFORM;
            fixtureDef.filter.maskBits = (short)PLAYER;
            //Passes in index in array as well as type
            body->CreateFixture(&fixtureDef)->SetUserData((int*)GRAPPLE+(10*[grapples count]));
            [grapples addObject:[NSValue valueWithPointer:body]];
            break;
        case PLATFORM:
            fixtureDef.filter.categoryBits = (short)PLATFORM;
            fixtureDef.filter.maskBits = (short)PLAYER;
            //Passes in index in array as well as type
            body->CreateFixture(&fixtureDef)->SetUserData((int*)PLATFORM+(10*[platforms count]));
            [platforms addObject:[NSValue valueWithPointer:body]];
            break;
    }
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

- (void)adjustPlayerPos:(float)x yPos:(float)y
{
    b2Vec2 pos = player->GetPosition();
    pos.x += x;
    pos.y += y;
    player->SetTransform(pos, 0);
}

- (void)adjustTonguePos:(float)x yPos:(float)y
{
    b2Vec2 pos = tongue->GetPosition();
    pos.x += x;
    pos.y += y;
    tongue->SetTransform(pos, 0);
}

- (void)retractTongue
{
    b2Vec2 pos = player->GetPosition();
    tongue->SetTransform(pos, 0);
}

- (void)collectGrapple
{
    [game collectGrapple];
}

- (void)attachTongue
{
    [game attachTongue];
}

@end
