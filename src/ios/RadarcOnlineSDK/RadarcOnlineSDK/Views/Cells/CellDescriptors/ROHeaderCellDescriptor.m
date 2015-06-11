//
//  ROLabelCellDescriptor.m
//  ReferenceApp
//
//  Created by Víctor Jordán Rosado on 24/3/15.
//  Copyright (c) 2015 Icinetic S.L. All rights reserved.
//

#import "ROHeaderCellDescriptor.h"
#import "ROCellConstants.h"
#import "ROHeaderTableViewCell.h"
#import "NSString+RO.h"
#import "ROTextStyle.h"
#import "UILabel+RO.h"
#import "ROStyle.h"

@implementation ROHeaderCellDescriptor

- (instancetype)initWithText:(NSString *)text textStyle:(ROTextStyle *)textStyle
{
    self = [super self];
    if (self) {
        self.text = text;
        self.textStyle = textStyle ? : [ROTextStyle style:ROFontSizeStyleSmall
                                                     bold:NO
                                                   italic:NO
                                             textAligment:NSTextAlignmentLeft
                                                textColor:[[[ROStyle sharedInstance] foregroundColor] colorWithAlphaComponent:0.5f]];
    }
    return self;
}

+ (instancetype)text:(NSString *)text textStyle:(ROTextStyle *)textStyle
{
    return [[self alloc] initWithText:text textStyle:textStyle];
}

- (instancetype)initWithText:(NSString *)text
{
    return [self initWithText:text textStyle:nil];
}

+ (instancetype)text:(NSString *)text
{
    return [[self alloc] initWithText:text];
}

- (void)dealloc
{
    [self receiveMemoryWarning];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ROHeaderTableViewCell *cell = [ROHeaderTableViewCell tableView:tableView cellForIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];  // Adding this fixes the issue for iPad
    [self configureCell:cell];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static ROHeaderTableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [tableView dequeueReusableCellWithIdentifier:kHeaderCellReuseIdentifier];
    });
    [self configureCell:sizingCell];
    return [sizingCell requiredRowHeightInTableView:tableView];
}

- (void)receiveMemoryWarning
{

}

- (void)registerInTableView:(UITableView *)tableView
{
    [ROHeaderTableViewCell registerInTableView:tableView];
}

- (void)configureCell:(ROHeaderTableViewCell *)cell
{
    [cell.headerLabel ro_style:self.textStyle];
    cell.headerLabel.text = self.text;
}

- (BOOL)isEmpty
{
    return !(self.text && [[self.text ro_trim] length] != 0);
}

@end
