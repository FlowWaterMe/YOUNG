#import "stationInfo.h"


@implementation StationInfo


- (id) initWithDictionary:(NSDictionary*)dict andDictionary:(NSDictionary *)other_dict
{
	self = [super init];

	if (self) {
		SWName      = [dict objectForKey:@"SWName"];
		LineName    = [dict objectForKey:@"LineName"];
		MachineName = [dict objectForKey:@"MachineName"];
		Version     = [dict objectForKey:@"Version"];
		swStation   = [dict objectForKey:@"StationName"];
		fixtureName = [dict objectForKey:@"Fixture"];
		cbPasswords = [dict objectForKey:@"ControlBitPasswords"];

		self->raw_data = [dict copy];


		NSFileManager *filemanager = [NSFileManager defaultManager];

		VAULT_PATH  = [NSString stringWithString:[other_dict objectForKey:@"VAULT_PATH"]];
		QUANTA_PATH = [NSString stringWithString:[other_dict objectForKey:@"QUANTA_PATH"]];

		logOn = [[other_dict valueForKey:@"LOG"] boolValue];
		if (logOn) {
			logPath = [[NSString alloc] initWithString:[VAULT_PATH stringByAppendingString:@"LOG/"]];
			[filemanager createDirectoryAtPath:logPath withIntermediateDirectories:YES attributes:nil error:nil];
		}

		tsrOn = [[other_dict objectForKey:@"TSR"] boolValue];
		if (tsrOn) {
			tsrPath = [[NSString alloc] initWithString:[VAULT_PATH stringByAppendingString:@"TSR/"]];
			[filemanager createDirectoryAtPath:tsrPath withIntermediateDirectories:YES attributes:nil error:nil];
			[filemanager createDirectoryAtPath:QUANTA_PATH withIntermediateDirectories:YES attributes:nil error:nil];
		}

		uidOn = [[other_dict objectForKey:@"UID"] boolValue];
		if (uidOn) {
			uidPath = [[NSString alloc] initWithString:[@"/vault/pudding/" stringByAppendingString:@"uid/"]];
			[filemanager createDirectoryAtPath:uidPath withIntermediateDirectories:YES attributes:Nil error:Nil];
		}

		csvOn = [[other_dict objectForKey:@"CSV"] boolValue];
		if (csvOn) {
			csvPath = [[NSString alloc] initWithString:[VAULT_PATH stringByAppendingString:@"CSV/"]];
			[filemanager createDirectoryAtPath:csvPath withIntermediateDirectories:YES attributes:nil error:nil];
		}

		shopflowOn = [[other_dict objectForKey:@"ShopFlow"] boolValue];
		if(shopflowOn) {
			requestPath=[[NSString alloc] initWithString:[other_dict objectForKey:@"SF_REQUEST_PATH"]];
			responsePath=[[NSString alloc] initWithString:[other_dict objectForKey:@"SF_RESPONSE_PATH"]];
		}

		puddingOn = [[other_dict objectForKey:@"Pudding"] boolValue];
		uploadBlobs = [[other_dict objectForKey:@"UploadBlobs"] boolValue];

//		checkRoutting = [[theCase objectForKey:@"CheckRoutting"] boolValue];
//		nandMapping = [[theCase objectForKey:@"NandMapping"] boolValue];
//		nandMappingDes = [testSet objectForKey:@"NandMapping"];
	}

	return self;
}


@synthesize SWID;
@synthesize SWName;
@synthesize LineName;
@synthesize MachineName;
@synthesize Version;
@synthesize swStation;
@synthesize fixtureName;
@synthesize cbPasswords;

@synthesize VAULT_PATH;
@synthesize QUANTA_PATH;
@synthesize logPath;
@synthesize tsrPath;
@synthesize uidPath;
@synthesize csvPath;
@synthesize requestPath;
@synthesize responsePath;

@synthesize logOn;
@synthesize tsrOn;
@synthesize uidOn;
@synthesize csvOn;
@synthesize shopflowOn;
@synthesize puddingOn;
@synthesize uploadBlobs;

//@synthesize judge_string;
//@synthesize attribute_string;
//
//
//@dynamic report_to_CSV;
//-(BOOL) hidden
//{
//	if ([self->attribute_string rangeOfString:@"/Hided"].location != NSNotFound) {
//		/* Quanta like spelling it like this */
//		return true;
//	}
//	if ([self->attribute_string rangeOfString:@"/Hidden"].location != NSNotFound) {
//		return true;
//	}
//
//	return false;
//}
//
//@dynamic report_to_CSV;
//-(BOOL) report_to_CSV
//{
//	return [self->attribute_string rangeOfString:@"/CSV"].location != NSNotFound;
//}
//
//@dynamic report_to_iPudding;
//-(BOOL) report_to_iPudding
//{
//	return [self->attribute_string rangeOfString:@"/Pudding"].location != NSNotFound;
//}
//
//@dynamic raw_data;
//-(NSDictionary *) raw_data
//{
//	return raw_data;
//}

@end
