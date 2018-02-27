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
    Renderer* glesRenderer;
}

@property (weak, nonatomic) IBOutlet UILabel *Score;
@property (weak, nonatomic) IBOutlet UIView *PauseMenu;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Setup the renderer object
    glesRenderer = [[Renderer alloc] init];
    GLKView* view = (GLKView*)self.view;
    [glesRenderer setup:view];
    
    gm = [[Game alloc] init];
    //[gm setRenderer:glesRenderer] or [gm setup:glesRenderer]
    //or something pass the renderer to the game please
    [_PauseMenu setHidden:true];
    [gm setIsPaused:false];
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

    }
}

- (void)update
{
    //Pass update call onto Renderer
    if(![gm isPaused]){
        [glesRenderer update];
        _Score.text= [NSString stringWithFormat:@"%d",[gm playerScore]];
    }
    
}

@end

