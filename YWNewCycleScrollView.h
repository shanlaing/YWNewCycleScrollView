//
//  YWCycleScrollView.h
//  EnochBannerDemo
//
//  Created by yishanliang on 2017/5/18.
//  Copyright © 2017年 meng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWNewCycleScrollView : UIView
/**
 *  初始化
 *
 *  @param frame             frame
 *  @param animationDuration 自动滚动的间隔时长。如果<=0，不自动滚动。
 *
 *  @return instance
 */
- (instancetype)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration;
/**
 *  暂停定时 timer 在父亲view dealloc 时调用
 *
 */
- (void)pauseAnimationTimer;

/**
 *  停止定时 timer 在父亲view dealloc 时调用
 *
 */
- (void)stopAnimationTimer;
/**
 *  设置左右间距 中间间距
 *
 *  @param margin      中间间距
 *  @param leftMargin  左边间距
 *  @param rightMargin 右边间距
 *
 */
- (void)setShowMargin:(CGFloat )margin left:(CGFloat )leftMargin right:(CGFloat )rightMargin;
/**
 数据源：获取总的page个数
 **/
@property (nonatomic , copy) NSInteger (^totalPagesCount)(void);

/**
 数据源：获取第pageIndex个位置的contentView
 **/
@property (nonatomic , copy) UIView *(^fetchContentViewAtIndex)(NSInteger pageIndex);

/**
 当点击的时候，执行的block
 **/
@property (nonatomic , copy) void (^TapActionBlock)(NSInteger pageIndex);

/**
 当滑动的时候，执行的block
 **/
@property (nonatomic , copy) void (^changeCurrentIndexBlock)(NSInteger pageIndex);

@end
