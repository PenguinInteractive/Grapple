//
//  Generator.h
//  Grapple
//
//  Created by BCIT Student on 2018-02-25.
//  Copyright © 2018 Penguin Interactive. All rights reserved.
//

#ifndef Generator_h
#define Generator_h


#endif /* Generator_h */
@interface Generator : NSObject


-(void)movePlatform:(float)deltaTime;
-(void)Generate:(float)deltaTime;

-(void) setXpos : (float) xp;
-(void) setYpos : (float) yp;

-(float) xpos;
-(float) ypos;
@end
