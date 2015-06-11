//
//  ROTableViewCell.h
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 4/24/14.
//

#import <UIKit/UIKit.h>
#import "ROCellConstants.h"
#import "ROAction.h"

@class ROItemCell;

/**
 Generic table view cell.
 Allows create and show elements for all layout type compatible with UI table view
 */
@interface ROTableViewCell : UITableViewCell

/**
 Label 1
 */
@property (weak, nonatomic, readwrite) IBOutlet UILabel *text1Label;

/**
 Label 2
 */
@property (weak, nonatomic, readwrite) IBOutlet UILabel *text2Label;

/**
 Image
 */
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;

/**
 Cell model item
 */
@property (nonatomic, strong) ROItemCell *item;

/**
 Cell style
 */
@property (nonatomic, assign) ROTableViewCellStyle style;

/**
 Constructor with style and identifier
 @param style Cell style
 @param style Cell identifier
 @return Class instance
 */
- (id)initWithROStyle:(ROTableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

/*
 Init cell 
 */
- (void)cellInit;

/**
 Configure cell with the action
 @param action Aciton to do
 */
- (void)configureCellWithAction:(NSObject<ROAction> *)action;

/**
 Calcule height for cell in table view
 @param tableView Table view
 */
- (CGFloat)requiredRowHeightInTableView:(UITableView *)tableView;

@end
