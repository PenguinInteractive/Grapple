//
//  ViewController.m
//  Grapple
//
//  Created by Colt King on 2018-02-16.
//  Copyright © 2018 Penguin Interactive. All rights reserved.
//

#import "ViewController.h"
#import "Game.h"

@interface ViewController (){
    Game *gm;
}
@property (weak, nonatomic) IBOutlet UILabel *Score;
@property (weak, nonatomic) IBOutlet UIView *PauseMenu;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    gm = [[Game alloc] init];
    [_PauseMenu setHidden:true];
    [gm setIsPaused:false];
    
    [gm startGame];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Pause:(id)sender {
    [gm setIsPaused:![gm isPaused]];
    [_PauseMenu setHidden:![_PauseMenu isHidden]];
    
}
- (IBAction)OnTap:(id)sender {
    if(![gm isPaused]){
        [gm increaseScore];
                _Score.text= [NSString stringWithFormat:@"%d",[gm playerScore]];
    }
}



@end
