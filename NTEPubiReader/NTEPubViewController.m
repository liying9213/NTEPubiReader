//
//  NTEPubViewController.m
//  NTEPubiReader
//
//  Created by liying on 14-5-2.
//  Copyright (c) 2014年 liying. All rights reserved.
//

#import "NTEPubViewController.h"
#import "NTEPub.h"
#import "NTChapter.h"
#import "SearchResult.h"
#import "NTWebViewController.h"
@interface NTEPubViewController ()

@end

@implementation NTEPubViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    self.view.backgroundColor=[UIColor whiteColor];
    currentTextSize = 100;
    [self loadEpub:nil];
    [self ResetPageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)ResetPageView
{
    NSDictionary *options =[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin] forKey: UIPageViewControllerOptionSpineLocationKey];
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options: options];
    _pageController.dataSource = self;
    _pageController.delegate=self;
    [[_pageController view] setFrame:[[self view] bounds]];
    
    NTWebViewController *initialViewController =[[NTWebViewController alloc] init];// 得到第一页
    initialViewController.delegate=self;
    initialViewController.NTloadedEpub=loadedEpub;
    initialViewController.currentSpineIndex=currentSpineIndex;
//    [initialViewController loadSpine:currentSpineIndex atPageIndex:currentPageInSpineIndex];
    NSArray *viewControllers =[NSArray arrayWithObject:initialViewController];
    [_pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward  animated:NO  completion:nil];
    [self addChildViewController:_pageController];
    [[self view] addSubview:[_pageController view]];
    
    for (UIGestureRecognizer *gt in self.view.gestureRecognizers)
    {
        gt.delegate=self;
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]])
    {
        CGPoint touchpoint=[touch locationInView:self.view];
        if (touchpoint.y>40)
        {
            return NO;
        }
    }
    
    
    return YES;
}

#pragma mark- UIPageViewControllerDataSource

// 返回上一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(NTWebViewController *)viewController
{
    currentSpineIndex=viewController.currentSpineIndex;
    if (currentSpineIndex==0)
    {
        return nil;
    }
    return [self BeforeView];
}

// 返回下一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(NTWebViewController *)viewController
{
    currentSpineIndex=viewController.currentSpineIndex;
    if (currentSpineIndex==loadedEpub.spineArray.count)
    {
        return nil;
    }
    return [self AfterView];
}

-(NTWebViewController *)BeforeView
{
    NTWebViewController *dataViewController =[[NTWebViewController alloc] init];
    if(currentSpineIndex!=0)
    {
        dataViewController.NTloadedEpub=loadedEpub;
        dataViewController.isNeedLastPage=YES;
        dataViewController.currentSpineIndex=--currentSpineIndex;
    }
    dataViewController.delegate=self;
    return dataViewController;
}

-(NTWebViewController *)AfterView
{
    NTWebViewController *dataViewController =[[NTWebViewController alloc] init];
    if(currentSpineIndex+1<[loadedEpub.spineArray count])
    {
        dataViewController.NTloadedEpub=loadedEpub;
        dataViewController.currentSpineIndex=++currentSpineIndex;
    }
    dataViewController.delegate=self;
    return dataViewController;
}

-(void)loadEpub
{
    [self loadEpub:nil];
}

- (void) loadEpub:(NSURL*) epubURL
{
    currentSpineIndex = 0;
    currentPageInSpineIndex = 0;
    pagesInCurrentSpineCount = 0;
    totalPagesCount = 0;
	searching = NO;
    epubLoaded = NO;
    loadedEpub = [[NTEPub alloc] initWithEPubPath:@"消化科用药(1).epub" WithSize:_EpubWebView.bounds fontPercentSize:currentTextSize];
    epubLoaded = YES;
}

-(void)webViewFinishLoadWithpagesInCurrentSpine:(int)Index
{
    currentSpineIndex=Index;
}

-(void)webviewJumpWithpath:(NSString *)path withIndex:(int)index
{
    currentSpineIndex=index;

    NTWebViewController *initialViewController =[[NTWebViewController alloc] init];// 得到第一页
    initialViewController.delegate=self;
    initialViewController.NTloadedEpub=loadedEpub;
    initialViewController.currentSpineIndex=currentSpineIndex;
    initialViewController.URLAnchor=path;
    NSArray *viewControllers =[NSArray arrayWithObject:initialViewController];
    [_pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward  animated:NO  completion:nil];
}


-(void)dealloc
{
    _EpubWebView.delegate=nil;
    [_EpubWebView stopLoading];
    _EpubWebView=nil;
    NSLog(@"===dealloc %@",self.class);
}

@end
