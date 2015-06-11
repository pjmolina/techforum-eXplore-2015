//
//  AppnowSchema2Item.h
//  EXplore101
//
//  This App has been generated using http://www.radarconline.com , the Bright Enterprise App Builder.
//

#import "AppnowSchema2Item.h"
#import "NSDictionary+RO.h"

static NSString *const kCategory = @"category";
static NSString *const kService = @"service";

@implementation AppnowSchema2Item

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
	self = [super init];
	if (self) {
		[self updateWithDictionary:dictionary];
	}
	return self;
}

- (void)updateWithDictionary:(NSDictionary *)dictionary {
    self.category = [dictionary ro_stringForKey:kCategory];
    self.service = [dictionary ro_stringForKey:kService];
}

@end
