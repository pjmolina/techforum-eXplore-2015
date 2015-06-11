//
//  ROCollectionLocalDatasource.h
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 4/30/14.
//

#import "ROObject.h"
#import "RODatasource.h"
#import "ROPagination.h"

@interface ROCollectionLocalDatasource : ROObject<RODatasource,ROPagination>

@property (nonatomic, assign) Class objectsClass;
@property (nonatomic, strong) NSArray *objects;

- (id)initWithObjectsClass:(Class)objectsClass;

@end
