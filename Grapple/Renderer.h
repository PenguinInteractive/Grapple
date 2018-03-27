//
//  Renderer.h
//  Grapple
//
//  Created by Colt King on 2018-02-23.
//  Copyright © 2018 Penguin Interactive. All rights reserved.
//

#ifndef Renderer_h
#define Renderer_h
#import <GLKit/GLKit.h>
#import "Model.h"

@interface Renderer : NSObject

- (void)update;
- (void)setup:(GLKView*)view;
- (void)render:(Model*)m;

@end

#endif /* Renderer_h */
