//
//  ROTextTableViewCell.h
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 9/3/14.
//
//

#import <UIKit/UIKit.h>
#import "ROLabel.h"
#import "ROAction.h"

/**
 Text table view cell.
 */
@interface ROTextTableViewCell : UITableViewCell

@property (unsafe_unretained, nonatomic) IBOutlet ROLabel *text1Label;

/**
 Register cell in the table view
 @param tableView Table view
 */
+ (void)registerInTableView:(UITableView *)tableView;

/**
 Return cell for index path in the table view
 @param tableView Table view
 @param indexPath Index path
 */
+ (instancetype)tableView:(UITableView *)tableView cellForIndexPath:(NSIndexPath *)indexPath;

/**
 Retrieve cell with the text
 @param text Text to show
 */
- (void)configureCellWithText:(NSString *)text;

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
