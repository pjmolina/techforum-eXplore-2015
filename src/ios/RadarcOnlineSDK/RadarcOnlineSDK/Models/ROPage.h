//
//  ROPage.h
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 4/24/14.
//

#import "ROObject.h"
#import "RODatasource.h"

typedef NS_ENUM(NSInteger, ROLayoutType)
{
    /** Web view layout */
    ROLayoutWeb = 0,
    /** Detail view layout */
    ROLayoutDetailVertical,
    /** Custom view layout */
    ROLayoutCustom,
    /** Table view layout with title and description */
    ROLayoutListTitleDescription,
    /** Table view layout with title, description below each other and image on the left */
    ROLayoutListPhotoTitleDescription,
    /** Table view layout title and image on same row and description below */
    ROLayoutListPhotoTitleBottomDescription,
    /** Collection view layout with image */
    ROLayoutAlbum,
    /** Table view layout with title */
    ROLayoutMenuTitle,
    /** Table view layout with title and image on same row */
    ROLayoutMenuIconTitle,
    /** Collection view layout with image and title below each other */
    ROLayoutMenuMosaic,
    /** Chart pie view layout*/
    ROLayoutChartPie,
    /** Chart bars view layout*/
    ROLayoutChartBars,
    /** Chart lines view layout*/
    ROLayoutChartLines
};

/**
 Model to page.
 Contains values ​​needed to set up a view.
 */
@interface ROPage : ROObject

/**
 Page name
 */
@property (nonatomic, strong) NSString *label;

/**
 Layout type
 */
@property (nonatomic, assign) ROLayoutType layoutType;

/**
 Image name for this page
 */
@property (nonatomic, strong) NSString *imageName;

/**
 The controller name for this page
 */
@property (nonatomic, strong) Class controllerClass;

/**
 Datasource
 */
@property (nonatomic, strong) id<RODatasource> ds;

/**
 Constructor with init properties
 @param label Page name
 @param layoutType Layout type
 @param imageName Image name for this page
 @param controllerClass The controller class for this page
 @param datasource Page datasource
 @return Class instance
 */
- (id)initWithLabel:(NSString *)label
       atLayoutType:(ROLayoutType)layoutType
        atImageName:(NSString *)imageName
   atControllerClass:(Class)controllerClass
       atDatasource:(id<RODatasource>)datasource;

/**
 Constructor with init properties
 @param label Page name
 @param layoutType Layout type
 @param controllerClass The controller class for this page
 @param datasource Page datasource
 @return Class instance
 */
- (id)initWithLabel:(NSString *)label
       atLayoutType:(ROLayoutType)layoutType
  atControllerClass:(Class)controllerClass
       atDatasource:(id<RODatasource>)datasource;

/**
 This method retrieve view controller depending on page tye
 @return view controller
 */
- (id)viewController;

@end
