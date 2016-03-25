//
//  XTGroupView.h
//  XTGroupView
//
//  Created by imchenglibin on 16/2/20.
//  Copyright © 2016年 xt. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XTGroupViewSeparatorLineStyle) {
    XTGroupViewSeparatorLineStyleNone = 0,
    XTGroupViewSeparatorLineStyleSingleLine = 1
};

@protocol XTGroupViewDataSource <NSObject>
//the number of groups
- (NSInteger)numberOfGroups;

//the number of items in group
- (NSInteger)numberOfGroupItems:(NSInteger)group;

//the title of item in group
- (NSString*)titleOfGroupItem:(NSInteger)group index:(NSInteger)index;

@optional
//the title of group
- (NSString*)titleOfGroup:(NSInteger)group;

//is group item in selected state by default
- (BOOL)isGroupItemSelected:(NSInteger)group index:(NSInteger)index;

@end

@protocol XTGroupViewDelegate <NSObject>
@optional
//select group item
- (void)selectGroupItem:(NSInteger)group index:(NSInteger)index;

//remove select group item
- (void)removeSelectGroupItem:(NSInteger)group index:(NSInteger)index;

//allow muti select for a group
- (BOOL)allowMutiSelect:(NSInteger)group;

@end

@interface XTGroupView : UIScrollView

@property(weak, nonatomic)id<XTGroupViewDataSource> dataSource;
@property(weak, nonatomic)id<XTGroupViewDelegate> groupViewDelegate;
@property(assign, nonatomic)XTGroupViewSeparatorLineStyle separatorLineStyle;

@property(strong, nonatomic)UIColor *groupItemTitleColorNormal;
@property(strong, nonatomic)UIColor *groupItemTitleColorSelected;
@property(strong, nonatomic)UIColor *groupItemBackgroundColorNormal;
@property(strong, nonatomic)UIColor *groupItemBackgroundColorSelected;
@property(strong, nonatomic)UIColor *groupTitleColor;
@property (assign, nonatomic) CGFloat groupItemHeight;

@end
