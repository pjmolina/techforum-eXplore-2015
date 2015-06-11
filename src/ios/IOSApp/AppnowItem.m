//
//  AppnowItem.h
//  EXplore101
//
//  This App has been generated using http://www.radarconline.com , the Bright Enterprise App Builder.
//

#import "AppnowItem.h"
#import "NSDictionary+RO.h"

static NSString *const kName = @"name";

@implementation AppnowItem

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
	self = [super init];
	if (self) {
		[self updateWithDictionary:dictionary];
	}
	return self;
}

- (void)updateWithDictionary:(NSDictionary *)dictionary {
    self.name = [dictionary ro_stringForKey:kName];
}

@end
