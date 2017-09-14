#import "testReport.h"

@implementation TestReport

-(id) init
{
	self = [super init];

	if (self) {
		csv_values      = [NSMutableArray  new];
		pudding_values  = [NSMutableArray  new];
		pudding_results = [NSMutableArray  new];
		error_messages  = [NSMutableArray  new];
		fail_items      = [NSMutableArray  new];

		text_acumulator = [NSMutableString new];
		log_data        = [NSMutableString new];

		start_date = [NSDate new];
		end_date   = [NSDate new];
		attributes = [NSMutableDictionary new];

		uart_log = [NSMutableData new];
		parametricData = [NSMutableDictionary new];
	}

    return self;
}

-(void) dealloc
{
	[csv_values      release];
	[pudding_values  release];
	[pudding_results release];
	[error_messages  release];
	[fail_items      release];

	[text_acumulator release];
	[log_data        release];

	[start_date release];
	[end_date   release];
	[attributes release];

	[uart_log release];

	[super dealloc];
}


-(void) push_CSV:(NSString *)value
{
	[csv_values addObject:value];
}

-(void) push_iPudding:(NSString *)value
{
	[pudding_values addObject:value];
}

-(void) push_iPudding_result:(NSString *)result
{
	[pudding_results addObject:result];
}

-(void) push_error_message:(NSString *)error
{
	[error_messages addObject:error];
}

/*
-(void) push_fail_item:(TestItem *)item
{
	[fail_items addObject:item];
}
*/



-(void) push_tex_to_acum:(NSString *)text
{
	[text_acumulator appendString:text];
}

-(void) push_log_data:(NSString *)data
{
	[log_data appendString:data];
}

-(void) add_attribute:(NSString *)attr forKey:(NSString *)key
{
	[attributes setObject:attr forKey:key];
}

-(NSString *) attributeForKey:(NSString *)key
{
	NSString *retval;

	retval = [attributes objectForKey:key];

	return retval ? retval : @"NA";
}

-(void) add_parameter:(NSString*)value forKey:(NSString *)key
{
	[parametricData setObject:value forKey:key];
}

-(NSString*) parameterForKey:(NSString*) key
{
	return [parametricData objectForKey:key];
}

-(NSArray*) parameterKeys
{
	return [parametricData allKeys];
}

-(void)flush
{
    [csv_values removeAllObjects];
    [pudding_values removeAllObjects];
    [pudding_results removeAllObjects];
}

@synthesize processControlMessage;
@synthesize test_time;
@synthesize csv_values;
@synthesize pudding_values;
@synthesize pudding_results;
@synthesize error_messages;
@synthesize fail_items;
@synthesize text_acumulator;
@synthesize log_data;
@synthesize portId;

@synthesize start_date;
@synthesize end_date;

@synthesize uart_log;

@dynamic global_pass;
-(BOOL) global_pass
{
	return ([fail_items count] == 0);
}

-(void) logData:(NSData *)data withContext:(id)ctx
{
	[uart_log appendData:data];
}

@end

