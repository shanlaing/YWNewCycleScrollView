//
//  YWPageNumber.h
//  EnochBannerDemo
//
//  Created by yishanliang on 2017/5/18.
//  Copyright © 2017年 meng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWPageNumber : UIView
{
    NSMutableArray *_numberViews;
}

@property (nonatomic, assign) NSInteger currentPageNumber;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, retain) UIColor *unselectedColor;
@property (nonatomic, retain) UIColor *selectedColor;
@property (nonatomic, assign) CGFloat unselectedAlpha;
@property (nonatomic, assign) CGFloat selectedAlpha;
@end
