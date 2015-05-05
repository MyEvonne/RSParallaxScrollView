//
//  ViewController.m
//  ParallaxTest
//
//  Created by Richard Sheng on 15/4/29.
//  Copyright (c) 2015年 Richard Sheng. All rights reserved.
//

#import "ViewController.h"
//#import "PWParallaxScrollView.h"
#import "RSParallaxScrollView.h"

@interface ViewController ()<RSParallaxScrollViewDataSource>

@property (nonatomic, strong) RSParallaxScrollView *scrollView;
@property (nonatomic, strong) NSArray *photos;

@end

@implementation ViewController

#pragma mark - view's life cycle

- (void)initControl
{
    self.scrollView = [[RSParallaxScrollView alloc] initWithFrame:self.view.bounds];
    self.photos = @[@"1.jpg", @"2.jpg", @"3.jpg", @"4.jpg", @"5.jpg", @"6.jpg", @"7.jpg", @"8.jpg"];
    _scrollView.dataSource = self;

    [self.view insertSubview:_scrollView atIndex:0];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initControl];
    [_scrollView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - PWParallaxScrollViewSource

- (NSInteger)numberOfItemsInScrollView:(RSParallaxScrollView *)scrollView
{
    return self.photos.count;
}

- (UIView *)backgroundViewAtIndex:(NSInteger)index scrollView:(RSParallaxScrollView *)scrollView
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.photos[index]]];
    imageView.frame = self.view.bounds;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    return imageView;
}

- (UIView *)foregroundViewAtIndex:(NSInteger)index scrollView:(RSParallaxScrollView *)scrollView
{
    UIView * view = [[UIView alloc] initWithFrame:self.view.bounds];
    view.backgroundColor = [UIColor clearColor];
    
    UIView * viewLeftBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, CGRectGetHeight(view.frame))];
    viewLeftBar.backgroundColor = [UIColor blackColor];
    [view addSubview:viewLeftBar];
    
    UIView * viewRightBar = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(view.frame) - 2, 0, 2, CGRectGetHeight(view.frame))];
    viewRightBar.backgroundColor = [UIColor blackColor];
    [view addSubview:viewRightBar];
    
    UILabel * lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.text = [NSString stringWithFormat:@"%ld", (long)index];
    lbl.font = [UIFont boldSystemFontOfSize:100];
    lbl.textColor = [UIColor colorWithWhite:0.5 alpha:0.7];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.center = CGPointMake(CGRectGetWidth(view.frame) / 2, CGRectGetHeight(view.frame) / 2);
    [view addSubview:lbl];
    
    return view;
}

- (void)test
{
    NSLog(@"hit test");
}

#pragma mark - PWParallaxScrollViewDelegate

- (void)parallaxScrollView:(RSParallaxScrollView *)scrollView didChangeIndex:(NSInteger)index
{

}

- (void)parallaxScrollView:(RSParallaxScrollView *)scrollView didEndDeceleratingAtIndex:(NSInteger)index
{
    
}


@end
