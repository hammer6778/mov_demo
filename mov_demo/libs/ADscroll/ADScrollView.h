//
//  ADScrollView.h
//  mov_demo
//
//  Created by Mountain on 14/04/2024.
//

#import <UIKit/UIKit.h>


@interface ADScrollView : UIView
  
@property (nonatomic, strong) NSArray *titles; // 标题数组
@property (nonatomic, assign) NSTimeInterval scrollInterval; // 滚动间隔

//- (void)startScrolling; // 开始滚动
//- (void)stopScrolling; // 停止滚动

@end

