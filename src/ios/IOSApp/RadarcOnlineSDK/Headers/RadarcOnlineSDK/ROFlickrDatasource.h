//
//  ROFlickrDatasource.h
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 5/7/14.
//

#import "RORSSDatasource.h"

typedef NS_ENUM(NSInteger, ROFlickrSearchType) {
    ROFlickrSearchTypeUser,
    ROFlickrSearchTypeTag,
    ROFlickrSearchTypeSearch
};

@interface ROFlickrDatasource : RORSSDatasource

@property (nonatomic, strong) NSString *searchString;
@property (nonatomic, assign) ROFlickrSearchType searchType;

- (id)initWithSearchString:(NSString *)searchString atSearchType:(ROFlickrSearchType)searchType;

@end
