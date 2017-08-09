#import "KeyItem.h"

@implementation KeyItem
@synthesize name;
- (id)init
{
    self = [super init];
    if (self) {
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}


- (id)initWithName:(NSString *)aName {
    self = [self init];
    self.name = aName;
    return self;
}

+ (KeyItem *)nodeDataWithName:(NSString *)name {
    return [[[KeyItem alloc] initWithName:name] autorelease];
}
@end

