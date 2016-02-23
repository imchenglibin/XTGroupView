//
//  ViewController.m
//  XTGroupView
//
//  Created by admin on 16/2/20.
//  Copyright © 2016年 xt. All rights reserved.
//

#import "ViewController.h"
#import "XTGroupView.h"

@interface ViewController () <XTGroupViewDataSource, XTGroupViewDelegate> {
    XTGroupView *groupView;
    NSArray<NSArray<NSString*>*> *items;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    items = @[
              @[@"挂墙上的", @"放桌上的", @"放地上的", @"会亮哦", @"器皿／餐具", @"布艺"],
              @[@"塑料", @"装置", @"陶瓷", @"摄影", @"玻璃／琉璃", @"艺术设计品", @"油画", @"中国水墨", @"版画", @"综合材料", @"书法／印章"],
              @[@"自然风光", @"人物肖像", @"城市风景", @"动物／宠物／花鸟", @"抽象", @"时尚", @"山水", @"静物", @"幽默", @"日常生活", @"食物", @"宗教／禅修", @"民族／原生态"]
              ];
    groupView = [[XTGroupView alloc] init];
    groupView.separatorLineStyle = XTGroupViewSeparatorLineStyleSingleLine;
    groupView.dataSource = self;
    groupView.groupViewDelegate = self;
    
//    groupView.groupTitleColor = [UIColor redColor];
//    
//    groupView.groupItemTitleColorNormal = [UIColor redColor];
//    groupView.groupItemTitleColorSelected = [UIColor yellowColor];
//    
//    groupView.groupItemBackgroundColorNormal = [UIColor blackColor];
//    groupView.groupItemBackgroundColorSelected = [UIColor orangeColor];
    
    [self.view addSubview:groupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfGroups {
    return 3;
}

- (NSInteger)numberOfGroupItems:(NSInteger)group {
    return [items objectAtIndex:group].count;
}

- (NSString*)titleOfGroupItem:(NSInteger)group index:(NSInteger)index {
    return [[items objectAtIndex:group] objectAtIndex:index];
}

- (BOOL)isGroupItemSelected:(NSInteger)group index:(NSInteger)index {
    return group == 0 && index % 2 == 0;
}

- (BOOL)allowMutiSelect:(NSInteger)group {
    if (group == 2) {
        return NO;
    }
    return YES;
}

- (void)selectGroupItem:(NSInteger)group index:(NSInteger)index {
    NSLog(@"select group item");
}

- (void)removeSelectGroupItem:(NSInteger)group index:(NSInteger)index {
    NSLog(@"remove select group item");
}

- (NSString*)titleOfGroup:(NSInteger)group {
    return [@[@"用途（默认选中）", @"材料(多选)", @"题材（单选）"] objectAtIndex:group];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    groupView.frame = CGRectMake(0, [self.topLayoutGuide length], self.view.bounds.size.width, self.view.bounds.size.height - [self.topLayoutGuide length]);
}

@end
