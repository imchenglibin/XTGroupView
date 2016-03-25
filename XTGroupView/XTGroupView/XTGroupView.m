//
//  XTGroupView.m
//  XTGroupView
//
//  Created by admin on 16/2/20.
//  Copyright © 2016年 xt. All rights reserved.
//

#import "XTGroupView.h"

#define kGroupItemMargin 10
#define kGroupTitleLableHeight 40
#define kGroupItemColorSelected [UIColor colorWithRed:3.0 / 255.0 green:152.0 / 255.0 blue:250.0 / 255 alpha:1.0]
#define kGroupItemColorNormal [UIColor groupTableViewBackgroundColor]
#define kTitleColorNormal [UIColor blackColor]
#define kTitleColorSelected [UIColor whiteColor]

@interface XTGroupItem : NSObject
- (instancetype)initWithButton:(UIButton*)button isSelected:(BOOL)isSelected groupIndex:(NSInteger)groupIndex groupItemIndex:(NSInteger)groupItemIndex;
@property(strong, nonatomic) UIButton *button;
@property(assign, nonatomic) BOOL isSelected;
@property(assign, nonatomic) NSInteger groupIndex;
@property(assign, nonatomic) NSInteger groupItemIndex;
@end

@implementation XTGroupItem
- (instancetype)initWithButton:(UIButton*)button isSelected:(BOOL)isSelected groupIndex:(NSInteger)groupIndex groupItemIndex:(NSInteger)groupItemIndex {
    if (self = [super init]) {
        _button = button;
        _isSelected = isSelected;
        _groupIndex = groupIndex;
        _groupItemIndex = groupItemIndex;
    }
    return self;
}
@end

@interface XTGroup : NSObject
@property(strong, nonatomic) UILabel *titleLabel;
@property(strong, nonatomic, readonly) NSMutableArray<XTGroupItem*> *groupItems;
@property(strong, nonatomic) UIView *underlineView;
@end

@implementation XTGroup

- (instancetype)init {
    if (self = [super init]) {
        _groupItems = [NSMutableArray array];
    }
    return self;
}

@end

@interface XTGroupView()

@property(strong, nonatomic) NSMutableArray<XTGroup*> *groups;

@end

@implementation XTGroupView

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _groupItemBackgroundColorNormal = kGroupItemColorNormal;
    _groupItemBackgroundColorSelected = kGroupItemColorSelected;
    _groupItemTitleColorNormal = kTitleColorNormal;
    _groupItemTitleColorSelected = kTitleColorSelected;
    _groupTitleColor = kTitleColorNormal;
    _groupItemHeight = kGroupTitleLableHeight;
}

