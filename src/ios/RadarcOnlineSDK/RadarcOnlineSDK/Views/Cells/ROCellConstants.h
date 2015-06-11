//
//  ROCellConstants.h
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 9/11/14.
//
//

#ifndef Pods_ROCellConstants_h
#define Pods_ROCellConstants_h

static NSString *const kCollectionCellPhotoReuseIdentifier          	= @"ROCollectionViewCellPhoto";
static NSString *const kCollectionCellPhotoTitleReuseIdentifier     	= @"ROCollectionViewCellPhotoTitle";
static NSString *const kCollectionCellPhotoNibName                  	= @"ROCollectionViewCellStylePhoto";
static NSString *const kCollectionCellPhotoTitleNibName           		= @"ROCollectionViewCellStylePhotoTitle";


static NSString *const kDetailImageCellReuseIdentifier              	= @"ROTableViewCellDetailImage";
static NSString *const kDetailCellImageNibName                      	= @"ROTableViewCellStyleDetailImage";

static NSString *const kHeaderCellReuseIdentifier                       = @"ROHeaderTableViewCell";
static NSString *const kHeaderCellNibName                               = @"ROHeaderTableViewCell";

static NSString *const kDetailTextCellReuseIdentifier               	= @"ROTableViewCellDetailText";
static NSString *const kDetailCellTextNibName                       	= @"ROTableViewCellStyleDetailText";

static NSString *const kTableCellTReuseIdentifier          				= @"ROTableViewCellTitle";
static NSString *const kTableCellPTReuseIdentifier          			= @"ROTableViewCellPhotoTitle";
static NSString *const kTableCellTDReuseIdentifier    					= @"ROTableViewCellTitleDescription";
static NSString *const kTableCellPTDReuseIdentifier						= @"ROTableViewCellPhotoTitleDescription";
static NSString *const kTableCellPTBDReuseIdentifier					= @"ROTableViewCellPhotoTitleBottomDescription";
static NSString *const kTableCellTNibName		                       	= @"ROTableViewCellStyleTitle";
static NSString *const kTableCellPTNibName		                       	= @"ROTableViewCellStylePhotoTitle";
static NSString *const kTableCellTDNibName		                       	= @"ROTableViewCellStyleTitleDescription";
static NSString *const kTableCellPTDNibName		                       	= @"ROTableViewCellStylePhotoTitleDescription";
static NSString *const kTableCellPTBDNibName		                  	= @"ROTableViewCellStylePhotoTitleBottomDescription";

/**
 Table view cell style options
 */
typedef NS_ENUM(NSInteger, ROTableViewCellStyle)
{
    /** Cell with title */
    ROTableViewCellStyleTitle = 111,
    /** Cell with title and image on same row */
    ROTableViewCellStylePhotoTitle,
    /** Cell with title and description below each other */
    ROTableViewCellStyleTitleDescription,
    /** Cell with title, description  below each other and image on the left */
    ROTableViewCellStylePhotoTitleDescription,
    /** Cell with title and image on same row and description below */
    ROTableViewCellStylePhotoTitleBottomDescription,
    /** Cell with text */
    ROTableViewCellStyleDetailText,
    /** Cell with image */
    ROTableViewCellStyleDetailImage,
    /** Cell with header text */
    ROTableViewCellStyleHeaderText
};


#endif
