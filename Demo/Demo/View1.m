//
//  View1.m
//  BeeUISignal
//
//  Created by jun on 13-3-1.
//  Copyright (c) 2013年 zhenian.com. All rights reserved.
//

#import "View1.h"

@implementation View1
@synthesize v=v_;

DEF_SIGNAL(VIEW1_FIRE)

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        UITapGestureRecognizer *tapRecognizer1 = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBtn:)]autorelease];
        [self addGestureRecognizer:tapRecognizer1];
        
        v_ = [[View2 alloc]initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2)];
        [self addSubview:v_];
        self.backgroundColor = [UIColor redColor];
        self.v.backgroundColor = [UIColor blackColor];
    }
    return self;
}

-(void)tapBtn:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"---------- view 1 tap, will fire");
    [self sendUISignal:View1.VIEW1_FIRE withObject:self];
}

- (void)handleUISignal_View2:(BeeUISignal *)signal
{
    [super handleUISignal:signal];
    if ( [signal is:View2.VIEW2_FIRE] )
    {
        NSLog(@"----------  view1 handle view 2 ");
    }
}


@end
