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

/**
 *  dataSource which confirm to RSParallaxScrollViewDataSource protocol.
 */
@property(nonatomic, assign) IBOutlet id<RSParallaxScrollViewDataSource> dataSource;
/**
 *  scrollDelegate which confirm to RSParallaxScrollViewDelegate protocol.
 */
@property(nonatomic, assign) IBOutlet id<RSParallaxScrollViewDelegate> scrollDelegate;
/**
 *  Index of view is shown.
 */
@property(nonatomic, assign) NSInteger currentIndex;
/**
 *  @brief Reload views when the data has been changed.
 */
- (void)reloadData;

///**
// *  获取一个View在ParallaxScrollView中的index。
// *
// *  @param view 某个view
// *
// *  @return 返回这个View的index，如果不存在，返回-1。
// */
//- (NSInteger)indexForView:(UIView *)view;
//
//- (UIView *)viewInIndex:(NSInteger)index;
@end

@protocol RSParallaxScrollViewDataSource <NSObject>
@required
/**
 *  DataSource method, get the total number of views which would be display.
 *
 *  @param scrollView The instance of RSParallaxScrollView which invokes the method.
 *
 *  @return Number of views would show on scrollView.
 */
- (NSInteger)numberOfViewsInScrollView:(RSParallaxScrollView *)parallaxScrollView;
/**
 *  Get the view in specific index, the size of the view should be the same as the parallaxScrollView.
 *
 *  @param parallaxScrollView  The instance of RSParallaxScrollView which invokes the method.
 *  @param index               The index of the view should be shown.
 *
 *  @return UIView or subclass of UIView and the size should be the same as parallaxScrollView.
 */
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