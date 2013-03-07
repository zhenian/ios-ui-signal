//
//  View1.h
//  BeeUISignal
//
//  Created by jun on 13-3-1.
//  Copyright (c) 2013年 zhenian.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "View2.h"
@interface View1 : UIView

@property(nonatomic,strong) View2 *v;

AS_SIGNAL(VIEW1_FIRE)
@end
