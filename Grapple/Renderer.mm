//
//  Renderer.m
//  Grapple
//
//  Created by Colt King on 2018-02-23.
//  Copyright © 2018 Penguin Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Renderer.h"
#import <GLKit/GLKit.h>
#include "GLESRenderer.hpp"

enum
{
    UNIFORM_MODELVIEWPROJECTION_MATRIX,
    UNIFORM_NORMAL_MATRIX,
    UNIFORM_PASSTHROUGH,
    UNIFORM_SHADEINFRAG,
    NUM_UNIFORMS
};
GLint uniforms[NUM_UNIFORMS];

float cameraDistance = 5.0f;
float fov = 80.0f;
float frontClip = 0.0f;
float backClip = 40.0f;

@interface Renderer ()
{
    GLKView* myView;
    GLuint programObject;
    GLESRenderer gles;
    
    //Product of the model, view, and projection matrices
    GLKMatrix4 mvp;
    GLKMatrix3 normalMatrix;
}

@end

@implementation Renderer

- (void)setup:(GLKView*)view
{
    //Give the view a OpenGL 3.0 context
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    
    if(!view.context)
    {
        //Perhaps check for 2.0 later
        NSLog(@"Failed to create the context");
    }
    
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    //Store the view and link its context to OpenGL
    myView = view;
    [EAGLContext setCurrentContext:view.context];
    
    //Setup the shaders
    if(![self setupShaders])
    {
        NSLog(@"Failed to setup shaders");
        return;
    }
    
    //Makes the default background color red
    glClearColor(1.0f, 0.0f, 0.0f, 1.0f);
    
    //Enables the depth test
    glEnable(GL_DEPTH_TEST);
}

- (void)update
{
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    //Perspective Transformations
    mvp = GLKMatrix4Translate(GLKMatrix4Identity, 0.0f, 0.0f, cameraDistance);
    normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(mvp), NULL);
    
    //Get the apect ratio of the window
    float aspect = (float)myView.drawableWidth / (float)myView.drawableHeight;
    GLKMatrix4 perspective = GLKMatrix4MakePerspective(fov * M_PI /180.0f, aspect, frontClip, backClip);
    
    mvp = GLKMatrix4Multiply(perspective, mvp);
}

- (void)render:(NSString*)objPath xPos:(float)x yPos:(float)y
{
    //Updates the uniform values based on the matrices
    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, FALSE, (const float*)mvp.m);
    glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, normalMatrix.m);
    glUniform1i(uniforms[UNIFORM_PASSTHROUGH], false);
    glUniform1i(uniforms[UNIFORM_SHADEINFRAG], true);
    
    //Sets the boundaries of the viewport
    glViewport(0, 0, (int)myView.drawableWidth, (int)myView.drawableHeight);

    //Gives OpenGL the program object
    glUseProgram(programObject);
    
    float *vertices, *texCoords, *normals;
    int *indices;
    int numIndices;
    
    //Get the info from the obj file
    numIndices = [self readObj:objPath vert:&vertices tex:&texCoords norm:&normals ind:&indices];
    
    //Attribute 0: Vertices
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3*sizeof(GLfloat), vertices);
    glEnableVertexAttribArray(0); //Enable array
    
    //Attribute 1: Colour?
    glVertexAttrib4f(1, 1.0f, 0.0f, 0.0f, 1.0f);
    
    //Attribute 2: Normals
    glVertexAttribPointer(2, 3, GL_FLOAT, GL_FALSE, 3*sizeof(GLfloat), normals);
    glEnableVertexAttribArray(2); //Enable array
    
    //Duplicate line? Is this necessary?
    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, FALSE, (const float*)mvp.m);
    
    //Draw the indices and fill the triangles between them
    glDrawElements(GL_TRIANGLES, numIndices, GL_UNSIGNED_INT, indices);
}

- (int)readObj:(NSString*)objPath vert:(float**)vertices tex:(float**)texCoords norm:(float**)normals ind:(int**)indices
{
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
    
    //Skip lines 0-2
    //i = 3
    //while (token[0] is v)
    //read tokens 1-3 into vertices array
    //i++
    
    //while (token[0] is vt)
    //read tokens 1-3 into texCoords array
    //i++
    
    //while (token[0] is vn)
    //read tokens 1-3 into normals array
    //i++
    
    //read in the other lines (I don't remember what they do)
    //i++ for each one
    
    //while (token[0] is f)
    //read tokens 1-3 into indices array
    //i++
    
    //something else needs to be done with the indices
    //figure that out later
    
    return 1; //return numIndices
}

- (void)renderCube:(float)x yPos:(float)y
{
    NSLog([NSString stringWithFormat:@"x=%1.2f y=%1.2f", x, y]);
    
    //Updates the uniform values based on the matrices
    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, FALSE, (const float*)mvp.m);
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
        0.5f,  0.5f, -0.5f,
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
        1.0f, 0.0f, 0.0f,
    };
    
    /*float texCoords[] =
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
        1.0f, 0.0f,
    };*/
    
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
    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, FALSE, (const float*)mvp.m);
    
    //Draw the indices and fill the triangles between them
    glDrawElements(GL_TRIANGLES, 36, GL_UNSIGNED_INT, indices);
}

- (bool)setupShaders
{
    // Load shaders
    char *vShaderStr = gles.LoadShaderFile([[[NSBundle mainBundle] pathForResource:[[NSString stringWithUTF8String:"Shader.vsh"] stringByDeletingPathExtension] ofType:[[NSString stringWithUTF8String:"Shader.vsh"] pathExtension]] cStringUsingEncoding:1]);
    char *fShaderStr = gles.LoadShaderFile([[[NSBundle mainBundle] pathForResource:[[NSString stringWithUTF8String:"Shader.fsh"] stringByDeletingPathExtension] ofType:[[NSString stringWithUTF8String:"Shader.fsh"] pathExtension]] cStringUsingEncoding:1]);
    programObject = gles.LoadProgram(vShaderStr, fShaderStr);
    if (programObject == 0)
        return false;
    
    // Set up uniform variables
    uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(programObject, "modelViewProjectionMatrix");
    uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(programObject, "normalMatrix");
    uniforms[UNIFORM_PASSTHROUGH] = glGetUniformLocation(programObject, "passThrough");
    uniforms[UNIFORM_SHADEINFRAG] = glGetUniformLocation(programObject, "shadeInFrag");
    
    return true;
}



@end
