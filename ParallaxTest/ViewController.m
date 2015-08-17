//
//  ViewController.m
//  ParallaxTest
//
//  Created by Richard Sheng on 15/4/29.
//  Copyright (c) 2015年 Richard Sheng. All rights reserved.
//

#import "ViewController.h"
#import "RSParallaxScrollView.h"

@interface ViewController () <RSParallaxScrollViewDataSource>

@property(nonatomic, strong) RSParallaxScrollView *scrollView;
@property(nonatomic, strong) NSArray *photos;

@end

@implementation ViewController

#pragma mark - view's life cycle

- (void)initControl {
    self.scrollView =
    [[RSParallaxScrollView alloc] initWithFrame:self.view.bounds];
    self.photos = @[
                    @"1.jpg",
                    @"2.jpg",
                    @"3.jpg",
                    @"4.jpg",
                    @"5.jpg",
                    @"6.jpg",
                    @"7.jpg",
                    @"8.jpg"
                    ];
    _scrollView.dataSource = self;
    
    [self.view insertSubview:_scrollView atIndex:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initControl];
    [_scrollView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - PWParallaxScrollViewSource

- (NSInteger)numberOfItemsInScrollView:(RSParallaxScrollView *)scrollView {
    return self.photos.count;
}

- (UIView *)parallaxScrollView:(RSParallaxScrollView *)parallaxScrollView
                   viewAtIndex:(NSInteger)index {
    UIImageView *imageView = [[UIImageView alloc]
                              initWithImage:[UIImage imageNamed:self.photos[index]]];
    imageView.frame = self.view.bounds;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    return imageView;
}

@end
