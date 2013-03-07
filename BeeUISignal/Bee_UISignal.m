
#import "Bee_UISignal.h"
#import "UIView+BeeUISignal.h"
#import <objc/runtime.h>

#pragma mark -

#undef	MAX_POOL_SIZE
#define MAX_POOL_SIZE	(8)

#pragma mark - 

@implementation NSObject(BeeUISignalResponder)

+ (NSString *)SIGNAL
{
	return [self SIGNAL_TYPE];
}

+ (NSString *)SIGNAL_TYPE
{
	return [NSString stringWithFormat:@"signal.%@.", [self description]];
}

- (BOOL)isUISignalResponder
{
	if ( [self respondsToSelector:@selector(handleUISignal:)] )
	{
		return YES;
	}
	else
	{
		return NO;
	}
}

@end

#pragma mark -

@interface BeeUISignal(Private)
- (void)routes;
@end

#pragma mark -

@implementation BeeUISignal

@synthesize dead = _dead;
@synthesize reach = _reach;
@synthesize jump = _jump;
@synthesize source = _source;
@synthesize target = _target;
@synthesize name = _name;
@synthesize object = _object;
@synthesize returnValue = _returnValue;

@synthesize initTimeStamp = _initTimeStamp;
@synthesize sendTimeStamp = _sendTimeStamp;
@synthesize reachTimeStamp = _reachTimeStamp;

@synthesize timeElapsed;
@synthesize timeCostPending;
@synthesize timeCostExecution;


@synthesize callPath = _callPath;

@dynamic YES_VALUE;
+ (NSString *)YES_VALUE
{
    static NSString * __local = nil;
    if ( nil == __local )
    {
        __local = [NSString stringWithFormat:@"%@", @"YES_VALUE"];
    }
    return __local;
}
@dynamic NO_VALUE;
+ (NSString *)NO_VALUE
{
    static NSString * __local = nil;
    if ( nil == __local )
    {
        __local = [NSString stringWithFormat:@"%@", @"NO_VALUE"];
    }
    return __local;
}


- (id)init
{
	self = [super init];
	if ( self )
	{
		[self clear];
	}
	return self;
}

- (NSString *)description
{
	//return [NSString stringWithFormat:@"%@", _name];
    
	return [NSString stringWithFormat:@"%@ > %@", _name, _callPath];
}

- (BOOL)is:(NSString *)name
{
	return [_name isEqualToString:name];
}

- (BOOL)isKindOf:(NSString *)prefix
{
	return [_name hasPrefix:prefix];
}

- (BOOL)isSentFrom:(id)source
{
	return (self.source == source) ? YES : NO;
}

- (BOOL)send
{	
	if ( _dead )
		return NO;
	
	_sendTimeStamp = [NSDate timeIntervalSinceReferenceDate];

    if ( _source == _target )
	{
		[_callPath appendFormat:@"%@", [[_source class] description]];
	}
	else
	{
		[_callPath appendFormat:@"%@ > %@", [[_source class] description], [[_target class] description]];
	}
    
	if ( _reach )
	{
		[_callPath appendFormat:@" > [DONE]"];
	}
    
    
	if ( [_target isKindOfClass:[UIView class]] || [_target isKindOfClass:[UIViewController class]] )
	{
		_jump = 1;
		
		[self routes];
	}
	else
	{
		_reachTimeStamp = [NSDate timeIntervalSinceReferenceDate];
		_reach = YES;		
	}

	return _reach;
}

- (BOOL)forward:(id)target
{	
	if ( _dead )
		return NO;

    [_callPath appendFormat:@" > %@", [[target class] description]];
	
	if ( _reach )
	{
		[_callPath appendFormat:@" > [DONE]"];
	}
    
	if ( [_target isKindOfClass:[UIView class]] || [_target isKindOfClass:[UIViewController class]] )
	{
		_jump += 1;

		_target = target;	
		
		[self routes];
	}
	else
	{
		_reachTimeStamp = [NSDate timeIntervalSinceReferenceDate];
		_reach = YES;		
	}

	return _reach;
}

