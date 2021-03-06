//
//  PRAlbumViewController.m
//  PRSlideViewExample
//
//  Created by Elethom Hunter on 8/5/14.
//  Copyright (c) 2014 Project Rhinestone. All rights reserved.
//

#import "PRAlbumViewController.h"
#import "PRSlideView.h"
#import "PRAlbumPage.h"

@interface PRAlbumViewController () <PRSlideViewDelegate, PRSlideViewDataSource>

@property (nonatomic, strong) NSArray *albumData;

@property (nonatomic, strong) PRSlideView *slideView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation PRAlbumViewController

#pragma mark - Life cycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.albumData = @[@"Gorillaz",
                       @"G-Sides",
                       @"Laika Come Home",
                       @"Demon Days",
                       @"D-Sides (Special Edition)",
                       @"Plastic Beach",
                       @"The Fall",
                       @"The Singles Collection 2001-2011"];
    
    CGRect bounds = self.view.bounds;
    CGFloat titleHeight = 24.f;
    
    self.slideView = ({
        PRSlideView *slideView = [[PRSlideView alloc] initWithFrame:bounds];
        slideView.delegate = self;
        slideView.dataSource = self;
        slideView.infiniteScrollingEnabled = YES;
        [slideView registerClass:PRAlbumPage.class
          forPageReuseIdentifier:NSStringFromClass(PRAlbumPage.class)];
        slideView.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                      UIViewAutoresizingFlexibleHeight);
        [self.view addSubview:slideView];
        
        UIView *titleBackgroundView = [[UIView alloc] initWithFrame:({
            CGRect frame;
            CGRect remainder;
            CGRectDivide(bounds,
                         &frame,
                         &remainder,
                         kPRSlideViewPageControlHeight * 1.5 + titleHeight,
                         CGRectMaxYEdge);
            frame = CGRectIntegral(frame);
            frame;
        })];
        titleBackgroundView.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                                UIViewAutoresizingFlexibleTopMargin);
        titleBackgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:.6f];
        [slideView insertSubview:titleBackgroundView
                    belowSubview:slideView.pageControl];
        
        self.titleLabel = ({
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:({
                CGRect frame;
                CGRect remainder;
                CGRectDivide(titleBackgroundView.frame,
                             &remainder,
                             &frame,
                             kPRSlideViewPageControlHeight,
                             CGRectMaxYEdge);
                CGRectDivide(frame,
                             &frame,
                             &remainder,
                             titleHeight,
                             CGRectMaxYEdge);
                frame;
            })];
            titleLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                           UIViewAutoresizingFlexibleTopMargin);
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.textColor = [UIColor whiteColor];
            [slideView addSubview:titleLabel];
            titleLabel;
        });
        
        slideView;
    });
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.slideView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - PRSlideViewDelegate

- (void)slideView:(PRSlideView *)slideView didScrollToPageAtIndex:(NSInteger)index
{
    self.titleLabel.text = self.albumData[index];
}

- (void)slideView:(PRSlideView *)slideView didClickPageAtIndex:(NSInteger)index
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You clicked an album"
                                                    message:self.albumData[index]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - PRSlideViewDataSource

- (NSInteger)numberOfPagesInSlideView:(PRSlideView *)slideView
{
    return self.albumData.count;
}

- (PRSlideViewPage *)slideView:(PRSlideView *)slideView pageAtIndex:(NSInteger)index
{
    PRAlbumPage *page = [slideView dequeueReusablePageWithIdentifier:NSStringFromClass(PRAlbumPage.class)
                                                            forIndex:index];
    
    NSString *imageName = [self.albumData[index] stringByAppendingPathExtension:@"jpg"];
    page.coverImageView.image = [UIImage imageNamed:imageName];
    
    return page;
}

@end
