//
//  ROHeaderTableViewCell.h
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 9/10/14.
//
//

#import <UIKit/UIKit.h>
#import "ROLabel.h"

/**
 Header table view cell.
 */
@interface ROHeaderTableViewCell : UITableViewCell

@property (unsafe_unretained, nonatomic) IBOutlet ROLabel *headerLabel;

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
 @param headerText Text to show
 */
- (void)configureCellWithHeaderText:(NSString *)headerText;


/**
 Calcule height for cell in table view
 @param tableView Table view 
 */
- (CGFloat)requiredRowHeightInTableView:(UITableView *)tableView;

@end