- (void)routes
{
	NSArray * array = [_name componentsSeparatedByString:@"."];
	if ( array && array.count > 1 )
	{
		//NSString * prefix = (NSString *)[array objectAtIndex:0];
		NSString * clazz = (NSString *)[array objectAtIndex:1];
		NSString * method = (NSString *)[array objectAtIndex:2];
        
        //NSLog(@"-------   %@    %@    %@",prefix,clazz,method);
        //NSLog(@"==== (%@)\n (%@)\n ",[self.source class],[self.target class]);
		NSObject * targetObject = _target;
		
		if ( [_target isKindOfClass:[UIView class]] )
		{
			UIViewController * viewController = [(UIView *)_target viewController];
			if ( viewController )
			{
				targetObject = viewController;
			}
		}

		{
			NSString * selectorName;
			SEL selector;
			
			selectorName = [NSString stringWithFormat:@"handleUISignal_%@_%@:", clazz, method];
			selector = NSSelectorFromString(selectorName);
			
			if ( [targetObject respondsToSelector:selector] )
			{
				[targetObject performSelector:selector withObject:self];
				return;
			}
			
			selectorName = [NSString stringWithFormat:@"handleUISignal_%@:", clazz];
			selector = NSSelectorFromString(selectorName);
			
			if ( [targetObject respondsToSelector:selector] )
			{
				[targetObject performSelector:selector withObject:self];
				return;
			}

		
			selectorName = [NSString stringWithFormat:@"handle%@:", clazz];
			selector = NSSelectorFromString(selectorName);
			
			if ( [targetObject respondsToSelector:selector] )
			{
				[targetObject performSelector:selector withObject:self];
				return;
			}
		}	
	}

	Class rtti = [_source class];
	for ( ;; )
	{
		if ( nil == rtti )
			break;
		
		NSString *	selectorName = [NSString stringWithFormat:@"handle%@:", [rtti description]];
		SEL			selector = NSSelectorFromString(selectorName);

		if ( [_target respondsToSelector:selector] )
		{
			[_target performSelector:selector withObject:self];
			break;
		}
	
		rtti = class_getSuperclass( rtti );
	}

	if ( nil == rtti )
	{
		if ( [_target respondsToSelector:@selector(handleUISignal:)] )
		{
            NSLog(@"------  handleUISignal \n (%@)\n",_target);
			[_target performSelector:@selector(handleUISignal:) withObject:self];
		}
	}
}

- (NSTimeInterval)timeElapsed
{
	return _reachTimeStamp - _initTimeStamp;
}

- (NSTimeInterval)timeCostPending
{
	return _sendTimeStamp - _initTimeStamp;
}

- (NSTimeInterval)timeCostExecution
{
	return _reachTimeStamp - _sendTimeStamp;
}

- (void)clear
{
	self.dead = NO;
	self.reach = NO;
	self.jump = 0;
	self.source = nil;
	self.target = nil;
	self.name = @"signal.nil.nil";
	self.object = nil;
	self.returnValue = nil;
	
	_initTimeStamp = [NSDate timeIntervalSinceReferenceDate];
	_sendTimeStamp = _initTimeStamp;
	_reachTimeStamp = _initTimeStamp;
    
    
	self.callPath = [NSMutableString string];

}

- (BOOL)boolValue
{
	if ( self.returnValue == BeeUISignal.YES_VALUE )
	{
		return YES;
	}
	else if ( self.returnValue == BeeUISignal.NO_VALUE )
	{
		return NO;
	}
	
	return NO;
}

- (void)returnYES
{
	self.returnValue = BeeUISignal.YES_VALUE;
}

- (void)returnNO
{
	self.returnValue = BeeUISignal.NO_VALUE;
}

- (void)dealloc
{
#if __has_feature(objc_arc)
#else
	[_name release];

	[_object release];
	[_returnValue release];
	
	[super dealloc];
#endif
}

@end
