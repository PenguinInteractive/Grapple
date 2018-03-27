//
//  HighScore.h
//  Grapple
//
//  Created by Jessica Pointon on 2018-03-21.
//  Copyright © 2018 Penguin Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HighScore : NSObject

-(void)addScore:(int)score;
-(void)sortScore;
-(void)displayScore;

@end
