//
//  HighScores.m
//  Grapple
//
//  Created by Jessica Pointon on 2018-04-14.
//  Copyright © 2018 Penguin Interactive. All rights reserved.
//

#import "HighScores.h"

@interface HighScores(){
    
}
@property (strong, nonatomic) IBOutlet UILabel *ScoreOne;
@property (strong, nonatomic) IBOutlet UILabel *ScoreTwo;
@property (strong, nonatomic) IBOutlet UILabel *ScoreThree;
@property (strong, nonatomic) IBOutlet UILabel *ScoreFour;
@property (strong, nonatomic) IBOutlet UILabel *ScoreFive;


@end

@implementation HighScores
NSData *data;
NSString *thribble = @"scores";

int scores[10] = {-1};
int array[50] = {-1};

int sort(const void *x, const void *y) {
    return (*(int*)y - *(int*)x);
}

- (void) viewDidLoad{
    [super viewDidLoad];
//    scores[0] = 65;
//    scores[1] = 134;
//    scores[2] = 548;
///    scores[3] = 23;
//    scores[4] = 246;
    [self print];
}
-(void)addScore:(int)score called:(int)called{
    scores[called]=score;
}
-(void)populate{
    int r;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    data = [NSData dataWithBytes:scores length:50 * sizeof(int)];
    
    [prefs setObject:data forKey:thribble];
        
    
    //    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    data = [NSData dataWithBytes:CFBridgingRetain(data) length:50 * sizeof(int)];
    
    [prefs setObject:data forKey:thribble]; //populates outside datafile with scores
    
}

- (void) print{ //prints top five scores
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *dataTwo;
    dataTwo = [prefs dataForKey:thribble];
    
    memcpy(array, dataTwo.bytes, dataTwo.length);
    
    qsort(scores, 5, sizeof(int), sort);
    
    _ScoreOne.text = [NSString stringWithFormat:@"%d",scores[0]];
    _ScoreTwo.text = [NSString stringWithFormat:@"%d",scores[1]];
    _ScoreThree.text = [NSString stringWithFormat:@"%d",scores[2]];
    _ScoreFour.text = [NSString stringWithFormat:@"%d",scores[3]];
    _ScoreFive.text = [NSString stringWithFormat:@"%d",scores[4]];
}
@end
