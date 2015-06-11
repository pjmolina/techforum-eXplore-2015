//
//  SolutionsDS.h
//  EXplore101
//
//  This App has been generated using http://www.radarconline.com , the Bright Enterprise App Builder.
//

#import "SolutionsDS.h"
#import "AppnowSchema2Item.h"

@implementation SolutionsDS

- (id)init
{
    self = [super initWithUrlString:@"https://www.radarconline.com/api/app/data" 
                          withAppId:@"290923c0-8d19-40c9-b0c6-a0169102556e"
                         withApiKey:@"kLpGwZLnmK4GByu049aCQpZ558vOw5L8Mrwa37PoPy"
                     atDatasourceId:@"a2cf4995-73dc-4bb7-8d9c-af017d125e42" 
                     atObjectsClass:[AppnowSchema2Item class]];
    if (self) {
        
    }
    return self;
}

@end
