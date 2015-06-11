//
//  ROYoutubeDatasource.h
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 5/6/14.
//

#import "RORSSDatasource.h"
#import "ROPagination.h"

typedef NS_ENUM(NSInteger, ROYoutubeSearchType) {
    ROYoutubeSearchTypeMostPopular,
    ROYoutubeSearchTypeCategory,
    ROYoutubeSearchTypeUser,
    ROYoutubeSearchTypeTag,
    ROYoutubeSearchTypeSearch
};

@interface ROYoutubeDatasource : RORSSDatasource <ROPagination>

@property (nonatomic, strong) NSString *searchString;
@property (nonatomic, assign) ROYoutubeSearchType searchType;

- (id)initWithSearchString:(NSString *)searchString atSearchType:(ROYoutubeSearchType)searchType;

@end
