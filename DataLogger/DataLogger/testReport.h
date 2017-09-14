//#import "testItem.h"
#pragma once

@interface TestReport: NSObject
{
	@private
	NSMutableArray  *csv_values;
	NSMutableArray  *pudding_values;
	NSMutableArray  *pudding_results;
	NSMutableArray  *error_messages;
	NSMutableArray  *fail_items;

	NSMutableString *text_acumulator;
	NSMutableString *log_data;

	NSDate          *start_date;
	NSDate          *end_date;

	NSMutableDictionary *attributes;
	NSMutableDictionary *parametricData;

	NSMutableData   *uart_log;
	
	unsigned*		test_time;
	NSString*		processControlMessage;
	unsigned		portId;
}

-(void) push_CSV:(NSString *)value;
-(void) push_iPudding:(NSString *)value;
-(void) push_iPudding_result:(NSString *)result;
-(void) push_error_message:(NSString *)error;
//-(void) push_fail_item:(TestItem *)item;

-(void) push_tex_to_acum:(NSString *)text;
-(void) push_log_data:(NSString *)data;

-(void)       add_attribute:(NSString *)attr forKey:(NSString *)key;
-(NSString *) attributeForKey:(NSString *)key;

//Right now, this is a dictionary because the TDL wanted this in less than the amount of time it takes to implement
//It has more structure than this and should be its own type
-(void) add_parameter:(NSString*)value forKey:(NSString *)key;
-(NSString*) parameterForKey:(NSString*) key;
-(NSArray*) parameterKeys;

-(void)flush;

#define kAttributeSerialNumber @"Attribute-SN"
#define kAttributeMLBNumber    @"Attribute-MLB"
#define kAttributeDUTIdentity  @"Attribute-DUT"
#define kAttributeBluetoothMAC @"Attribute-BT-MAC"
#define kAttributeWiFiMAC      @"Attribute-WiFi-MAC"
#define kAttributeNANDSize     @"Attribute-NAND-Size"

#define kAttributePartNumber   @"Attribute-MPN"
#define kAttributeRegionCode   @"Attribute-REGN"

@property (copy) NSString *processControlMessage;
@property unsigned*  test_time;
@property (readonly) NSArray  *csv_values;
@property (readonly) NSArray  *pudding_values;
@property (readonly) NSArray  *pudding_results;
@property (readonly) NSArray  *error_messages;
@property (readonly) NSArray  *fail_items;
@property (readonly) NSString *text_acumulator;
@property (readonly) NSString *log_data;
@property unsigned portId;

@property (copy) NSDate *start_date;
@property (copy) NSDate *end_date;

@property (readonly) NSData *uart_log;

@property (readonly) BOOL global_pass;


@end

