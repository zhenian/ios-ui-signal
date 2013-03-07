
#import "Bee_UISignal.h"

#pragma mark -

@interface UIView(BeeUISignal)

+ (NSString *)SIGNAL;
+ (NSString *)SIGNAL_TYPE;

- (void)handleUISignal:(BeeUISignal *)signal;

- (BeeUISignal *)sendUISignal:(NSString *)name;
- (BeeUISignal *)sendUISignal:(NSString *)name withObject:(NSObject *)object;
- (BeeUISignal *)sendUISignal:(NSString *)name withObject:(NSObject *)object from:(id)source;


- (UIViewController *)viewController;

@end
