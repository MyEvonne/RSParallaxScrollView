//
//  RSParallaxScrollView.h
//  WeiBao
//
//  Created by Richard Sheng on 15/5/19.
//  Copyright (c) 2015年 wamei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RSParallaxViewScrollDirection) {
    RSParallaxViewScrollDirectionLeft,
    RSParallaxViewScrollDirectionRight
};

@protocol RSParallaxScrollViewDataSource;
@protocol RSParallaxScrollViewDelegate;

@interface RSParallaxScrollView : UIScrollView
@property(nonatomic, assign) IBOutlet id<RSParallaxScrollViewDataSource> dataSource;
@property(nonatomic, assign) IBOutlet id<RSParallaxScrollViewDelegate> scrollDelegate;

@property(nonatomic, assign) NSInteger currentIndex;

- (void)reloadData;

- (UIView *)middleView;

/**
 *  获取一个View在ParallaxScrollView中的index。
 *
 *  @param view 某个view
 *
 *  @return 返回这个View的index，如果不存在，返回-1。
 */
- (NSInteger)indexForView:(UIView *)view;

- (UIView *)viewInIndex:(NSInteger)index;
@end

@protocol RSParallaxScrollViewDataSource <NSObject>
@required
- (NSInteger)numberOfItemsInScrollView:(RSParallaxScrollView *)scrollView;
- (UIView *)parallaxScrollView:(RSParallaxScrollView *)parallaxScrollView
                   viewAtIndex:(NSInteger)index;
@end

@protocol RSParallaxScrollViewDelegate <NSObject>
@optional
- (void)parallaxScrollView:(RSParallaxScrollView *)scrollView
               didLoadView:(UIView *)view;
- (void)parallaxScrollView:(RSParallaxScrollView *)scrollView
                 didScroll:(RSParallaxViewScrollDirection)direction;
- (void)parallaxScrollView:(RSParallaxScrollView *)scrollView
          didScrollOnePage:(RSParallaxViewScrollDirection)direction;
- (void)parallaxScrollView:(RSParallaxScrollView *)scrollView
            didScrollToEnd:(RSParallaxViewScrollDirection)direction;
@end