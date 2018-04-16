//
//  Generator.h
//  Grapple
//
//  Created by BCIT Student on 2018-02-25.
//  Copyright © 2018 Penguin Interactive. All rights reserved.
//

#ifndef Generator_h
#define Generator_h
#import "Renderer.h"
#import "Collisions.h"

@interface Generator : NSObject

- (void)setup:(Renderer*)renderer col:(Collisions*)collider;
- (void)Generate:(float)deltaTime;
- (void)fireTongue:(float)x yPos:(float)y;
- (void)attachTongue;

@end

#endif /* Generator_h */
