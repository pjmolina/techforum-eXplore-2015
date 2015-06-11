//
//  ROTextCellDescriptor.m
//  ReferenceApp
//
//  Created by Víctor Jordán Rosado on 24/3/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import "ROTextCellDescriptor.h"
#import "ROTextTableViewCell.h"
#import "ROCellConstants.h"
#import "UITableViewCell+RO.h"
#import "NSString+RO.h"
#import "ROTextStyle.h"
#import "UILabel+RO.h"
#import "ROStyle.h"
#import "UIImage+RO.h"

@implementation ROTextCellDescriptor

- (instancetype)initWithText:(NSString *)text action:(NSObject<ROAction> *)action textStyle:(ROTextStyle *)textStyle
{
    self = [super self];
    if (self) {
        self.text = text;
        self.action = action;
        self.textStyle = textStyle ? : [ROTextStyle style:ROFontSizeStyleMedium
                                                     bold:NO
                                                   italic:NO
                                             textAligment:NSTextAlignmentLeft
                                                textColor:[[ROStyle sharedInstance] foregroundColor]];
    }
    return self;
}

+ (instancetype)text:(NSString *)text action:(NSObject<ROAction> *)action textStyle:(ROTextStyle *)textStyle
{
    return [[self alloc] initWithText:text action:action textStyle:textStyle];
}

- (instancetype)initWithText:(NSString *)text action:(NSObject<ROAction> *)action
{
    return [self initWithText:text action:action textStyle:nil];
}

+ (instancetype)text:(NSString *)text action:(NSObject<ROAction> *)action
{
    return [[self alloc] initWithText:text action:action textStyle:nil];
}

- (void)dealloc
{
    [self receiveMemoryWarning];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ROTextTableViewCell *cell = [ROTextTableViewCell tableView:tableView cellForIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];  // Adding this fixes the issue for iPad
    [cell ro_configureSelectedView];
    [self configureCell:cell];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.action && [self.action canDoAction]) {
        [self.action doAction];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static ROTextTableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [tableView dequeueReusableCellWithIdentifier:kDetailTextCellReuseIdentifier];
    });
    [self configureCell:sizingCell];
    return [sizingCell requiredRowHeightInTableView:tableView];
}

- (void)receiveMemoryWarning
{
    
}

- (void)registerInTableView:(UITableView *)tableView
{
    [ROTextTableViewCell registerInTableView:tableView];
}

- (void)configureCell:(ROTextTableViewCell *)cell
{
    [cell.text1Label ro_style:self.textStyle];
    cell.text1Label.text = self.text;
    cell.userInteractionEnabled = NO;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.accessoryView = nil;
    if (self.action && [self.action canDoAction]) {
        cell.userInteractionEnabled = YES;
        UIImage *image = [[UIImage ro_imageNamed:@"arrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        if ([self.action actionIcon]) {
            image = [[self.action actionIcon] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        }
        UIImageView *iconImageView = [[UIImageView alloc] initWithImage:image];
        [iconImageView setTintColor:self.textStyle.textColor];
        cell.accessoryView = iconImageView;
    }
}

- (BOOL)isEmpty
{
    return !(self.text && [[self.text ro_trim] length] != 0);
}

@end
