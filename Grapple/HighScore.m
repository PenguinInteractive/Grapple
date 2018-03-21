//
//  HighScore.m
//  Grapple
//
//  Created by Jessica Pointon on 2018-03-21.
//  Copyright © 2018 Penguin Interactive. All rights reserved.
//

#import "HighScore.h"

@implementation HighScore

- (void) addScore:(int)score{
    NSLog(@"8");
    [[NSFileManager defaultManager] createFileAtPath:@"/Users/a00951134/Desktop/hi/test.txt" contents:nil attributes:nil];
    
    NSString *str = [NSString stringWithFormat:@"%d",score];
    
    [str writeToFile:@"/Users/a00951134/Desktop/test.txt" atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (void) sortScore{
    
}

- (void) displayScore{
    
}

@end
