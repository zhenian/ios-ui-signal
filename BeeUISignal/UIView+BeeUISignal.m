
#import "Bee_UISignal.h"
#import "UIView+BeeUISignal.h"
#import <objc/runtime.h>

#pragma mark -

@implementation UIView(BeeUISignal)

+ (NSString *)SIGNAL
{
	return [self SIGNAL_TYPE];
}

+ (NSString *)SIGNAL_TYPE
{
	return [NSString stringWithFormat:@"signal.%@.", [self description]];
}

- (void)handleUISignal:(BeeUISignal *)signal
{
	if ( self.superview )
	{
		[signal forward:self.superview];
	}
	else
	{
		signal.reach = YES;
	}
}

- (BeeUISignal *)sendUISignal:(NSString *)name
{
	return [self sendUISignal:name withObject:nil from:self];
}

- (BeeUISignal *)sendUISignal:(NSString *)name withObject:(NSObject *)object
{
	return [self sendUISignal:name withObject:object from:self];
}

- (BeeUISignal *)sendUISignal:(NSString *)name withObject:(NSObject *)object from:(id)source
{
#if __has_feature(objc_arc)
    BeeUISignal * signal = [[BeeUISignal alloc] init];
#else
    BeeUISignal * signal = [[[BeeUISignal alloc] init] autorelease];
#endif
	if ( signal )
	{
		signal.source = source ? source : self;
		signal.target = self;
		signal.name = name;		
		signal.object = object;
		[signal send];
	}
	return signal;
}

- (UIViewController *)viewController
{
    
	//LogInfo(@"--------viewController:  %@",self);
    if ([self.superview isKindOfClass:[UIWindow class]] || (self.superview == nil)) {
        id nextResponder = [self nextResponder];
        if ( [nextResponder isKindOfClass:[UIViewController class]] )
        {
            return (UIViewController *)nextResponder;
        }
        else
        {
            return nil;
        }
    }else{
        return nil;
    }
    /*
	if ( nil == self.superview  ){
     
    }else{
     LogInfo(@"%@",self.superview);
     return nil;
     }
	id nextResponder = [self nextResponder];
	if ( [nextResponder isKindOfClass:[UIViewController class]] )
	{
		return (UIViewController *)nextResponder;
	}
	else
	{
		return nil;
	}
     */
}

@end
