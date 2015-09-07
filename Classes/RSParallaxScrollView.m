//
//  RSParallaxScrollView.m
//  WeiBao
//
//  Created by Richard Sheng on 15/5/19.
//  Copyright (c) 2015年 wamei. All rights reserved.
//

#import "RSParallaxScrollView.h"

static const CGFloat kRSParallaxViewBorderWidth = 3.0;

@interface RSParallaxScrollView () <UIScrollViewDelegate>
{
    
    NSInteger mNumberOfItems;
    
    UIView *mViewLeft;
    UIView *mViewMiddle;
    UIView *mViewRight;
}

@end

@implementation RSParallaxScrollView

#pragma mark - View Life Cycle
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
//        self.bounces = NO;
        _currentIndex = 0;
        return self;
    }
    return nil;
}

#pragma mark - Public Methods
- (void)reloadData {
    mNumberOfItems = [self.dataSource numberOfItemsInScrollView:self];
    
    self.contentSize = CGSizeMake(self.frame.size.width * mNumberOfItems,
                                  CGRectGetHeight(self.frame));
    
    [mViewLeft removeFromSuperview];
    [mViewMiddle removeFromSuperview];
    [mViewRight removeFromSuperview];
    
    [self layoutLeftViewByIndex:_currentIndex];
    [self layoutMiddleViewByIndex:_currentIndex];
    [self layoutRightViewByIndex:_currentIndex];
}

- (UIView *)leftView {
    return mViewLeft;
}

- (UIView *)middleView {
    return mViewMiddle;
}

- (UIView *)rightView {
    return mViewRight;
}

- (NSInteger)indexForView:(UIView *)view {
    if (view == mViewLeft) {
        return _currentIndex - 1;
    } else if (view == mViewMiddle) {
        return _currentIndex;
    } else if (view == mViewRight) {
        return _currentIndex + 1;
    } else {
        return -1;
    }
}

- (UIView *)viewInIndex:(NSInteger)index {
    if (index == _currentIndex - 1) {
        return mViewLeft;
    } else if (index == _currentIndex) {
        return mViewMiddle;
    } else if (index == _currentIndex + 1) {
        return mViewRight;
    } else {
        return nil;
    }
}

#pragma mark - Layout Views
- (UIView *)layoutMiddleViewByIndex:(NSInteger)index {
    mViewMiddle = [self viewForIndex:index];
    [self addSubview:mViewMiddle];
    [self didLoadView:mViewMiddle];
    return mViewMiddle;
}

- (UIView *)layoutLeftViewByIndex:(NSInteger)index {
    NSInteger indexLeft = index - 1;
    mViewLeft = [self viewForIndex:indexLeft];
    if (mViewLeft) {
        [self addSubview:mViewLeft];
    }
    [self didLoadView:mViewLeft];
    return mViewLeft;
}

//- (void)setLeftViewFrame
//{
//    CGRect frame = _viewLeft.frame;
//    frame.size.width = frame.size.width / 2;
//    frame.origin.x += frame.size.width;
//    _viewLeft.frame = frame;
//}

- (UIView *)layoutRightViewByIndex:(NSInteger)index {
    NSInteger indexRight = index + 1;
    mViewRight = [self viewForIndex:indexRight];
    [self setRightViewFrame];
    if (mViewRight) {
        
        [self addSubview:mViewRight];
    }
    [self didLoadView:mViewRight];
    return mViewRight;
}

- (void)setRightViewFrame {
    CGRect frame = mViewRight.frame;
    frame.size.width = frame.size.width / 2;
    mViewRight.frame = frame;
    frame = mViewRight.bounds;
    frame.origin.x = frame.size.width;
    mViewRight.bounds = frame;
}

- (UIView *)viewForIndex:(NSInteger)index {
    if (index < 0 || index >= mNumberOfItems) {
        return nil;
    }
    
    CGRect frame;
    
    UIView *backgroundView = [self.dataSource parallaxScrollView:self viewAtIndex:index];
    frame = backgroundView.frame;
    frame.origin.x = CGRectGetWidth(self.frame) * index;
    backgroundView.frame = frame;
    backgroundView.clipsToBounds = YES;
    return backgroundView;
}

- (void)didLoadView:(UIView *)view {
    if (self.scrollDelegate &&
        [self.scrollDelegate
         respondsToSelector:@selector(parallaxScrollView:didLoadView:)]) {
            [self.scrollDelegate parallaxScrollView:self didLoadView:view];
        }
}

- (void)scrollRightWithXOffset:(CGFloat)xOffset {
    CGRect frame = mViewRight.frame;
    frame.size.width = self.frame.size.width / 2 + xOffset / 2;
    mViewRight.frame = frame;
    frame = mViewRight.bounds;
    frame.origin.x = self.frame.size.width / 2 - xOffset / 2;
    mViewRight.bounds = frame;
    if (self.scrollDelegate &&
        [self.scrollDelegate
         respondsToSelector:@selector(parallaxScrollView:didScroll:)]) {
            [self.scrollDelegate parallaxScrollView:self
                                          didScroll:RSParallaxViewScrollDirectionRight];
        }
}

