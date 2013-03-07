//
//  MainController.m
//  BeeUISignal
//
//  Created by jun on 13-3-1.
//  Copyright (c) 2013年 zhenian.com. All rights reserved.
//

#import "MainController.h"

@interface MainController ()

@end

@implementation MainController

@synthesize v = v_;


- (void)viewDidLoad
{
    [super viewDidLoad];
    v_ = [[View1 alloc]initWithFrame:CGRectMake(50.0, 50.0, 100.0, 100.0)];
    [self.view addSubview:v_];
}

- (void)handleUISignal:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
    NSLog(@"----------  handleUISignal  fire ");

}
- (void)handleUISignal_View1:(BeeUISignal *)signal
{
    [super handleUISignal:signal];
    if ( [signal is:View1.VIEW1_FIRE] )
    {
        NSLog(@"%@",signal);
        NSLog(@"----------  vc handle view1 ");
    }
}

- (void)handleUISignal_View2:(BeeUISignal *)signal
{
    [super handleUISignal:signal];
    if ( [signal is:View2.VIEW2_FIRE] )
    {
        NSLog(@"%@",signal);
        NSLog(@"----------    vc handle view1 ");
    }
}

@end
