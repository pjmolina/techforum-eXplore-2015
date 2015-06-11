//
//  ROTableViewCell.m
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 4/24/14.
//

#import "ROTableViewCell.h"
#import "ROItemCell.h"
#import "ROStyle.h"
#import "ROPhoneAction.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "NSString+RO.h"
#import "UIImage+RO.h"
#import "UIImageView+RO.h"

@interface ROTableViewCell ()

@end

@implementation ROTableViewCell

- (id)initWithNibNamed:(NSString *)nibName
{
    self = [super init];
    if (self) {
        /*
         NSBundle *mainBundle = [NSBundle mainBundle];
         NSArray *views = [mainBundle loadNibNamed:nibName
         owner:self
         options:nil];
         [self addSubview:views[0]];
         */
        [self cellInit];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self cellInit];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    [self cellInit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)dealloc
{
    _text1Label = nil;
    _text2Label = nil;
    _imageView1 = nil;
}

#pragma mark - ROTableViewCell

- (void)cellInit
{
    self.backgroundColor = [UIColor clearColor];
    UIView *selectecedView = [[UIView alloc] init];
    selectecedView.backgroundColor = [[[ROStyle sharedInstance] accentColor] colorWithAlphaComponent:0.1f];
    self.selectedBackgroundView=selectecedView;
    if (self.text1Label) {
        self.text1Label.textColor = [[ROStyle sharedInstance] foregroundColor];
    }
    if (self.text2Label) {
        self.text2Label.textColor = [[[ROStyle sharedInstance] foregroundColor] colorWithAlphaComponent:0.6f];
    }
}

- (id)initWithROStyle:(ROTableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    UITableViewCellStyle cellStyle = UITableViewCellStyleDefault;
    switch (style) {
        case ROTableViewCellStyleDetailText:
        case ROTableViewCellStyleDetailImage:
            break;
        case ROTableViewCellStylePhotoTitleBottomDescription:
        case ROTableViewCellStylePhotoTitleDescription:
        case ROTableViewCellStyleTitleDescription:
            cellStyle = UITableViewCellStyleSubtitle;
            break;
        default:
            break;
    }
    self = [super initWithStyle:cellStyle reuseIdentifier:reuseIdentifier];
    if (self) {
        _style = style;
    }
    return self;
}

- (void)setItem:(id)item
{
    if ([item isKindOfClass:[ROItemCell class]]) {
        _item = item;
    } else {
        _item = [[ROItemCell alloc] initWithText1:[item description]];
    }
    [self configureCellWithAction:_item.action];
    NSString *text1 = [[_item.text1 description] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    NSString *text2 = [[_item.text2 description] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    switch (_style) {
        case ROTableViewCellStyleDetailText: {
            self.text1Label.text = text1;
            break;
        }
        case ROTableViewCellStyleTitleDescription:
            self.text2Label.text = text2;
        case ROTableViewCellStyleTitle: {
            self.text1Label.text = text1;
            break;
        }
        case ROTableViewCellStylePhotoTitleDescription:
        case ROTableViewCellStylePhotoTitleBottomDescription:
            self.text2Label.text = text2;
        case ROTableViewCellStylePhotoTitle:
            self.text1Label.text = text1;
        case ROTableViewCellStyleDetailImage: {
            UIImage *image = [[ROStyle sharedInstance] noPhotoImage];
            if (_item.imageResource && _item.imageResource.length != 0 && [UIImage imageNamed:_item.imageResource]) {
                image = [UIImage imageNamed:_item.imageResource];
                self.imageView1.image = image;
            } else if (_item.imageUrl) {
                NSURL *url = [NSURL URLWithString:_item.imageUrl];
                UIActivityIndicatorViewStyle indicatorStyle = UIActivityIndicatorViewStyleWhite;
                if (![[ROStyle sharedInstance] useStyleLightForColor:[[ROStyle sharedInstance] backgroundColor]]) {
                    indicatorStyle = UIActivityIndicatorViewStyleGray;
                }
                __weak typeof(self) weakCell = self;
                [self.imageView1 setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

                    if (error) {
                        [weakCell.imageView1 setImage:[[ROStyle sharedInstance] noPhotoImage]];
                        [weakCell setNeedsLayout];
                    }
                    [self.imageView1 ro_updateContentMode];
                    
                } usingActivityIndicatorStyle:indicatorStyle];

            } else {
                self.imageView1.image = image;            
            }
            [self.imageView1 ro_updateContentMode];
            break;
        }
        default:
            break;
    }
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
    CGFloat height = 0.0f;
    CGFloat heightMin = [[[ROStyle sharedInstance] tableViewCellHeightMin] floatValue];
    CGFloat accessoryViewWidth = 88.0f;
    switch (_style) {
        case ROTableViewCellStylePhotoTitle:
            height = 60.0f;
            break;
        case ROTableViewCellStylePhotoTitleBottomDescription:
            height = 64.0f;
            if (_item.text2) {
                CGFloat heightLabel = ceil([_item.text2 ro_heightByFont:[[ROStyle sharedInstance] font] atWidth:tableView.bounds.size.width - accessoryViewWidth]);
                if (heightLabel > 64.0f) {
                    heightLabel = 64.0f;
                }
                height += heightLabel;
            }
            break;
        case ROTableViewCellStylePhotoTitleDescription:
            height = 104.0f;
            break;
        case ROTableViewCellStyleTitle:
            height = 44.0f;
            break;
        case ROTableViewCellStyleTitleDescription:
            height = 88.0f;
            CGFloat text1LabelHeight = 0;
            CGFloat text2LabelHeight = 0;
            if (_item.text1) {
                text1LabelHeight = ceil([_item.text1 ro_heightByFont:self.text1Label.font atWidth:tableView.bounds.size.width - accessoryViewWidth]);
                if (text1LabelHeight > 36.0f) {
                    text1LabelHeight = 36.0f;
                }
            }
            if (_item.text2) {
                text2LabelHeight = ceil([_item.text2 ro_heightByFont:[[ROStyle sharedInstance] font] atWidth:tableView.bounds.size.width - accessoryViewWidth]);
                if (text2LabelHeight > 36.0f) {
                    text2LabelHeight = 36.0f;
                }
            }
            if (text1LabelHeight + text2LabelHeight + 22.0f < height) { // 22.0 = margins
                height = text1LabelHeight + text2LabelHeight + 22.0f;
            }
            break;
        default:
            height = heightMin;
            break;
    }
    return MAX(heightMin, height);
}

@end