- (void)scrollRightOnePage {
    _currentIndex++;
    [mViewLeft removeFromSuperview];
    mViewLeft = mViewMiddle;
    mViewMiddle = mViewRight;
    mViewRight = [self layoutRightViewByIndex:_currentIndex];
    
    CGRect frame = mViewMiddle.frame;
    frame.origin.x = self.frame.size.width * _currentIndex;
    frame.size.width = self.frame.size.width;
    mViewMiddle.frame = frame;
    frame = mViewMiddle.bounds;
    frame.origin.x = 0;
    frame.size.width = self.frame.size.width;
    mViewMiddle.bounds = frame;
    
    if (self.scrollDelegate &&
        [self.scrollDelegate
         respondsToSelector:@selector(parallaxScrollView:didScrollOnePage:)]) {
            [self.scrollDelegate parallaxScrollView:self
                                   didScrollOnePage:RSParallaxViewScrollDirectionRight];
        }
}

- (void)scrollRightToEnd {
    if (self.scrollDelegate &&
        [self.scrollDelegate
         respondsToSelector:@selector(parallaxScrollView:didScrollToEnd:)]) {
            [self.scrollDelegate parallaxScrollView:self
                                     didScrollToEnd:RSParallaxViewScrollDirectionRight];
        }
}

- (void)scrollLeftWithXOffset:(CGFloat)xOffset {
    CGRect frame = mViewMiddle.frame;
    frame.size.width = self.frame.size.width + xOffset / 2;
    mViewMiddle.frame = frame;
    
    frame = mViewMiddle.bounds;
    frame.origin.x = -xOffset / 2;
    mViewMiddle.bounds = frame;
    
    if (self.scrollDelegate &&
        [self.scrollDelegate
         respondsToSelector:@selector(parallaxScrollView:didScroll:)]) {
            [self.scrollDelegate parallaxScrollView:self
                                          didScroll:RSParallaxViewScrollDirectionLeft];
        }
}

- (void)scrollLeftOnePage {
    _currentIndex--;
    [mViewRight removeFromSuperview];
    mViewRight = mViewMiddle;
    mViewMiddle = mViewLeft;
    mViewLeft = [self layoutLeftViewByIndex:_currentIndex];
    
    CGRect frame = mViewMiddle.frame;
    frame.origin.x = self.frame.size.width * _currentIndex;
    frame.size.width = self.frame.size.width;
    mViewMiddle.frame = frame;
    frame = mViewMiddle.bounds;
    frame.origin.x = 0;
    frame.size.width = self.frame.size.width;
    mViewMiddle.bounds = frame;
    
    if (self.scrollDelegate &&
        [self.scrollDelegate
         respondsToSelector:@selector(parallaxScrollView:didScrollOnePage:)]) {
            [self.scrollDelegate parallaxScrollView:self
                                   didScrollOnePage:RSParallaxViewScrollDirectionLeft];
        }
}

- (void)scrollLeftToEnd {
    if (self.scrollDelegate &&
        [self.scrollDelegate
         respondsToSelector:@selector(parallaxScrollView:didScrollToEnd:)]) {
            [self.scrollDelegate parallaxScrollView:self
                                     didScrollToEnd:RSParallaxViewScrollDirectionLeft];
        }
}

- (void)scrollCanceled {
    CGRect frame = mViewMiddle.frame;
    frame.size.width = self.frame.size.width;
    mViewMiddle.frame = frame;
    
    frame = mViewMiddle.bounds;
    frame.origin.x = 0;
    frame.size.width = self.frame.size.width;
    mViewMiddle.bounds = frame;
}

#pragma mark - Border View Methods
- (UIView *)borderView {
    CGRect frame =
    CGRectMake(0, 0, kRSParallaxViewBorderWidth, CGRectGetHeight(self.frame));
    
    UIView *viewBorder = [[UIView alloc] initWithFrame:frame];
    viewBorder.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    return viewBorder;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat xOffsetOfIndex = scrollView.frame.size.width * _currentIndex;
    CGFloat xOffsetDelta = scrollView.contentOffset.x - xOffsetOfIndex;
    
    if (xOffsetDelta > 0) { // scroll right
        [self scrollRightWithXOffset:xOffsetDelta];
        
        if (fabs(xOffsetDelta) >= scrollView.frame.size.width) { // paging
            [self scrollRightOnePage];
        }
    } else if (xOffsetDelta < 0) { // scroll left
        [self scrollLeftWithXOffset:xOffsetDelta];
        
        if (fabs(xOffsetDelta) >= scrollView.frame.size.width) { // paging
            [self scrollLeftOnePage];
        }
    } else {
        [self scrollCanceled];
    }
    
    if (scrollView.contentOffset.x + scrollView.bounds.size.width ==
        scrollView.contentSize.width) {
        [self scrollRightToEnd];
    } else if (scrollView.contentOffset.x == 0) {
        [self scrollLeftToEnd];
    }
}

@end
