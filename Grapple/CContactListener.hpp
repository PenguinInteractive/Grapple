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
    int collided;
    int arraySize;
    b2Body **dynamic, **kinematic;
    void enlargeArrays();
public:
    void BeginContact(b2Contact* contact);
    void EndContact(b2Contact* contact);
    void PreSolve(b2Contact* contact, const b2Manifold* oldManifold);
    void PostSolve(b2Contact* contact, const b2ContactImpulse* impulse);
    void setup();
    int hasCollided();
    void resetCollided();
    b2Body** getDynamic();
    b2Body** getKinematic();
};

#endif /* CContactListener_hpp */
