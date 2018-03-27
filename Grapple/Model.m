//
//  Model.m
//  Grapple
//
//  Created by Colt King on 2018-03-26.
//  Copyright © 2018 Penguin Interactive. All rights reserved.
//

#import "Model.h"

@implementation Model

@synthesize vertices, normals, texCoords, indices, numIndices, mMatrix;

+ (Model*)copyObj:(Model*)base
{
    //copy all the values from base and put them into this object except for mMatrix
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
}

//Fix this to return a cube model
/*- (void)renderCube:(float)x yPos:(float)y
{
    NSLog([NSString stringWithFormat:@"x=%1.2f y=%1.2f", x, y]);

    //Updates the uniform values based on the matrices
    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, FALSE, (const float*)vp.m);
    glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, normalMatrix.m);
    glUniform1i(uniforms[UNIFORM_PASSTHROUGH], false);
    glUniform1i(uniforms[UNIFORM_SHADEINFRAG], true);

    //Sets the boundaries of the viewport
    glViewport(0, 0, (int)myView.drawableWidth, (int)myView.drawableHeight);

    //Gives OpenGL the program object
    glUseProgram(programObject);

    float vertices[] =
    {
        -0.5f, -0.5f, -0.5f,
        -0.5f, -0.5f,  0.5f,
        0.5f, -0.5f,  0.5f,
        0.5f, -0.5f, -0.5f,
        -0.5f,  0.5f, -0.5f,
        -0.5f,  0.5f,  0.5f,
        0.5f,  0.5f,  0.5f,
        0.5f,  0.5f, -0.5f,
        -0.5f, -0.5f, -0.5f,
        -0.5f,  0.5f, -0.5f,
        0.5f,  0.5f, -0.5f,
        0.5f, -0.5f, -0.5f,
        -0.5f, -0.5f, 0.5f,
        -0.5f,  0.5f, 0.5f,
        0.5f,  0.5f, 0.5f,
        0.5f, -0.5f, 0.5f,
        -0.5f, -0.5f, -0.5f,
        -0.5f, -0.5f,  0.5f,
        -0.5f,  0.5f,  0.5f,
        -0.5f,  0.5f, -0.5f,
        0.5f, -0.5f, -0.5f,
        0.5f, -0.5f,  0.5f,
        0.5f,  0.5f,  0.5f,
        0.5f,  0.5f, -0.5f
    };

    float normals[] =
    {
        0.0f, -1.0f, 0.0f,
        0.0f, -1.0f, 0.0f,
        0.0f, -1.0f, 0.0f,
        0.0f, -1.0f, 0.0f,
        0.0f, 1.0f, 0.0f,
        0.0f, 1.0f, 0.0f,
        0.0f, 1.0f, 0.0f,
        0.0f, 1.0f, 0.0f,
        0.0f, 0.0f, -1.0f,
        0.0f, 0.0f, -1.0f,
        0.0f, 0.0f, -1.0f,
        0.0f, 0.0f, -1.0f,
        0.0f, 0.0f, 1.0f,
        0.0f, 0.0f, 1.0f,
        0.0f, 0.0f, 1.0f,
        0.0f, 0.0f, 1.0f,
        -1.0f, 0.0f, 0.0f,
        -1.0f, 0.0f, 0.0f,
        -1.0f, 0.0f, 0.0f,
        -1.0f, 0.0f, 0.0f,
        1.0f, 0.0f, 0.0f,
        1.0f, 0.0f, 0.0f,
        1.0f, 0.0f, 0.0f,
        1.0f, 0.0f, 0.0f
    };

    float texCoords[] =
    {
        0.0f, 0.0f,
        0.0f, 1.0f,
        1.0f, 1.0f,
        1.0f, 0.0f,
        1.0f, 0.0f,
        1.0f, 1.0f,
        0.0f, 1.0f,
        0.0f, 0.0f,
        0.0f, 0.0f,
        0.0f, 1.0f,
        1.0f, 1.0f,
        1.0f, 0.0f,
        0.0f, 0.0f,
        0.0f, 1.0f,
        1.0f, 1.0f,
        1.0f, 0.0f,
        0.0f, 0.0f,
        0.0f, 1.0f,
        1.0f, 1.0f,
        1.0f, 0.0f,
        0.0f, 0.0f,
        0.0f, 1.0f,
        1.0f, 1.0f,
        1.0f, 0.0f
    };

    GLuint indices[] =
    {
        0, 2, 1,
        0, 3, 2,
        4, 5, 6,
        4, 6, 7,
        8, 9, 10,
        8, 10, 11,
        12, 15, 14,
        12, 14, 13,
        16, 17, 18,
        16, 18, 19,
        20, 23, 22,
        20, 22, 21
    };
 
    //Attribute 0: Vertices
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3*sizeof(GLfloat), vertices);
    glEnableVertexAttribArray(0); //Enable array
 
    //Attribute 1: Colour?
    glVertexAttrib4f(1, 1.0f, 0.0f, 0.0f, 1.0f);
 
    //Attribute 2: Normals
    glVertexAttribPointer(2, 3, GL_FLOAT, GL_FALSE, 3*sizeof(GLfloat), normals);
    glEnableVertexAttribArray(2); //Enable array

    //Duplicate line? Is this necessary?
    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, FALSE, (const float*)vp.m);

    //Draw the indices and fill the triangles between them
    glDrawElements(GL_TRIANGLES, 36, GL_UNSIGNED_INT, indices);
}*/

@end
