//
//  AppnowSchema3Item.h
//  EXplore101
//
//  This App has been generated using http://www.radarconline.com , the Bright Enterprise App Builder.
//

#import "AppnowSchema3Item.h"
#import "NSDictionary+RO.h"

static NSString *const kName = @"name";
static NSString *const kCountry = @"country";
static NSString *const kCity = @"city";
static NSString *const kAddress = @"address";
static NSString *const kPhone = @"phone";
static NSString *const kImageUrl = @"imageUrl";

@implementation AppnowSchema3Item

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
	self = [super init];
	if (self) {
		[self updateWithDictionary:dictionary];
	}
	return self;
}

- (void)updateWithDictionary:(NSDictionary *)dictionary {
    self.name = [dictionary ro_stringForKey:kName];
    self.country = [dictionary ro_stringForKey:kCountry];
    self.city = [dictionary ro_stringForKey:kCity];
    self.address = [dictionary ro_stringForKey:kAddress];
    self.phone = [dictionary ro_stringForKey:kPhone];
    self.imageUrl = [dictionary ro_stringForKey:kImageUrl];
}

@end
