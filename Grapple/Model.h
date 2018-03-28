//
//  Model.h
//  Grapple
//
//  Created by Colt King on 2018-03-26.
//  Copyright © 2018 Penguin Interactive. All rights reserved.
//

#ifndef Model_h
#define Model_h

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface Model : NSObject

@property float* vertices;
@property float* normals;
@property float* texCoords;
@property int* indices;
@property int numIndices;
@property GLKVector3 position;
@property GLKVector3 colour;
@property GLKMatrix4 mMatrix;

+ (Model*)copyObj:(Model*)base;

+ (Model*)readObj:(NSString*)path;

- (void)translate:(float)x y:(float)y z:(float)z;

@end

#endif /* Model_h */
