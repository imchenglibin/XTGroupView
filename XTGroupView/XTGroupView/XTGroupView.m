//
//  XTGroupView.m
//  XTGroupView
//
//  Created by admin on 16/2/20.
//  Copyright © 2016年 xt. All rights reserved.
//

#import "XTGroupView.h"

#define GROUP_ITEM_MARGIN 10
#define GROUP_TITLE_LABEL_HEIGHT 40
#define SELECTED_COLOR [UIColor colorWithRed:3.0 / 255.0 green:152.0 / 255.0 blue:250.0 / 255 alpha:1.0]

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

- (void)setDataSource:(id<XTGroupViewDataSource>)dataSource {
    _dataSource = dataSource;
    
    self.groups = [NSMutableArray array];
    
    NSInteger numberOfGroups = [dataSource numberOfGroups];
    
    for (NSInteger groupIndex=0; groupIndex<numberOfGroups; groupIndex++) {
        XTGroup *group = [[XTGroup alloc] init];
        
        if ([dataSource respondsToSelector:@selector(titleOfGroup:)]) {
            NSString *titleOfGroup = [dataSource titleOfGroup:groupIndex];
            if (titleOfGroup && ![titleOfGroup isEqualToString:@""]) {
                UILabel *label = [[UILabel alloc] init];
                label.font = [UIFont systemFontOfSize:14];
                label.text = titleOfGroup;
                label.textAlignment = NSTextAlignmentLeft;
                group.titleLabel = label;
                [self addSubview:label];
            }
        }
        
        NSInteger numberOfGroupItems = [dataSource numberOfGroupItems:groupIndex];
        for (NSInteger groupItemIndex=0; groupItemIndex<numberOfGroupItems; groupItemIndex++) {
            NSString *groupItemTitle = [dataSource titleOfGroupItem:groupIndex index:groupItemIndex];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.layer.cornerRadius = 3;
            button.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [button setTitle:groupItemTitle forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            [button sizeToFit];
            button.frame = CGRectMake(0, 0, button.frame.size.width + GROUP_ITEM_MARGIN, button.frame.size.height);
            [self addSubview:button];
            
            BOOL isSelected = NO;
            if ([self.dataSource respondsToSelector:@selector(isGroupItemSelected:index:)]) {
                isSelected = [self.dataSource isGroupItemSelected:groupIndex index:groupItemIndex];
            }
            
            if (isSelected) {
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                button.backgroundColor = SELECTED_COLOR;
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
            [currentGroupItem.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            currentGroupItem.button.backgroundColor = [UIColor groupTableViewBackgroundColor];
            currentGroupItem.isSelected = NO;
        } else {
            [currentGroupItem.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            currentGroupItem.isSelected = YES;
            currentGroupItem.button.backgroundColor = SELECTED_COLOR;
        }
        
        if (!allowMutiSelect) {
            for (XTGroupItem *groupItem in group.groupItems) {
                if (groupItem != currentGroupItem) {
                    [groupItem.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    groupItem.button.backgroundColor = [UIColor groupTableViewBackgroundColor];
                    groupItem.isSelected = NO;
                }
            }
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat top = 0;
    
    for (XTGroup *group in self.groups) {
        if (group.titleLabel) {
            group.titleLabel.frame = CGRectMake(GROUP_ITEM_MARGIN, top, self.bounds.size.width - GROUP_ITEM_MARGIN, GROUP_TITLE_LABEL_HEIGHT);
            top += GROUP_TITLE_LABEL_HEIGHT;
        }
        CGFloat left = GROUP_ITEM_MARGIN;
        for (XTGroupItem *groupItem in group.groupItems) {
            if (left + groupItem.button.frame.size.width + GROUP_ITEM_MARGIN > self.bounds.size.width) {
                left = GROUP_ITEM_MARGIN;
                top += groupItem.button.frame.size.height + GROUP_ITEM_MARGIN;
            }
            
            groupItem.button.frame = CGRectMake(left, top, groupItem.button.frame.size.width, groupItem.button.frame.size.height);
            
            left += groupItem.button.frame.size.width + GROUP_ITEM_MARGIN;
            
            if (groupItem == group.groupItems.lastObject) {
                top += groupItem.button.frame.size.height + GROUP_ITEM_MARGIN;
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
