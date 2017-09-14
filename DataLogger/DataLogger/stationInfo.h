
@interface StationInfo: NSObject
{
	@private
	NSString *SWID;
	NSString *SWName;
	NSString *LineName;
	NSString *MachineName;
	NSString *Version;
	NSString *swStation;
	NSString *fixtureName;
	NSDictionary *cbPasswords;

	NSString *VAULT_PATH;
	NSString *QUANTA_PATH;
	NSString *logPath;
	NSString *tsrPath;
	NSString *uidPath;
	NSString *csvPath;
	NSString *requestPath;
	NSString *responsePath;

	/* logging options */
	Boolean logOn;
	Boolean tsrOn;
	Boolean uidOn;
	Boolean csvOn;
	Boolean shopflowOn;
	Boolean puddingOn;
	Boolean uploadBlobs;

/*XXX*/	Boolean checkRoutting;
/*XXX*/	Boolean nandMapping;

/*XXX*/	NSDictionary *raw_data;
}

- (id) initWithDictionary:(NSDictionary*)dict andDictionary:(NSDictionary *)other_dict;

@property (copy) NSString *SWID;
@property (copy) NSString *SWName;
@property (copy) NSString *LineName;
@property (copy) NSString *MachineName;
@property (copy) NSString *Version;
@property (copy) NSString *swStation;
@property (copy) NSString *fixtureName;
@property (copy) NSDictionary *cbPasswords;

@property (copy) NSString *VAULT_PATH;
@property (copy) NSString *QUANTA_PATH;
@property (copy) NSString *logPath;
@property (copy) NSString *tsrPath;
@property (copy) NSString *csvPath;
@property (copy) NSString *uidPath;
@property (copy) NSString *requestPath;
@property (copy) NSString *responsePath;

//@property (readonly) BOOL hidden;
//@property (readonly) BOOL report_to_CSV;
//@property (readonly) BOOL report_to_iPudding;

@property Boolean logOn;
@property Boolean tsrOn;
@property Boolean uidOn;
@property Boolean csvOn;
@property Boolean shopflowOn;
//@property Boolean checkRoutting;
//@property Boolean nandMapping;
@property Boolean puddingOn;
@property Boolean uploadBlobs;


//@property (readonly) NSDictionary *raw_data;


@end

