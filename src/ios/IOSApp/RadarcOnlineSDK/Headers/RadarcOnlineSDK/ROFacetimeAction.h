//
//  ROFacetimeAction.h
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 11/05/14.
//

#import "ROUriAction.h"
#import "ROAction.h"

/**
 Call by facetime
 */
@interface ROFacetimeAction : ROUriAction<ROAction>

/**
 Facetime identifier
 */
@property (nonatomic, strong) NSString *facetimeId;

/**
 Constructor with facetime identifier
 @param facetimeId Facetime identifier
 @return Class instance
 */
- (id)initWithValue:(NSString *)facetimeId;

@end
