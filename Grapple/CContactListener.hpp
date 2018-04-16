//
//  CContactListener.hpp
//  Grapple
//
//  Created by Colt King on 2018-04-15.
//  Copyright © 2018 Penguin Interactive. All rights reserved.
//

#ifndef CContactListener_hpp
#define CContactListener_hpp

#include <stdio.h>
#include <Box2D/Box2D.h>

class CContactListener : public b2ContactListener
{
private:
    bool collided;
    int collider;
public:
    void BeginContact(b2Contact* contact);
    void EndContact(b2Contact* contact);
    void PreSolve(b2Contact* contact, const b2Manifold* oldManifold);
    void PostSolve(b2Contact* contact, const b2ContactImpulse* impulse);
    bool hasCollided();
    int getCollider();
};

#endif /* CContactListener_hpp */
