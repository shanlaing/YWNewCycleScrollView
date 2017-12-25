//
//  YWCycleScrollView.m
//  EnochBannerDemo
//
//  Created by yishanliang on 2017/5/18.
//  Copyright © 2017年 meng. All rights reserved.
//

#import "YWNewCycleScrollView.h"

@interface YWNewCycleScrollView () <UIScrollViewDelegate>
@property (nonatomic , assign) NSInteger currentPageIndex;
@property (nonatomic , assign) NSInteger totalPageCount;
@property (nonatomic , strong) NSMutableArray *contentViews;
@property (nonatomic , strong) UIScrollView *scrollView;
@property (nonatomic , weak)   NSTimer *animationTimer;
@property (nonatomic , assign) NSTimeInterval animationDuration;
@property (nonatomic , assign) CGFloat showMargin;
@property (nonatomic , assign) CGFloat leftMargin;
@property (nonatomic , assign) CGFloat rightMargin;
@end

@implementation YWNewCycleScrollView

#pragma mark -----------------------------cyclelife-----------------------------------

- (instancetype)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration{
    if (self = [super initWithFrame:frame]) {
        self.autoresizesSubviews = YES;
        [self addSubview:self.scrollView];
        self.currentPageIndex = 1;
        self.showMargin = 6;
        self.leftMargin = 12;
        self.rightMargin = 80;
        if (animationDuration) {
            self.animationDuration = animationDuration;
        }
    }
    return self;
}

- (void)dealloc
{
    self.scrollView.delegate = nil;
    NSLog(@"dealloc scroll");
}

#pragma mark -----------------------------primethods----------------------------------

- (void)setShowMargin:(CGFloat )margin left:(CGFloat )leftMargin right:(CGFloat )rightMargin {
    self.showMargin = margin;
    self.leftMargin = leftMargin;
    self.rightMargin = rightMargin;
}

- (void)animationTimerDidFired:(NSTimer *)timer
{
    CGPoint newOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame) * 2, self.scrollView.contentOffset.y);
    [self.scrollView setContentOffset:newOffset animated:YES];
}

- (void)contentViewTapAction:(UITapGestureRecognizer *)tap
{
    if (self.TapActionBlock) {
        self.TapActionBlock(self.currentPageIndex);
    }
}

- (void)configContentViews:(BOOL)scrollRight
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setScrollViewContentDataSource];
    
    NSInteger counter = 0;
    CGFloat width = CGRectGetWidth(self.scrollView.bounds) - 2 * self.showMargin - self.leftMargin - self.rightMargin;
    for (UIView *contentView in self.contentViews) {
        contentView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
        [contentView addGestureRecognizer:tapGesture];
        CGRect rightRect = contentView.frame;
        CGFloat x = 0;
        if (counter == 0) {
            x = self.showMargin * 2 +  2 * self.leftMargin + self.rightMargin;
        } else if (counter == 1) {
            x = self.showMargin + self.leftMargin;
        } else if (counter == 2) {
            x = - self.rightMargin;
        }
        rightRect.origin = CGPointMake(x + CGRectGetWidth(self.scrollView.bounds) * counter++, 0);
        rightRect.size.width = width;
        contentView.frame = rightRect;
        [self.scrollView addSubview:contentView];
    }
    if (scrollRight) {
        [_scrollView setContentOffset:CGPointMake(_scrollView.bounds.size.width + _scrollView.contentOffset.x, 0)];
    } else {
        [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x - _scrollView.bounds.size.width, 0)];
    }
}

/**
 *  设置scrollView的content数据源，即contentViews
 */
- (void)setScrollViewContentDataSource
{
    if (!self.totalPageCount) {
        return;
    }
    NSInteger previousPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
    NSInteger rearPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
    if (self.contentViews == nil) {
        self.contentViews = [@[] mutableCopy];
    }
    [self.contentViews removeAllObjects];
    
    if (self.fetchContentViewAtIndex) {
        [self.contentViews addObject:self.fetchContentViewAtIndex(previousPageIndex)];
        [self.contentViews addObject:self.fetchContentViewAtIndex(_currentPageIndex)];
        [self.contentViews addObject:self.fetchContentViewAtIndex(rearPageIndex)];
    }
}

- (NSInteger)getValidNextPageIndexWithPageIndex:(NSInteger)currentPageIndex;
{
    if(currentPageIndex == -1) {
        return self.totalPageCount - 1;
    } else if (currentPageIndex == self.totalPageCount) {
        return 0;
    } else {
        return currentPageIndex;
    }
}

- (void)pauseAnimationTimer
{
    if (!self.animationTimer.isValid) {
        return;
    }
    [self.animationTimer setFireDate:[NSDate distantFuture]];
}

- (void)stopAnimationTimer
{
    [self.animationTimer invalidate];
    self.animationTimer = nil;
}

#pragma mark -------------------------UIScrollViewDelegate-------------------------------

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self pauseAnimationTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (![self.animationTimer isValid]) {
        return ;
    }
    [self.animationTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.animationDuration]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int contentOffsetX = scrollView.contentOffset.x;
    float viewWidth = CGRectGetWidth(self.scrollView.bounds) - 2 * self.showMargin - self.leftMargin - self.rightMargin;
    
    CGRect visibleRect = CGRectZero;
    visibleRect.origin = scrollView.contentOffset;
    visibleRect.size = scrollView.bounds.size;
    
    CGFloat centerX = self.scrollView.frame.size.width * 0.5 + contentOffsetX;
    for (UIView *view in scrollView.subviews) {
        
        CGFloat delta = ABS(centerX - view.center.x);
        CGFloat scale = 1.0 - 0.2 * (delta / viewWidth);
        scale = MIN(1, scale);
        view.transform = CGAffineTransformMakeScale(1.0, scale);
    }
    
    if(contentOffsetX >= 2 * viewWidth) {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
        [self configContentViews: NO];
    }
    if(contentOffsetX <= 120) {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
        [self configContentViews: YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0) animated:YES];
}

#pragma mark ----------------------------setter/getter--------------------------------

- (void)setTotalPagesCount:(NSInteger (^)(void))totalPagesCount
{
    _totalPageCount = totalPagesCount();
    if (_totalPageCount > 0) {
        self.currentPageIndex = 0;
        [self configContentViews: NO];
        [_scrollView setContentOffset:CGPointMake(_scrollView.bounds.size.width * 2, 0)];
        [self stopAnimationTimer];
        if (_totalPageCount > 1 && self.animationDuration > 0) {
            __weak typeof(self) weakSelf = self;
            self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:(self.animationDuration)
                                                                   target:weakSelf
                                                                 selector:@selector(animationTimerDidFired:)
                                                                 userInfo:nil
                                                                  repeats:YES];
        }
    }
}

- (void)setCurrentPageIndex:(NSInteger)currentPageIndex
{
    _currentPageIndex = currentPageIndex;
    if (self.changeCurrentIndexBlock) {
        self.changeCurrentIndexBlock(currentPageIndex);
    }
}

- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.autoresizingMask = 0xFF;
        _scrollView.contentMode = UIViewContentModeCenter;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(3 * CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
        _scrollView.delegate = self;
        _scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame), 0);
        _scrollView.pagingEnabled = YES;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _scrollView;
}

@end
