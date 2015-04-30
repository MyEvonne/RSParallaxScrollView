//
//  RSParallaxScrollView.m
//  ParallaxTest
//
//  Created by Richard Sheng on 15/4/29.
//  Copyright (c) 2015年 Richard Sheng. All rights reserved.
//

#import "RSParallaxScrollView.h"

typedef NS_ENUM(NSInteger, RSParallaxScrollDirection) {
    RSParallaxScrollDirectionLeft,
    RSParallaxScrollDirectionRight,
    RSParallaxScrollDirectionNone
};

@interface RSParallaxScrollView ()<UIScrollViewDelegate>
{
    UIScrollView *              _scrollViewForControl;
    
    UIScrollView *              _scrollViewBackground;
    UIView *                    _viewBackgroundLeft;
    UIView *                    _viewBackgroundMiddle;
    UIView *                    _viewBackgroundRight;
    
    UIScrollView *              _scrollViewForeground;
    UIView *                    _viewForegroundLeft;
    UIView *                    _viewForegroundMiddle;
    UIView *                    _viewForegroundRight;

    NSUInteger                  _numberOfItems;
    
    NSUInteger                  _currentIndex;
    
}
@end

@implementation RSParallaxScrollView

#pragma mark - Initiation Methods
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initControl];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initControl];
    }
    return self;
}

- (void)initControl
{
    _scrollViewForControl = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollViewForControl.delegate = self;
    _scrollViewForControl.pagingEnabled = YES;
    _scrollViewForControl.backgroundColor = [UIColor clearColor];
    _scrollViewForControl.contentOffset = CGPointMake(0, 0);
    _scrollViewForControl.multipleTouchEnabled = YES;
    
    _scrollViewBackground = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollViewBackground.pagingEnabled = YES;
    _scrollViewBackground.backgroundColor = [UIColor clearColor];
    _scrollViewBackground.contentOffset = CGPointMake(0, 0);
    
    _scrollViewForeground = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollViewForeground.pagingEnabled = YES;
    _scrollViewForeground.backgroundColor = [UIColor clearColor];
    _scrollViewForeground.contentOffset = CGPointMake(0, 0);
    
    [self addSubview:_scrollViewBackground];
    [self addSubview:_scrollViewForeground];
    [self addSubview:_scrollViewForControl];
}

#pragma mark - Public Methods
- (void)reloadData
{
    _numberOfItems = [self.dataSource numberOfItemsInScrollView:self];
    
    [_scrollViewForControl setContentOffset:CGPointMake(0, 0) animated:NO];
    [_scrollViewForControl setContentSize:CGSizeMake(CGRectGetWidth(self.frame) * _numberOfItems, CGRectGetHeight(self.frame))];

    [_scrollViewBackground setContentOffset:CGPointMake(0, 0) animated:NO];
    [_scrollViewBackground.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_scrollViewBackground setContentSize:CGSizeMake(CGRectGetWidth(self.frame) / 2 * (_numberOfItems + 1), CGRectGetHeight(self.frame))];
    
    _scrollViewForeground.contentSize = _scrollViewForControl.contentSize;
    
    [self layoutBackgroundViewAtIndex:0];
    [self layoutForegroundViewAtIndex:0];
    _currentIndex = 0;
}

#pragma mark - Background View Generator
- (void)layoutBackgroundViewAtIndex:(NSInteger)index
{
    if (index < 0 || index >= _numberOfItems)
    {
        return;
    }
    
    [_scrollViewBackground.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self layoutMiddleBackgroundViewOfIndex:index];
    [self layoutRightBackgroundViewOfIndex:index];
    [self layoutLeftBackgroundViewOfIndex:index];
}

- (void)layoutMiddleBackgroundViewOfIndex:(NSInteger)index
{
    
    UIView * view = [self backgroundViewForIndex:index];
    [_scrollViewBackground addSubview:view];
    _viewBackgroundMiddle = view;
}

- (void)layoutLeftBackgroundViewOfIndex:(NSInteger)index
{
    NSInteger indexLeft = index - 1;
    if (indexLeft >= 0)
    {
        UIView * view = [self backgroundViewForIndex:indexLeft];
        CGRect frame = view.frame;
        frame.size.width = frame.size.width / 2;
        view.frame = frame;
        [_scrollViewBackground addSubview:view];
        _viewBackgroundLeft = view;
    }
}

