//
//  Collisions.m
//  Grapple
//
//  Created by Colt King on 2018-04-05.
//  Copyright © 2018 Penguin Interactive. All rights reserved.
//

#import "Collisions.h"
#include <Box2D/Box2D.h>
#import <GLKit/GLKit.h>

@implementation Collisions
{
    b2World* world;
    GLKVector2 bodyMove;
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

//Makes a body with the given position and dimensions, adds it the the world, and returns it
- (b2Body*)makeBody:(float)x yPos:(float)y width:(float)w height:(float)h type:(b2BodyType)t
{
    //define body and set parameters
    b2BodyDef bodyDef;
    bodyDef.type = t;
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
    
    return body;
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
