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
    NSUInteger                  _indexCurrent;
    NSUInteger                  _numberOfItems;

    UIScrollView *              _scrollViewBackground;
    UIView *                    _viewBackgroundLeft;
    UIView *                    _viewBackgroundMiddle;
    UIView *                    _viewBackgroundRight;
    
    UIScrollView *              _scrollViewForeground;
    UIView *                    _viewForegroundLeft;
    UIView *                    _viewForegroundMiddle;
    UIView *                    _viewForegroundRight;
}
@end

@implementation RSParallaxScrollView

#pragma mark - Initiation Methods
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initViews];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    [self initBackgroundScrollView];
    [self initForegroundScrollView];
    [self initControlScrollView];
}

- (void)initControlScrollView
{
    _scrollViewForControl = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollViewForControl.delegate = self;
    _scrollViewForControl.pagingEnabled = YES;
    _scrollViewForControl.backgroundColor = [UIColor clearColor];
    _scrollViewForControl.contentOffset = CGPointMake(0, 0);
    _scrollViewForControl.multipleTouchEnabled = YES;
    [self addSubview:_scrollViewForControl];
    
    _indexCurrent = 0;
}

- (void)initBackgroundScrollView
{
    _scrollViewBackground = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollViewBackground.pagingEnabled = YES;
    _scrollViewBackground.backgroundColor = [UIColor clearColor];
    _scrollViewBackground.contentOffset = CGPointMake(0, 0);
    [self addSubview:_scrollViewBackground];
}

- (void)initForegroundScrollView
{
    _scrollViewForeground = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollViewForeground.pagingEnabled = YES;
    _scrollViewForeground.backgroundColor = [UIColor clearColor];
    _scrollViewForeground.contentOffset = CGPointMake(0, 0);
    [self addSubview:_scrollViewForeground];
}

#pragma mark - Public Methods
- (void)reloadData
{
    _numberOfItems = [self.dataSource numberOfItemsInScrollView:self];
    
//    [_scrollViewForControl setContentOffset:CGPointMake(0, 0) animated:NO];
    [_scrollViewForControl setContentSize:CGSizeMake(CGRectGetWidth(self.frame) * _numberOfItems, CGRectGetHeight(self.frame))];

//    [_scrollViewBackground setContentOffset:CGPointMake(0, 0) animated:NO];
    [_scrollViewBackground.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_scrollViewBackground setContentSize:CGSizeMake(CGRectGetWidth(self.frame) / 2 * (_numberOfItems + 1), CGRectGetHeight(self.frame))];
    
    _scrollViewForeground.contentSize = _scrollViewForControl.contentSize;
    
    [self layoutBackgroundViewAtIndex:0];
//    [self layoutForegroundViewAtIndex:0];
}

#pragma mark - Background View Methods
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

- (UIView *)layoutMiddleBackgroundViewOfIndex:(NSInteger)index
{
    
    UIView * view = [self backgroundViewForIndex:index];
    [_scrollViewBackground addSubview:view];
    _viewBackgroundMiddle = view;
    return view;
}

- (UIView *)layoutLeftBackgroundViewOfIndex:(NSInteger)index
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
        return view;
    }
    return nil;
}

- (UIView *)layoutRightBackgroundViewOfIndex:(NSInteger)index
{
    NSInteger indexRight = index + 1;
    if (indexRight < _numberOfItems)
    {
        UIView * view = [self backgroundViewForIndex:indexRight];
        [_scrollViewBackground addSubview:view];
        [_scrollViewBackground sendSubviewToBack:view];
        _viewBackgroundRight = view;
        return view;
    }
    return nil;
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

- (void)backgroundScrollRightWithOffset:(CGPoint)offset
{
    _scrollViewBackground.contentOffset = CGPointMake(offset.x / 2, offset.y);
    
    CGRect frame = _viewBackgroundMiddle.frame;
    frame.size.width = self.frame.size.width - (_scrollViewBackground.contentOffset.x - frame.origin.x);
    _viewBackgroundMiddle.frame = frame;
}

- (void)backgroundScrollRightOnePage
{
    _indexCurrent++;
    [_viewBackgroundLeft removeFromSuperview];
    _viewBackgroundLeft = _viewBackgroundMiddle;
    _viewBackgroundMiddle = _viewBackgroundRight;
    _viewBackgroundRight = [self layoutRightBackgroundViewOfIndex:_indexCurrent];
}

- (void)backgroundScrollLeftWithOffset:(CGPoint)offset
{
    _scrollViewBackground.contentOffset = CGPointMake(offset.x / 2, offset.y);

    CGRect frame = _viewBackgroundLeft.frame;
    frame.size.width = self.frame.size.width - (_scrollViewBackground.contentOffset.x - frame.origin.x);
    _viewBackgroundLeft.frame = frame;
}

- (void)backgroundScrollLeftOnePage
{
    _indexCurrent--;
    [_viewBackgroundRight removeFromSuperview];
    _viewBackgroundRight = _viewBackgroundMiddle;
    _viewBackgroundMiddle = _viewBackgroundLeft;
    _viewBackgroundLeft = [self layoutLeftBackgroundViewOfIndex:_indexCurrent];
}

#pragma mark - Foreground View Methods
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


#pragma mark - Control Methods
- (void)scrollLeftComplete
{
    
}

- (void)scrollRight
{
    
}

- (void)scrollRightComplete
{
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    _scrollViewForeground.contentOffset = scrollView.contentOffset;
    
    CGFloat xOffsetOfIndex = scrollView.frame.size.width * _indexCurrent;
    CGFloat xOffsetDelta = scrollView.contentOffset.x - xOffsetOfIndex;
    
    if (xOffsetDelta > 0)
    {//scroll right
        [self backgroundScrollRightWithOffset:scrollView.contentOffset];
        if (fabsf(xOffsetDelta) >= scrollView.frame.size.width)
        {//paging
            [self backgroundScrollRightOnePage];
        }
    }
    else if (xOffsetDelta < 0)
    {//scroll left
        [self backgroundScrollLeftWithOffset:scrollView.contentOffset];
        if (fabsf(xOffsetDelta) >= scrollView.frame.size.width)
        {//paging
            [self backgroundScrollLeftOnePage];
        }
    }
//    NSLog(@"index: %d", _indexCurrent);
}

@end
