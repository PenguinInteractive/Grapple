//
//  ViewController.m
//  Grapple
//
//  Created by Colt King on 2018-02-16.
//  Copyright © 2018 Penguin Interactive. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    Renderer* glesRenderer;
    //Game* myGame;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Setup the renderer object
    glesRenderer = [[Renderer alloc] init];
    GLKView* view = (GLKView*)self.view;
    [glesRenderer setup:view];
    
    //Create the game and send it to the renderer
    //myGame = [[Game alloc] init];
    //[myGame setRenderer:glesRenderer]
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)update
{
    //Pass update call onto Renderer
    [glesRenderer update];
}

@end