- (void)layoutRightBackgroundViewOfIndex:(NSInteger)index
{
    NSInteger indexRight = index + 1;
    if (indexRight < _numberOfItems)
    {
        UIView * view = [self backgroundViewForIndex:indexRight];
        [_scrollViewBackground addSubview:view];
        [_scrollViewBackground sendSubviewToBack:view];
        _viewBackgroundLeft = view;
    }
}

- (UIView *)backgroundViewForIndex:(NSInteger)index
{
    CGRect frame;
    
    UIView * backgroundView = [self.dataSource backgroundViewAtIndex:index scrollView:self];
    frame = backgroundView.frame;
    frame.origin.x = CGRectGetWidth(self.frame) / 2 * index;
    backgroundView.frame = frame;
    backgroundView.clipsToBounds = YES;
    return backgroundView;
}

#pragma mark - Foreground View Generator
- (void)layoutForegroundViewAtIndex:(NSInteger)index
{
    if (index < 0 || index >= _numberOfItems)
    {
        return;
    }
    
    NSInteger indexLeft = index - 1;
    if (indexLeft >= 0)
    {
        _viewForegroundLeft = [self foregroundViewForIndex:indexLeft];
        [_scrollViewForeground addSubview:_viewForegroundLeft];
    }
    
    NSInteger indexRight = index + 1;
    if (indexRight < _numberOfItems)
    {
        _viewForegroundRight = [self foregroundViewForIndex:indexRight];
        [_scrollViewForeground addSubview:_viewForegroundRight];
    }
    
    _viewForegroundMiddle = [self foregroundViewForIndex:index];
    [_scrollViewForeground addSubview:_viewForegroundMiddle];
}

- (UIView *)foregroundViewForIndex:(NSInteger)index
{
    CGRect frame;

    UIView * foregroundView = nil;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(foregroundViewAtIndex:scrollView:)])
    {
        foregroundView = [self.dataSource foregroundViewAtIndex:index scrollView:self];
    }
    frame = foregroundView.frame;
    frame.origin.x = CGRectGetWidth(self.frame) * index;
    foregroundView.frame = frame;
    foregroundView.clipsToBounds = YES;
    return foregroundView;
}


#pragma mark - View Animation
- (RSParallaxScrollDirection)scrollDirection
{
    if (_scrollViewBackground.contentOffset.x < _viewBackgroundMiddle.frame.origin.x)
        return RSParallaxScrollDirectionRight;
    else if (_scrollViewBackground.contentOffset.x > _viewBackgroundMiddle.frame.origin.x)
        return RSParallaxScrollDirectionLeft;
    else
        return RSParallaxScrollDirectionNone;
}

- (void)scrollLeft
{
    CGRect frame = _viewBackgroundMiddle.frame;
    frame.size.width = self.frame.size.width - (_scrollViewBackground.contentOffset.x - frame.origin.x);
    _viewBackgroundMiddle.frame = frame;
    NSLog(@"Middle Background frame: x:%f, width:%f", _viewBackgroundMiddle.frame.origin.x, _viewBackgroundMiddle.frame.size.width);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"contentOffset: %f, %f", scrollView.contentOffset.x, scrollView.contentOffset.y);

    _scrollViewForeground.contentOffset = scrollView.contentOffset;
    _scrollViewBackground.contentOffset = CGPointMake(scrollView.contentOffset.x / 2, scrollView.contentOffset.y);
    
//    NSLog(@"contentOffset: %f, %f", _scrollViewBackground.contentOffset.x, _scrollViewBackground.contentOffset.y);

    RSParallaxScrollDirection direction = [self scrollDirection];
    if (direction == RSParallaxScrollDirectionLeft)
    {
        [self scrollLeft];
    }
    else if (direction == RSParallaxScrollDirectionRight)
    {
//        NSLog(@"R");
    }
    
    NSUInteger indexShowed = floorf(scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame));
    if (_currentIndex > indexShowed)
    {
        [self layoutForegroundViewAtIndex:indexShowed];
        [self layoutBackgroundViewAtIndex:indexShowed];
        _currentIndex = indexShowed;
    }
    else if (_currentIndex < indexShowed)
    {
        
    }
}

@end
