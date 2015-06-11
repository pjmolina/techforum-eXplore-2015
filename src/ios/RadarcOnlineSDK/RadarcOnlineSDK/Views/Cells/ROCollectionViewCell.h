//
//  ROCollectionViewCell.h
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 4/28/14.
//

#import <UIKit/UIKit.h>

typedef void (^ROCollectionViewCellImageBlock)(UIImage *image);

@class ROItemCell;

/**
 Cell style options
 */
typedef NS_ENUM(NSInteger, ROCollectionViewCellStyle)
{
    /** Cell with image and title below each other */
    ROCollectionViewCellStylePhotoTitle = 222,
    /** Cell with image */
    ROCollectionViewCellStylePhoto
};

@interface ROCollectionViewCell : UICollectionViewCell

/**
 Image view
 */
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

/**
 Text label
 */
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

/**
 Cell model item
 */
@property (nonatomic, strong) ROItemCell *item;

/**
 Cell style
 */
@property (nonatomic, assign) ROCollectionViewCellStyle style;

/**
 Constructor with style and identifier
 @param style Cell style
 @return Class instance
 */
- (id)initWithROStyle:(ROCollectionViewCellStyle)style;

/*
 Init cell
 */
- (void)cellInit;

@end