- (void)makeGroups {
    if (self.dataSource && !self.groups) {
        self.groups = [NSMutableArray array];
        
        NSInteger numberOfGroups = [self.dataSource numberOfGroups];
        
        for (NSInteger groupIndex=0; groupIndex<numberOfGroups; groupIndex++) {
            XTGroup *group = [[XTGroup alloc] init];
            
            if ([self.dataSource respondsToSelector:@selector(titleOfGroup:)]) {
                NSString *titleOfGroup = [self.dataSource titleOfGroup:groupIndex];
                if (titleOfGroup && ![titleOfGroup isEqualToString:@""]) {
                    UILabel *label = [[UILabel alloc] init];
                    label.font = [UIFont systemFontOfSize:14];
                    label.text = titleOfGroup;
                    label.textAlignment = NSTextAlignmentLeft;
                    label.textColor = self.groupTitleColor;
                    group.titleLabel = label;
                    [self addSubview:label];
                }
            }
            
            NSInteger numberOfGroupItems = [self.dataSource numberOfGroupItems:groupIndex];
            for (NSInteger groupItemIndex=0; groupItemIndex<numberOfGroupItems; groupItemIndex++) {
                NSString *groupItemTitle = [self.dataSource titleOfGroupItem:groupIndex index:groupItemIndex];
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.layer.cornerRadius = 3;
                button.backgroundColor = self.groupItemBackgroundColorNormal;
                [button setTitle:groupItemTitle forState:UIControlStateNormal];
                [button setTitleColor:self.groupItemTitleColorNormal forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont systemFontOfSize:12];
                [button sizeToFit];
                button.frame = CGRectMake(0, 0, button.frame.size.width + kGroupItemMargin, _groupItemHeight);
                [self addSubview:button];
                
                BOOL isSelected = NO;
                if ([self.dataSource respondsToSelector:@selector(isGroupItemSelected:index:)]) {
                    isSelected = [self.dataSource isGroupItemSelected:groupIndex index:groupItemIndex];
                }
                
                if (isSelected) {
                    [button setTitleColor:self.groupItemTitleColorSelected forState:UIControlStateNormal];
                    button.backgroundColor = self.groupItemBackgroundColorSelected;
                }
                
                [group.groupItems addObject:[[XTGroupItem alloc] initWithButton:button isSelected:isSelected groupIndex:groupIndex groupItemIndex:groupItemIndex]];
                button.tag = groupIndex;
                [button addTarget:self action:@selector(selectGroupItem:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            group.underlineView = [[UIView alloc] init];
            group.underlineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [self addSubview:group.underlineView];
            
            [self.groups addObject:group];
        }
    }
}

- (void)selectGroupItem:(UIButton*)sender {
    NSInteger groupIndex = sender.tag;
    
    XTGroup *group = [self.groups objectAtIndex:groupIndex];
    XTGroupItem *currentGroupItem;
    for (XTGroupItem *groupItem in group.groupItems) {
        if (groupItem.button == sender) {
            currentGroupItem = groupItem;
            break;
        }
    }
    
    if (currentGroupItem) {
        BOOL allowMutiSelect = NO;
        if (self.groupViewDelegate && [self.groupViewDelegate conformsToProtocol:@protocol(XTGroupViewDelegate)]) {
            if ([self.groupViewDelegate respondsToSelector:@selector(allowMutiSelect:)]) {
                allowMutiSelect = [self.groupViewDelegate allowMutiSelect:groupIndex];
            }
            if (currentGroupItem.isSelected) {
                if ([self.groupViewDelegate respondsToSelector:@selector(removeSelectGroupItem:index:)]) {
                    [self.groupViewDelegate removeSelectGroupItem:currentGroupItem.groupIndex index:currentGroupItem.groupItemIndex];
                }
            } else {
                if ([self.groupViewDelegate respondsToSelector:@selector(selectGroupItem:index:)]) {
                    [self.groupViewDelegate selectGroupItem:currentGroupItem.groupIndex index:currentGroupItem.groupItemIndex];
                }
            }
        }
        
        if (currentGroupItem.isSelected) {
            [currentGroupItem.button setTitleColor:self.groupItemTitleColorNormal forState:UIControlStateNormal];
            currentGroupItem.button.backgroundColor = self.groupItemBackgroundColorNormal;
            currentGroupItem.isSelected = NO;
        } else {
            [currentGroupItem.button setTitleColor:self.groupItemTitleColorSelected forState:UIControlStateNormal];
            currentGroupItem.isSelected = YES;
            currentGroupItem.button.backgroundColor = self.groupItemBackgroundColorSelected;
        }
        
        if (!allowMutiSelect) {
            for (XTGroupItem *groupItem in group.groupItems) {
                if (groupItem != currentGroupItem) {
                    [groupItem.button setTitleColor:self.groupItemTitleColorNormal forState:UIControlStateNormal];
                    groupItem.button.backgroundColor = self.groupItemBackgroundColorNormal;
                    groupItem.isSelected = NO;
                }
            }
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self makeGroups];
    
    CGFloat top = 0;
    
    for (XTGroup *group in self.groups) {
        if (group.titleLabel) {
            group.titleLabel.frame = CGRectMake(kGroupItemMargin, top, self.bounds.size.width - kGroupItemMargin, kGroupTitleLableHeight);
            top += kGroupTitleLableHeight;
        }
        CGFloat left = kGroupItemMargin;
        for (XTGroupItem *groupItem in group.groupItems) {
            if (left + groupItem.button.frame.size.width + kGroupItemMargin > self.bounds.size.width) {
                left = kGroupItemMargin;
                top += groupItem.button.frame.size.height + kGroupItemMargin;
            }
            
            groupItem.button.frame = CGRectMake(left, top, groupItem.button.frame.size.width, groupItem.button.frame.size.height);
            
            left += groupItem.button.frame.size.width + kGroupItemMargin;
            
            if (groupItem == group.groupItems.lastObject) {
                top += groupItem.button.frame.size.height + kGroupItemMargin;
            }
        }
        
        if (self.separatorLineStyle == XTGroupViewSeparatorLineStyleSingleLine && group != self.groups.lastObject) {
            group.underlineView.frame = CGRectMake(0, top, self.bounds.size.width, 1);
            top += 1;
        } else {
            group.underlineView.frame = CGRectMake(0, top, self.bounds.size.width, 0);
        }
    }
    
    self.contentSize = CGSizeMake(self.bounds.size.width, top);
}

@end
