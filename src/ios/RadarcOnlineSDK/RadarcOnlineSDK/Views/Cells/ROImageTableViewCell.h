//
//  ROImageTableViewCell.h
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 9/3/14.
//
//

#import <UIKit/UIKit.h>

@interface ROImageTableViewCell : UITableViewCell

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *customImageView;

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

@end
