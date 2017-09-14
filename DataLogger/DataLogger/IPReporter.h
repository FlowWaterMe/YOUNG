#import "Reporter.h"


@interface IPReporter: NSObject<Reporter>
{
	/*
	 * global info
	 */
	@private
	StationInfo     *m_station_info;
	NSArray         *m_test_definition;
	NSMutableString *m_CSV_file_name;

	/*
	 * threading
	 */
	NSLock *m_lock;

}

@end
