
#import <Foundation/Foundation.h>
#import "Bee_UISignal.h"
#pragma mark -

@interface UIViewController(BeeUISignal)

+ (NSString *)SIGNAL;
+ (NSString *)SIGNAL_TYPE;

- (void)handleUISignal:(BeeUISignal *)signal;

- (BeeUISignal *)sendUISignal:(NSString *)name;
- (BeeUISignal *)sendUISignal:(NSString *)name withObject:(NSObject *)object;
- (BeeUISignal *)sendUISignal:(NSString *)name withObject:(NSObject *)object from:(id)source;

@end
