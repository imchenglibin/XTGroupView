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

- (NSInteger)numberOfGroups;
- (NSInteger)numberOfGroupItems:(NSInteger)group;
- (NSString*)titleOfGroupItem:(NSInteger)group index:(NSInteger)index;

@optional
- (NSString*)titleOfGroup:(NSInteger)group;
- (BOOL)isGroupItemSelected:(NSInteger)group index:(NSInteger)index;

@end

@protocol XTGroupViewDelegate <NSObject>
@optional
- (void)selectGroupItem:(NSInteger)group index:(NSInteger)index;
- (void)removeSelectGroupItem:(NSInteger)group index:(NSInteger)index;
- (BOOL)allowMutiSelect:(NSInteger)group;

@end

@interface XTGroupView : UIScrollView

@property(weak, nonatomic)id<XTGroupViewDataSource> dataSource;
@property(weak, nonatomic)id<XTGroupViewDelegate> groupViewDelegate;
@property(assign, nonatomic)XTGroupViewSeparatorLineStyle separatorLineStyle;

@end
