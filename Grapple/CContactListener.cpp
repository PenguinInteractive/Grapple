//
//  CContactListener.cpp
//  Grapple
//
//  Created by Colt King on 2018-04-15.
//  Copyright © 2018 Penguin Interactive. All rights reserved.
//

#include "CContactListener.hpp"

void CContactListener::BeginContact(b2Contact* contact)
{
    b2Fixture* fa = contact->GetFixtureA();
    b2Fixture* fb = contact->GetFixtureB();
    
    if(fa == NULL || fb == NULL)
        return;
    if(fa->GetUserData() == NULL || fb->GetUserData() == NULL)
        return;
    
    int aNum = *(int*)(fa->GetUserData());
    int bNum = *(int*)(fb->GetUserData());
    
    collided = true;
    
    //if one of the objects is the tongue
    if(aNum % 10 == 1)
        collider = bNum;
    else if(bNum % 10 == 1)
        collider = aNum;
    else if(aNum % 10 == 2 && bNum % 10 == 4) //if one of the objects is the player
        collider = bNum;
    else if(bNum % 10 == 2 && aNum % 10 == 4)
        collider = aNum;
    else
        collided = false;
}

void CContactListener::EndContact(b2Contact* contact) {};
void CContactListener::PreSolve(b2Contact* contact, const b2Manifold* oldManifold) {};
void CContactListener::PostSolve(b2Contact* contact, const b2ContactImpulse* impulse) {};

bool CContactListener::hasCollided()
{
    return collided;
}

int CContactListener::getCollider()
{
    return collider;
}
