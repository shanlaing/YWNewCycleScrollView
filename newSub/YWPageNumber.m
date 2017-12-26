//
//  YWPageNumber.m
//  EnochBannerDemo
//
//  Created by yishanliang on 2017/5/18.
//  Copyright © 2017年 meng. All rights reserved.
//

#import "YWPageNumber.h"
#define kWidth 11
#define kPadding 5
#define kSelectedAlpha 1.0
#define kUnselectedAlpha 1.0

@implementation YWPageNumber
@synthesize currentPageNumber = _currentPageNumber;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _numberViews = [[NSMutableArray alloc] init];
//        self.unselectedColor = [UIColor_RgbColor colorWithHexString:@"#D8D8D8"];
//        self.selectedColor = [UIColor_RgbColor colorWithHexString:@"#ff5532"];
        
        self.unselectedAlpha = kUnselectedAlpha;
        self.selectedAlpha = kSelectedAlpha;
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self resetPageViewFrame];
}

- (void)resetPageViewFrame {
    float widths = 4;
    CGFloat width = self.pageCount * widths + (self.pageCount - 1) * kPadding + 7;
    CGFloat x = (self.frame.size.width - width) / 2;
    
    if (_numberViews.count == self.pageCount) {
        for (NSInteger index = 0; index < self.pageCount; index++) {
            UIView *view = [_numberViews objectAtIndex:index];
            if (_currentPageNumber == index) {
                widths = 11;
            } else {
                widths = 4;
            }
            view.frame = CGRectMake(x, 0, widths, 2);
            
            x += (widths + kPadding);
        }
    }
}

- (void)setCurrentPageNumber:(NSInteger)currentPageNumber
{
    _currentPageNumber = currentPageNumber;
    
    if (_currentPageNumber < _numberViews.count) {
        for (UIView *subView in self.subviews) {
            subView.alpha = self.unselectedAlpha;
            subView.backgroundColor = self.unselectedColor;
        }
        
        UIView *numberView = [_numberViews objectAtIndex:currentPageNumber];
        numberView.alpha = self.selectedAlpha;
        numberView.backgroundColor = self.selectedColor;
        [self resetPageViewFrame];
    }
}

- (void)setPageCount:(NSInteger)pageCount
{
    _pageCount = pageCount;
    
    [self clearSubviews];
    
    if (_pageCount <= 1) {
        return;
    }
    
    CGFloat width = pageCount * kWidth + (pageCount - 1) * kPadding;
    CGFloat x = (self.frame.size.width - width) / 2;
    
    for (NSInteger index = 0; index < pageCount; index++) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = self.unselectedColor;
        view.alpha = self.unselectedAlpha;
        [self addSubview:view];
        [_numberViews addObject:view];
        
        x += (kWidth + kPadding);
    }
    
    [self setCurrentPageNumber:_currentPageNumber];
}

- (void)clearSubviews
{
    [_numberViews removeAllObjects];
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
}

@end
