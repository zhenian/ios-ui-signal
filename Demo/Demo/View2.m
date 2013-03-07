//
//  View2.m
//  BeeUISignal
//
//  Created by jun on 13-3-1.
//  Copyright (c) 2013年 zhenian.com. All rights reserved.
//

#import "View2.h"

@implementation View2

DEF_SIGNAL(VIEW2_FIRE)

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tapRecognizer1 = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBtn:)]autorelease];
        [self addGestureRecognizer:tapRecognizer1];
    }
    return self;
}

-(void)tapBtn:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"---------- view 2 tap, will fire");
    [self sendUISignal:View2.VIEW2_FIRE withObject:self];
}

- (void)handleUISignal_View2:(BeeUISignal *)signal
{
    [super handleUISignal:signal];
    if ( [signal is:View2.VIEW2_FIRE] )
    {
        NSLog(@"----------  view2 handle view 2 ");
    }
}

@end
