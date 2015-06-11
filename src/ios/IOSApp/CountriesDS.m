//
//  CountriesDS.h
//  EXplore101
//
//  This App has been generated using http://www.radarconline.com , the Bright Enterprise App Builder.
//

#import "CountriesDS.h"
#import "AppnowItem.h"

@implementation CountriesDS

- (id)init
{
    self = [super initWithUrlString:@"https://www.radarconline.com/api/app/data" 
                          withAppId:@"290923c0-8d19-40c9-b0c6-a0169102556e"
                         withApiKey:@"kLpGwZLnmK4GByu049aCQpZ558vOw5L8Mrwa37PoPy"
                     atDatasourceId:@"dc9d64ab-614b-444a-9374-bfb0b14892d4" 
                     atObjectsClass:[AppnowItem class]];
    if (self) {
        
    }
    return self;
}

@end
