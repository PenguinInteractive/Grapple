//
//  Collisions.m
//  Grapple
//
//  Created by Colt King on 2018-04-05.
//  Copyright © 2018 Penguin Interactive. All rights reserved.
//

#import "Collisions.h"
#include <Box2D/Box2D.h>

@implementation Collisions
{
    b2World* world;
    b2Body* player;
    b2Body* tongue;
    
    NSMutableArray* platforms;
    NSMutableArray* grapples;
}

- (void)initWorld
{
    b2Vec2 gravity(0, -10);
    
    world = new b2World(gravity);
}

- (void)update:(float)deltaTime
{
    const float ts = 1.0f/60.0f;
    float t = 0;
    
    while(t+ts <= deltaTime)
    {
        world->Step(ts, 10, 10);
        t += ts;
    }
    
    if(t < deltaTime)
        world->Step(deltaTime-t, 10, 10);
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
    
    body->CreateFixture(&fixtureDef);
    
    //retrieve value from array with [[myArray objectAtIndex:index] pointerValue];
    switch(t)
    {
        case PLATFORM:
            [platforms addObject:[NSValue valueWithPointer:body]];
            break;
        case GRAPPLE:
            [grapples addObject:[NSValue valueWithPointer:body]];
            break;
        case PLAYER:
            player = body;
            break;
        case TONGUE:
            tongue = body;
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

@end

/*class CContactListener : public b2ContactListener
{
public:
    void BeginContact(b2Contact* contact) {};
    void EndContact(b2Contact* contact) {};
    void PreSolve(b2Contact* contact, const b2Manifold* oldManifold)
    {
        b2WorldManifold worldManifold;
        contact->GetWorldManifold(&worldManifold);
        b2PointState state1[2], state2[2];
        b2GetPointStates(state1, state2, oldManifold, contact->GetManifold());
        if (state2[0] == b2_addState)
        {
            //If player collides with grapple
            //b2Body* bodyA = contact->GetFixtureA()->GetBody();
            //bodyA->GetWorld()->DestroyBody(bodyA);
            
            b2Body* bodyA = contact->GetFixtureA()->GetBody();
            CBox2D *parentObj = (__bridge CBox2D *)(bodyA->GetUserData());
            [parentObj RegisterHit];
        }
    }
    void PostSolve(b2Contact* contact, const b2ContactImpulse* impulse) {};
};*/
