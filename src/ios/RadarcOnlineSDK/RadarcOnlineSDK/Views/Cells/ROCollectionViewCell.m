//
//  ROCollectionViewCell.m
//  RadarcOnlineSDK
//
//  Created by Icinetic S.L. on 4/28/14.
//

#import "ROCollectionViewCell.h"
#import "ROItemCell.h"
#import "ROStyle.h"
#import "Colours.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "UIImageView+RO.h"

@implementation ROCollectionViewCell

- (id)initWithNibNamed:(NSString *)nibName
{
    self = [super init];
    if (self) {
        [self cellInit];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    [self cellInit];
}

- (id)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;
    [self cellInit];
    return self;
}

- (UILabel *)textLabel
{
    if (!_textLabel) {
        UILabel *textTmpLabel = [[UILabel alloc] init];
        textTmpLabel.textAlignment = NSTextAlignmentCenter;
        textTmpLabel.textColor = [UIColor blackColor];
        textTmpLabel.highlightedTextColor = [UIColor whiteColor];
        textTmpLabel.font = [UIFont boldSystemFontOfSize:17];
        _textLabel = textTmpLabel;
        [self.contentView addSubview:_textLabel];
        [self setNeedsLayout];
    }
    return _textLabel;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        UIImageView *tmpImageView = [[UIImageView alloc] init];
        tmpImageView.contentMode = UIViewContentModeCenter;
        _imageView = tmpImageView;
        [self.contentView addSubview:_imageView];
        [self setNeedsLayout];
    }
    return _imageView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if ([[self.contentView subviews] count] == 0) {
        const CGRect bounds = self.bounds;
        
        CGRect contentFrame = CGRectMake(0,0,bounds.size.width,bounds.size.height);
        
        const CGFloat padding = 5;
        const CGFloat imageWidth = contentFrame.size.width - (padding * 2);
        CGFloat imageHeight = contentFrame.size.height - (padding * 2);
        CGFloat labelHeight = 0;
        if (_style == ROCollectionViewCellStylePhotoTitle) {
            const CGFloat labelWidth = imageWidth;
            labelHeight = imageWidth / 3;
            imageHeight = imageHeight - labelHeight;
            _textLabel.frame = CGRectMake(padding, padding + imageHeight, labelWidth, labelHeight);
        }
        _imageView.frame = CGRectMake(padding,padding,imageWidth,imageHeight);
    }
}

- (void)setItem:(id)item
{
    if ([item isKindOfClass:[ROItemCell class]]) {
        _item = item;
    } else {
        _item = [[ROItemCell alloc] initWithText1:[item description]];
    }
    if (_style == ROCollectionViewCellStylePhotoTitle) {
        if (_item.text1 && _item.text1.length != 0) {
            self.textLabel.text = NSLocalizedString(_item.text1, nil);
        }
    }
    UIImage *image = [[ROStyle sharedInstance] noPhotoImage];
    if (_item.imageResource && _item.imageResource.length != 0 && [UIImage imageNamed:_item.imageResource]) {
        image = [UIImage imageNamed:_item.imageResource];
        self.imageView.image = image;        
    } else if (_item.imageUrl) {
        NSURL *url = [NSURL URLWithString:_item.imageUrl];
        UIActivityIndicatorViewStyle indicatorStyle = UIActivityIndicatorViewStyleWhite;
        if (![[ROStyle sharedInstance] useStyleLightForColor:[[ROStyle sharedInstance] backgroundColor]]) {
            indicatorStyle = UIActivityIndicatorViewStyleGray;
        }
        __weak typeof(self) weakCell = self;
        [self.imageView setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (error) {
                [weakCell.imageView setImage:[[ROStyle sharedInstance] noPhotoImage]];
                [weakCell setNeedsLayout];
            }
            [self.imageView ro_updateContentMode];
            
        } usingActivityIndicatorStyle:indicatorStyle];
    } else {
        self.imageView.image = image;
    }
    [self.imageView ro_updateContentMode];
}

- (void)dealloc
{
    _textLabel = nil;
    _imageView = nil;
}

#pragma mark - ROCollectionViewCell

- (void)cellInit
{
    self.contentView.backgroundColor = [[[ROStyle sharedInstance] accentColor] colorWithAlphaComponent:0.1f];
    self.backgroundColor = [UIColor clearColor];
    UIView *selectecedView = [[UIView alloc] init];
    selectecedView.backgroundColor = [[[ROStyle sharedInstance] accentColor] colorWithAlphaComponent:0.2f];
    self.selectedBackgroundView=selectecedView;
    if (self.textLabel) {
        self.textLabel.textColor = [[ROStyle sharedInstance] foregroundColor];
    }
}

- (id)initWithROStyle:(ROCollectionViewCellStyle)style
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _style = style;
        [self cellInit];
    }
    return self;
}

@end
