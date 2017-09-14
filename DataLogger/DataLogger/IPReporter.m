#import <Cocoa/Cocoa.h>
#import "InstantPudding_API.h"
//#import "fileNameUtils.h"
#import "IPReporter.h"
#include <math.h>

static void handleReply(IP_API_Reply reply)
{
	if (!IP_success(reply)) {
		NSRunAlertPanel(@"URGENT!!! There was a Fatal Error in IP; Contact station DRI",
						[NSString stringWithFormat:@"%s\nContact Station DRI immediately.", IP_reply_getError(reply)], 
						@"EXIT",
						@"EXIT",
						nil);
		IP_reply_destroy(reply);
		return;
	}

	IP_reply_destroy(reply);
}

static
int
is_numeric_value(char const *s)
{
	int retVal = 0;
	while (*s) {
		if (!isdigit(*s)) {
			retVal = 0;
			break;
		}
		
		retVal++;
		s++;
	}
	
	return retVal;
}

@implementation IPReporter

-(void) generateReport:(TestReport *)test_results;
{
	[m_lock lock];

	NSArray *cPuddingValues  = test_results.pudding_values;
	NSArray *cPuddingResults = test_results.pudding_results;
	NSArray *cfailItems      = test_results.fail_items;
	NSArray *cErrorMessages  = test_results.error_messages;

	
	NSString *MLB       = [test_results attributeForKey:kAttributeMLBNumber];
	/*
	NSString *thebtAdd  = [test_results attributeForKey:kAttributeBluetoothMAC];
	NSString *themacAdd = [test_results attributeForKey:kAttributeWiFiMAC];
	NSString *theMPN    = [test_results attributeForKey:kAttributePartNumber];
	NSString *theRegion = [test_results attributeForKey:kAttributeRegionCode];
	*/
	 
	IP_UUTHandle UID;
	Boolean APIcheck;
	IP_TestSpecHandle testSpec;

	IP_API_Reply reply = IP_UUTStart(&UID);
	if (!IP_success(reply)) {
		NSRunAlertPanel(@"URGENT!!!", [NSString stringWithFormat:@"Recieved Error on IP start: %s\nContact station DRI immediately" ,IP_reply_getError(reply)], @"EXIT", nil, nil);
		IP_UUTCancel(UID);
		IP_reply_destroy(reply);
		[m_lock unlock];
		return;
	}
	IP_reply_destroy(reply);

	//A bad serial number should not necessarily throw a fatal error according to: http://hwte.apple.com/groups/process_npi/wiki/964b5/IP_validateSerialNumber.html
	//(In some cases it will be, but this will be defined in the parachute file according to: http://hwte.apple.com/groups/process_npi/wiki/418b6/attachments/f44f0/Pudding%20&%20Instant%20Pudding.pdf @ page 5 )
	//However, the rest of the IP writing cannot proceed if we don't have a good serial number, so we should cancel the writing? correct?
	//Discuss with Manuel/Nabil/someone who knows more about what is going on with IP
	//Hardcoded fail conditions that aren't controlled by some config file make me nervous, so I won't call cancel for now
	const char* serialNumber = [MLB UTF8String];
	reply = IP_validateSerialNumber(UID, serialNumber);
	if(!IP_success(reply))
	{
		NSLog(@"Non-Fatal Error returned from IP_validateSerialNumber for SN %s. We will cancel the test", serialNumber);
		IP_UUTCancel(UID);
		IP_reply_destroy(reply);
		[m_lock unlock];
		return;
	}
	IP_reply_destroy(reply);

//Add by Ryan
//Station Attribute.
	handleReply(IP_addAttribute(UID, IP_ATTRIBUTE_STATIONSOFTWAREVERSION, [m_station_info.Version UTF8String]));
	handleReply(IP_addAttribute(UID, IP_ATTRIBUTE_STATIONSOFTWARENAME,    [m_station_info.SWName  UTF8String]));
	handleReply(IP_addAttribute(UID, IP_ATTRIBUTE_STATIONLIMITSVERSION,   [m_station_info.Version UTF8String]));
	handleReply(IP_addAttribute(UID, IP_ATTRIBUTE_SERIALNUMBER,           [MLB     UTF8String]));

    //Check SN
	reply = IP_amIOkay(UID, serialNumber);
	if(!IP_success(reply))
	{
		NSLog(@"Fatal Error returned from IP_amIOkay for SN %s. We will cancel the test", serialNumber);
		NSRunAlertPanel([NSString stringWithFormat:@"There was a problem with IP_amIOkay"], [NSString stringWithUTF8String:IP_reply_getError(reply)], @"CANCEL TEST", nil, nil);
		IP_UUTDone(UID);
		IP_UUTCommit(UID, IP_FAIL);
		IP_reply_destroy(reply);
		IP_UID_destroy(UID);
		[m_lock unlock];
		return;
	}
	
    //pudding fail items?
	for (TestItem* item in test_results.fail_items)
	{
		if([item.command_string isEqualToString:@"INITIAL_PROCESS_CONTROL"])
		{
			NSLog(@"We failed Initial process control. We will cancel Instant Pudding call. Check Log for more details");
			NSRunAlertPanel([NSString stringWithFormat:@"We failed Initial process control"], [NSString stringWithFormat:@"%@\nCheck Log for more details.", test_results.processControlMessage], @"CANCEL TEST", nil, nil);
			//[test_results.processControlMessage release];
			//test_results.processControlMessage = nil;
			IP_UUTDone(UID);
			IP_UUTCommit(UID, IP_FAIL);
			IP_reply_destroy(reply);
			IP_UID_destroy(UID);
			[m_lock unlock];
			return;
		}
	}

    //Pudding test time.
	handleReply(IP_setStartTime(UID, [test_results.start_date timeIntervalSince1970]));
	handleReply(IP_setStopTime (UID, [test_results.end_date   timeIntervalSince1970]));

    //blobs
	if (m_station_info.uploadBlobs || ([cfailItems count] > 0)) {
		NSString *blob_name_1 = [NSString stringWithFormat: @"%@-%@", m_station_info.SWName, m_station_info.Version];
		NSString *blob_name_2 = [NSString stringWithFormat: @"%@-%@-UART", m_station_info.SWName, m_station_info.Version];
		IP_API_Reply tR1 = IP_addBlob(UID, [blob_name_1 UTF8String], [logFileName(m_station_info, test_results) UTF8String]);
		IP_API_Reply tR2 = IP_addBlob(UID, [blob_name_2 UTF8String], [uartLogFileName(m_station_info, test_results) UTF8String]);

		if (!IP_success(tR1) || !IP_success(tR2)) {
			NSRunAlertPanel(@"Confirm", @"upLoad Log Fail!", @"YES", nil, nil);
		}
		IP_reply_destroy(tR1);
		IP_reply_destroy(tR2);
	}
	
	char const *NA = "N/A";
	/*
	 Add the atuff from Ayewin's binning stuff
	 "binnedCPULow"
	 "binnedCPUHigh"
	 "binnedSOCHigh"
	 "binnedSOCLow"
	 "margin"
	 
	 I am working completely around the stuff that is already in place, as touching the
	 stuff that has come before will almost always break everything
	 */
	{
		//Hack: need to establish a parametric key type
		NSArray* parametricKeys = [test_results parameterKeys];
		for(NSString* key in parametricKeys)
		{
			testSpec = IP_testSpec_create();
			APIcheck = IP_testSpec_setTestName(testSpec, [key UTF8String], [key length]);
			IP_testSpec_setLimits(testSpec, NA, strlen(NA),  NA, strlen(NA));
			APIcheck = IP_testSpec_setUnits(testSpec, NA, strlen(NA));
			APIcheck = IP_testSpec_setPriority(testSpec, IP_PRIORITY_REALTIME);
			
			IP_TestResultHandle puddingResult = IP_testResult_create();
			
			const char* value = [[test_results parameterForKey:key] UTF8String];
			APIcheck = IP_testResult_setValue(puddingResult, value, strlen(value));
			APIcheck = IP_testResult_setResult(puddingResult, IP_PASS);
			
			handleReply(IP_addResult(UID, testSpec, puddingResult));
			
			IP_testResult_destroy(puddingResult);
			IP_testSpec_destroy(testSpec);
		}
	}
	
/*
	if (![thebtAdd isEqualToString:@"N/A"]) {
		handleReply(IP_addAttribute(UID, IP_ATTRIBUTE_MACADDRESS_BT, [thebtAdd UTF8String]));
	}
	if (![themacAdd isEqualToString:@"N/A"]) {
		handleReply(IP_addAttribute(UID, IP_ATTRIBUTE_MACADDRESS_WIFI, [themacAdd UTF8String]));
	}
	if (![theMPN isEqualToString:@"N/A"]) {
		handleReply(IP_addAttribute(UID, IP_ATTRIBUTE_MPN, [theMPN UTF8String]));
	}
	if (![theRegion isEqualToString:@"N/A"]) {
		handleReply(IP_addAttribute(UID, IP_ATTRIBUTE_REGION_CODE, [theRegion UTF8String]));
	}
*/
	
	/* add station port info */
	char const *KStation_port = "STATION_PORT";

	unsigned thisPort = test_results.portId; /* XXX : mpetit : hack */
	NSString *portInfo = [NSString stringWithFormat:@"%d", thisPort+1];

	testSpec = IP_testSpec_create();
	APIcheck = IP_testSpec_setTestName(testSpec, KStation_port, strlen(KStation_port));
	APIcheck = IP_testSpec_setLimits(testSpec, NA, strlen(NA),  NA, strlen(NA));
	APIcheck = IP_testSpec_setUnits(testSpec, NA, strlen(NA));
	APIcheck = IP_testSpec_setPriority(testSpec, IP_PRIORITY_REALTIME);

	IP_TestResultHandle puddingResult = IP_testResult_create();

	APIcheck = IP_testResult_setValue(puddingResult, [portInfo UTF8String], [portInfo length]);
	APIcheck = IP_testResult_setResult(puddingResult, IP_PASS);

	handleReply(IP_addResult(UID, testSpec, puddingResult));

	IP_testResult_destroy(puddingResult);
	IP_testSpec_destroy(testSpec);


	/* iterate over all results */
	unsigned ipcounter = 0;
	for (unsigned i= 0; i< [m_test_definition count]; i++) {

		TestItem *curr_test = [m_test_definition objectAtIndex:i];

		if (curr_test.report_to_iPudding) {
			NSString *Title   = curr_test.test_name;
			NSString *subTest = [curr_test.raw_data objectForKey:@"SUBNAME"];

			testSpec = IP_testSpec_create();
			APIcheck = IP_testSpec_setTestName(testSpec, [Title UTF8String], [Title length]);

			if (subTest) {
				APIcheck = IP_testSpec_setSubTestName(testSpec, [subTest UTF8String], [subTest length]);
			}


			NSString *theUpperLimit      = [curr_test.raw_data objectForKey:@"UpperLimit"];
			NSString *theLowerLimit      = [curr_test.raw_data objectForKey:@"LowerLimit"];
			NSString *theMeasurementUnit = [curr_test.raw_data objectForKey:@"MeasurementUnit"];

			if (theUpperLimit == nil) {
				theUpperLimit = @"N/A";
			}
			if (theLowerLimit == nil) {
				theLowerLimit = @"N/A";
			}
			if (theMeasurementUnit == nil) {
				theMeasurementUnit=@"N/A";
			}

			APIcheck = IP_testSpec_setLimits(testSpec, [theLowerLimit UTF8String], [theLowerLimit length], [theUpperLimit UTF8String], [theUpperLimit length]);
			APIcheck = IP_testSpec_setUnits(testSpec, [theMeasurementUnit UTF8String], [theMeasurementUnit length]);
			APIcheck = IP_testSpec_setPriority(testSpec, IP_PRIORITY_REALTIME);


			NSLog(@"114 this is what test time was after %d", test_results.test_time[i]);
			NSString *valueStr  = [NSString stringWithFormat:@"%d", test_results.test_time[i]];
			NSLog(@"test time for test %@\n was %@ seconds", Title, valueStr);
			NSString *resultStr = [cPuddingResults objectAtIndex:ipcounter];
			int       result    = [resultStr isEqualToString:@"PASS"] ? IP_PASS : IP_FAIL;

			if (!is_numeric_value([valueStr UTF8String])) {
				valueStr = (result == IP_PASS) ? @"1" : @"0";
			}

			IP_TestResultHandle puddingResult = IP_testResult_create();

			APIcheck = IP_testResult_setValue (puddingResult, [valueStr UTF8String], [valueStr length]);
			APIcheck = IP_testResult_setResult(puddingResult, result);

			if (result == IP_FAIL) {
				NSString *failDes = [cErrorMessages objectAtIndex:ipcounter];
				APIcheck = IP_testResult_setMessage(puddingResult, [failDes cStringUsingEncoding:1], [failDes length]);
			}

			reply = IP_addResult(UID, testSpec, puddingResult);

			if (!IP_success(reply)) {
				NSRunAlertPanel(@"Confirm", [NSString stringWithCString:IP_reply_getError(reply) encoding:1], @"YES", nil,nil);
			}
			IP_reply_destroy(reply);

			IP_testResult_destroy(puddingResult);
			IP_testSpec_destroy(testSpec);

			ipcounter += 1;
		}
	}

	IP_API_Reply doneReply = IP_UUTDone(UID);
	if (!IP_success(doneReply))
	{
		if(IP_reply_isOfClass(doneReply, IP_MSG_CLASS_PROCESS_CONTROL)){
			NSString * oStrMessage = [NSString stringWithCString:IP_reply_getError(doneReply) encoding:1];
			
			NSRunAlertPanel(@"Confirm",[oStrMessage stringByAppendingString:@"\n AMIOK error reported in PDCA for only ONE unit.\n Call DRI and retest ALL units next time."], @"YES", nil,nil);
			IP_reply_destroy(doneReply);
			
			IP_API_Reply commitReply;
			commitReply = IP_UUTCommit(UID, ([cfailItems count] > 0) ? IP_FAIL : IP_PASS);
			IP_reply_destroy(commitReply);

			IP_UID_destroy(UID);
			[m_lock unlock];
			return;
		}
	}
	IP_reply_destroy(doneReply);

	handleReply(IP_UUTCommit(UID, ([cfailItems count] > 0) ? IP_FAIL : IP_PASS));

	IP_UID_destroy(UID);

	[m_lock unlock];
}


-(id) initWithStationInfo:(StationInfo *)station_info andTestDefinition:(NSArray *)test_definition
{
	self = [super init];

	if (self) {
		m_station_info    = [station_info retain];
		m_test_definition = [test_definition retain];
		m_lock            = [NSLock new];
	}

	return self;
}


@end
