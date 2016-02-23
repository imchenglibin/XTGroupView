# XTPageControl
An easy solution to group view

## Overview
<img height=500 src="https://github.com/imchenglibin/XTGroupView/blob/master/Images/Demo.png">

## Usage
Drag the folder to your project.<br>
<img height=200 src="https://github.com/imchenglibin/XTGroupView/blob/master/Images/Folder.png">

```objective-c
#import "XTGroupView.h"
```

Create a XTGroupView: <br>
```objective-c
[[XTGroupView alloc] init];
```
Then you have to implements the data source and groupViewDelegate:<br>
```objective-c
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
```

Properties that the group view current support<br/>

```objective-c
@property(assign, nonatomic)XTGroupViewSeparatorLineStyle separatorLineStyle;

@property(strong, nonatomic)UIColor *groupItemTitleColorNormal;
@property(strong, nonatomic)UIColor *groupItemTitleColorSelected;
@property(strong, nonatomic)UIColor *groupItemBackgroundColorNormal;
@property(strong, nonatomic)UIColor *groupItemBackgroundColorSelected;
@property(strong, nonatomic)UIColor *groupTitleColor;
```

For more detail usage of the XTGroupView refer to the demo in this project.

## Pod Support
pod 'XTGroupView', :git => 'https://github.com/imchenglibin/XTGroupView.git'

## License
This project use `MIT` license, for more details refer to `LICENSE` file
