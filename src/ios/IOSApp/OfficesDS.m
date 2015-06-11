//
//  OfficesDS.h
//  EXplore101
//
//  This App has been generated using http://www.radarconline.com , the Bright Enterprise App Builder.
//

#import "OfficesDS.h"
#import "AppnowSchema3Item.h"

@implementation OfficesDS

- (id)init
{
    self = [super initWithUrlString:@"https://www.radarconline.com/api/app/data" 
                          withAppId:@"290923c0-8d19-40c9-b0c6-a0169102556e"
                         withApiKey:@"kLpGwZLnmK4GByu049aCQpZ558vOw5L8Mrwa37PoPy"
                     atDatasourceId:@"364f27d4-8618-4041-925a-7c3da527af22" 
                     atObjectsClass:[AppnowSchema3Item class]];
    if (self) {
        
    }
    return self;
}

@end
