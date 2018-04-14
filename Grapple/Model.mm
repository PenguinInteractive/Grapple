//
//  Model.m
//  Grapple
//
//  Created by Colt King on 2018-03-26.
//  Copyright © 2018 Penguin Interactive. All rights reserved.
//

#import "Model.h"
#include <Box2D/Box2D.h>

@implementation Model
{
    b2Body* body;
}

@synthesize vertices, normals, texCoords, indices, numIndices, position, colour, mMatrix;

+ (Model*)copyObj:(Model*)base
{
    //copy all the values from base and put them into this object except for mMatrix
    return [[Model alloc] init];
}

+ (Model*)readObj:(NSString*)path
{
    /*
    //NOTE: THE CODE FOR FILL LINES/TOKENS ARRAYS IS NOT YET COMPATIBLE WITH THE CODE FILL OTHER ARRAYS
    //Puts the data from the OBJ file into a string
    NSString* content = [NSString stringWithContentsOfFile:objPath encoding:NSUTF8StringEncoding error:NULL];
    
    //Separates the file into lines
    NSArray* lines = [content componentsSeparatedByString:@"\n"];
    NSMutableArray* tokens = [NSMutableArray arrayWithCapacity:[lines count]];
    
    //Separates the lines into tokens
    for(int i = 0; i < [lines count]; i++)
    {
    tokens[i] = [lines[i] componentsSeparatedByString:@" "];
    }
    
    int v = 0, n = 0, t = 0;
    
    for(int i = 0; i < lines.length; i++)
        if(lines[i][0] == 'v')
            v++
        else if(lines[i][0] == 'vn')
            n++
        else if(lines[i][0] == 'vt')
            t++
                    
                    
    Vector3[] vertices = Vector3[v]
    Vector3[] normals = Vector3[n]
    Vector3[] texCoords = Vector3[t]
    
    for(int i = 0; i < lines.length; i++)
        if(lines[i][0] == 'v')
            vertices[vertices.length-(v--)] = Vector3(lines[i][1], lines[i][2], lines[i][3])
        else if(lines[i][0] == 'n')
            normals[normals.length-(n--)] = Vector3(lines[i][1], lines[i][2], lines[i][3])
        else if(lines[i][0] == 't')
            texCoords[texCoords.length-(t--)] = Vector3(lines[i][1], lines[i][2], lines[i][3])

    //put arrays into respective model arrays

    //for now don't worry about textures
    */
    
    return [[Model alloc] init];
}

- (void)translate:(float)x y:(float)y z:(float)z
{
    position.x += x;
    position.y += y;
    position.z += z;
    
    mMatrix = GLKMatrix4Translate(mMatrix, x, y, z);
}

@end
