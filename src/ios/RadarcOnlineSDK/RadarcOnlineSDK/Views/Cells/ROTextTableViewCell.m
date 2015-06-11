//
//  ROTextTableViewCell.m
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 9/3/14.
//
//

#import "ROTextTableViewCell.h"
#import "ROCellConstants.h"
#import "ROStyle.h"
#import "NSString+RO.h"
#import "ROPhoneAction.h"
#import "NSBundle+RO.h"
#import "UIImage+RO.h"

@implementation ROTextTableViewCell

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
    [tableView registerNib:[UINib nibWithNibName:kDetailCellTextNibName
                                          bundle:[NSBundle ro_resourcesBundle]] forCellReuseIdentifier:kDetailTextCellReuseIdentifier];
}

+ (instancetype)tableView:(UITableView *)tableView cellForIndexPath:(NSIndexPath *)indexPath
{
    ROTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDetailTextCellReuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    UIView *selectecedView = [[UIView alloc] init];
    selectecedView.backgroundColor = [[[ROStyle sharedInstance] accentColor] colorWithAlphaComponent:0.1f];
    cell.selectedBackgroundView = selectecedView;
    if (cell.text1Label) {
        cell.text1Label.textColor = [[ROStyle sharedInstance] foregroundColor];
    }
    return cell;
}

- (void)configureCellWithText:(NSString *)text
{
    text = text ?: NSLocalizedString(@"[No text]", nil);
    text = [text ro_replaceHtmlElementsByTag:@"br" withString:@"\n"];
    text = [text stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    [self.text1Label setText:text];
}

- (void)configureCellWithAction:(NSObject<ROAction> *)action
{
    self.userInteractionEnabled = NO;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.accessoryView = nil;
    if (action) {
        if (!([action isKindOfClass:[ROPhoneAction class]] && (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone))) {
            self.userInteractionEnabled = YES;
            UIImage *image = [UIImage ro_imageNamed:@"arrow"];
            if ([action actionIcon]) {
                image = [[action actionIcon] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            }
            UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            [iconImageView setTintColor:[[ROStyle sharedInstance] accentColor]];
            self.accessoryView = iconImageView;
        }
    }
}

- (CGFloat)requiredRowHeightInTableView:(UITableView *)tableView
{
    CGFloat heightDefault = [[[ROStyle sharedInstance] tableViewCellHeightMin] floatValue];
    self.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), 44.0f);
    [self setNeedsLayout];
    [self layoutIfNeeded];
    CGSize size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return MAX(heightDefault, size.height);
}

@end
