//
//  ROViewController.h
//  AppWorks
//
//  Created by Icinetic S.L. on 4/24/14.
//

#import <UIKit/UIKit.h>
#import "RODataLoader.h"

@class ROPage;
@class ROError;

@protocol RODataDelegate <NSObject>

/**
 Data loader
 @return dataLoader
 */
- (NSObject<RODataLoader> *)dataLoader;

/**
 Load data
 */
- (void)loadData;

/**
 Load data success
 @param dataObject
 */
- (void)loadDataSuccess:(id)dataObject;

/**
 Load data error
 */
- (void)loadDataError:(ROError *)error;

@end

/**
 Generic ui view controller
 */
@interface ROViewController : UIViewController

/**
 Page setup
 */
@property (nonatomic, strong) ROPage *page;

/**
 Entry page.
 @return Entry page
 */
+ (ROPage *)entryPage;

/**
 Constructor with a page
 @param page Page setup
 @return Class instance
 */
- (id)initWithPage:(ROPage *)page;

/**
 Further setup after viewDidLoad is done
 */
- (void)configureView;

/**
 Data loader
 */
@property (nonatomic, strong) NSObject<RODataLoader> *dataLoader;

/**
 All behaviors
 */
@property (nonatomic, strong) NSMutableArray *behaviors;

@end
