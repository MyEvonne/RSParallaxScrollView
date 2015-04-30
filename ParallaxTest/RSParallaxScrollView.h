//
//  RSParallaxScrollView.h
//  ParallaxTest
//
//  Created by Richard Sheng on 15/4/29.
//  Copyright (c) 2015年 Richard Sheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RSParallaxScrollViewDataSource;
@protocol RSParallaxScrollViewDelegate;

@interface RSParallaxScrollView : UIView
@property (nonatomic, assign) id<RSParallaxScrollViewDataSource> dataSource;
@property (nonatomic, assign) id<RSParallaxScrollViewDelegate> delegate;

- (void)reloadData;

@end

@protocol RSParallaxScrollViewDataSource <NSObject>
@required
- (NSInteger)numberOfItemsInScrollView:(RSParallaxScrollView *)scrollView;
- (UIView *)backgroundViewAtIndex:(NSInteger)index scrollView:(RSParallaxScrollView *)scrollView;

@optional
- (UIView *)foregroundViewAtIndex:(NSInteger)index scrollView:(RSParallaxScrollView *)scrollView;

@end

@protocol RSParallaxScrollViewDelegate <NSObject>

@optional
- (void)parallaxScrollView:(RSParallaxScrollView *)scrollView didChangeIndex:(NSInteger)index;
- (void)parallaxScrollView:(RSParallaxScrollView *)scrollView didEndDeceleratingAtIndex:(NSInteger)index;
- (void)parallaxScrollView:(RSParallaxScrollView *)scrollView didRecieveTapAtIndex:(NSInteger)index;
@end