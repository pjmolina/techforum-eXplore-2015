//
//  ROImageTableViewCell.m
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 9/3/14.
//
//

#import "ROImageTableViewCell.h"
#import "ROCellConstants.h"
#import "NSBundle+RO.h"

@implementation ROImageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (void)registerInTableView:(UITableView *)tableView
{
    [tableView registerNib:[UINib nibWithNibName:kDetailCellImageNibName
                                          bundle:[NSBundle ro_resourcesBundle]]
    forCellReuseIdentifier:kDetailImageCellReuseIdentifier];
}

+ (instancetype)tableView:(UITableView *)tableView cellForIndexPath:(NSIndexPath *)indexPath
{
    ROImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDetailImageCellReuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.userInteractionEnabled = NO;
    return cell;
}

@end
