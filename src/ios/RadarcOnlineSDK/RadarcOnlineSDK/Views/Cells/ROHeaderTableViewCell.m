//
//  ROHeaderTableViewCell.m
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 9/10/14.
//
//

#import "ROHeaderTableViewCell.h"
#import "ROStyle.h"
#import "NSString+RO.h"
#import "ROCellConstants.h"
#import "NSBundle+RO.h"

@implementation ROHeaderTableViewCell

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
    [tableView registerNib:[UINib nibWithNibName:kHeaderCellNibName
                                          bundle:[NSBundle ro_resourcesBundle]] forCellReuseIdentifier:kHeaderCellReuseIdentifier];
}

+ (instancetype)tableView:(UITableView *)tableView cellForIndexPath:(NSIndexPath *)indexPath
{
    ROHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHeaderCellReuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.userInteractionEnabled = NO;
    cell.headerLabel.textColor = [[[ROStyle sharedInstance] foregroundColor] colorWithAlphaComponent:0.4f];
    return cell;
}

- (void)configureCellWithHeaderText:(NSString *)headerText
{
    NSString *text = headerText ?: NSLocalizedString(@"[No text]", nil);
    text = [text stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    [self.headerLabel setText:[text uppercaseString]];
}

- (CGFloat)requiredRowHeightInTableView:(UITableView *)tableView
{
    CGFloat heightDefault = 30.0f;
    self.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), 44.0f);
    [self setNeedsLayout];
    [self layoutIfNeeded];
    CGSize size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return MAX(heightDefault, size.height);
}

@end
