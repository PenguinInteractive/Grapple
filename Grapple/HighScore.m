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
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/test.txt"];
    NSString *dataFile = [NSString stringWithContentsOfFile:docPath usedEncoding:NSUTF8StringEncoding error:NULL];
    
    [dataFile writeToFile:docPath atomically:YES encoding:NSUTF8StringEncoding error:NULL];
//    NSString *str = [NSString stringWithFormat:@"%d",score];
    
}

- (void) sortScore{
    
}

- (void) displayScore{
    
}

@end
