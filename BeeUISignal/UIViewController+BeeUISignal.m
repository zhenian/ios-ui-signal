
#import "Bee_UISignal.h"
#import "UIViewController+BeeUISignal.h"
#import "UIView+BeeUISignal.h"

#import <objc/runtime.h>

#pragma mark -

@implementation UIViewController(BeeUISignal)

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
	signal.reach = YES;
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

@end
