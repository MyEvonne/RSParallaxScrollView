//
//  RSParallaxScrollView.m
//  WeiBao
//
//  Created by Richard Sheng on 15/5/19.
//  Copyright (c) 2015年 wamei. All rights reserved.
//

#import "RSParallaxScrollView.h"

static const CGFloat kRSParallaxViewBorderWidth = 3.0;

@interface RSParallaxScrollView () <UIScrollViewDelegate> {
    NSInteger _numberOfItems;
    
    UIView *_viewLeft;
    UIView *_viewMiddle;
    UIView *_viewRight;
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
    _numberOfItems = [self.dataSource numberOfItemsInScrollView:self];
    
    self.contentSize = CGSizeMake(self.frame.size.width * _numberOfItems,
                                  CGRectGetHeight(self.frame));
    
    [_viewLeft removeFromSuperview];
    [_viewMiddle removeFromSuperview];
    [_viewRight removeFromSuperview];
    
    [self layoutLeftViewByIndex:_currentIndex];
    [self layoutMiddleViewByIndex:_currentIndex];
    [self layoutRightViewByIndex:_currentIndex];
}

- (UIView *)leftView {
    return _viewLeft;
}

- (UIView *)middleView {
    return _viewMiddle;
}

- (UIView *)rightView {
    return _viewRight;
}

- (NSInteger)indexForView:(UIView *)view {
    if (view == _viewLeft) {
        return _currentIndex - 1;
    } else if (view == _viewMiddle) {
        return _currentIndex;
    } else if (view == _viewRight) {
        return _currentIndex + 1;
    } else {
        return -1;
    }
}

- (UIView *)viewInIndex:(NSInteger)index {
    if (index == _currentIndex - 1) {
        return _viewLeft;
    } else if (index == _currentIndex) {
        return _viewMiddle;
    } else if (index == _currentIndex + 1) {
        return _viewRight;
    } else {
        return nil;
    }
}

#pragma mark - Layout Views
- (UIView *)layoutMiddleViewByIndex:(NSInteger)index {
    _viewMiddle = [self viewForIndex:index];
    [self addSubview:_viewMiddle];
    [self didLoadView:_viewMiddle];
    return _viewMiddle;
}

- (UIView *)layoutLeftViewByIndex:(NSInteger)index {
    NSInteger indexLeft = index - 1;
    _viewLeft = [self viewForIndex:indexLeft];
    if (_viewLeft) {
        [self addSubview:_viewLeft];
    }
    [self didLoadView:_viewLeft];
    return _viewLeft;
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
    _viewRight = [self viewForIndex:indexRight];
    [self setRightViewFrame];
    if (_viewRight) {
        
        [self addSubview:_viewRight];
    }
    [self didLoadView:_viewRight];
    return _viewRight;
}

- (void)setRightViewFrame {
    CGRect frame = _viewRight.frame;
    frame.size.width = frame.size.width / 2;
    _viewRight.frame = frame;
    frame = _viewRight.bounds;
    frame.origin.x = frame.size.width;
    _viewRight.bounds = frame;
}

- (UIView *)viewForIndex:(NSInteger)index {
    if (index < 0 || index >= _numberOfItems) {
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
    CGRect frame = _viewRight.frame;
    frame.size.width = self.frame.size.width / 2 + xOffset / 2;
    _viewRight.frame = frame;
    frame = _viewRight.bounds;
    frame.origin.x = self.frame.size.width / 2 - xOffset / 2;
    _viewRight.bounds = frame;
    if (self.scrollDelegate &&
        [self.scrollDelegate
         respondsToSelector:@selector(parallaxScrollView:didScroll:)]) {
            [self.scrollDelegate parallaxScrollView:self
                                          didScroll:RSParallaxViewScrollDirectionRight];
        }
}

- (void)scrollRightOnePage {
    _currentIndex++;
    [_viewLeft removeFromSuperview];
    _viewLeft = _viewMiddle;
    _viewMiddle = _viewRight;
    _viewRight = [self layoutRightViewByIndex:_currentIndex];
    
    CGRect frame = _viewMiddle.frame;
    frame.origin.x = self.frame.size.width * _currentIndex;
    frame.size.width = self.frame.size.width;
    _viewMiddle.frame = frame;
    frame = _viewMiddle.bounds;
    frame.origin.x = 0;
    frame.size.width = self.frame.size.width;
    _viewMiddle.bounds = frame;
    
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
    CGRect frame = _viewMiddle.frame;
    frame.size.width = self.frame.size.width + xOffset / 2;
    _viewMiddle.frame = frame;
    
    frame = _viewMiddle.bounds;
    frame.origin.x = -xOffset / 2;
    _viewMiddle.bounds = frame;
    
    if (self.scrollDelegate &&
        [self.scrollDelegate
         respondsToSelector:@selector(parallaxScrollView:didScroll:)]) {
            [self.scrollDelegate parallaxScrollView:self
                                          didScroll:RSParallaxViewScrollDirectionLeft];
        }
}

- (void)scrollLeftOnePage {
    _currentIndex--;
    [_viewRight removeFromSuperview];
    _viewRight = _viewMiddle;
    _viewMiddle = _viewLeft;
    _viewLeft = [self layoutLeftViewByIndex:_currentIndex];
    
    CGRect frame = _viewMiddle.frame;
    frame.origin.x = self.frame.size.width * _currentIndex;
    frame.size.width = self.frame.size.width;
    _viewMiddle.frame = frame;
    frame = _viewMiddle.bounds;
    frame.origin.x = 0;
    frame.size.width = self.frame.size.width;
    _viewMiddle.bounds = frame;
    
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
    CGRect frame = _viewMiddle.frame;
    frame.size.width = self.frame.size.width;
    _viewMiddle.frame = frame;
    
    frame = _viewMiddle.bounds;
    frame.origin.x = 0;
    frame.size.width = self.frame.size.width;
    _viewMiddle.bounds = frame;
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
