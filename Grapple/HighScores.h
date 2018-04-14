//
//  HighScores.h
//  Grapple
//
//  Created by Jessica Pointon on 2018-04-14.
//  Copyright © 2018 Penguin Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HighScores : UIViewController

-(void)addScore:(int)score
         called:(int)called; //called on losing
-(void)populate;
@end
