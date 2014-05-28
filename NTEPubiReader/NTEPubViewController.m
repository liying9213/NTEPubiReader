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
    self.view.backgroundColor=[UIColor yellowColor];
    currentTextSize = 100;
    [self loadEpub:nil];
    [self ResetNavView];
    [self ResetPageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)ResetNavView
{
    UIBarButtonItem *leftItem1 = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    UIBarButtonItem *leftItem2 = [[UIBarButtonItem alloc] initWithTitle:@"目录" style:UIBarButtonItemStyleBordered target:self action:@selector(showChapterList)];
    self.navigationItem.leftBarButtonItems = @[leftItem1,leftItem2];

}

-(void)ResetPageView
{
    NSDictionary *options =[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin] forKey: UIPageViewControllerOptionSpineLocationKey];
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options: options];
    _pageController.dataSource = self;
    _pageController.delegate=self;
    [[_pageController view] setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-0)];
    NTWebViewController *initialViewController =[[NTWebViewController alloc] init];// 得到第一页
    initialViewController.delegate=self;
    initialViewController.NTloadedEpub=loadedEpub;
    initialViewController.view.frame=_pageController.view.frame;
    initialViewController.currentSpineIndex=currentSpineIndex;
    NSArray *viewControllers =[NSArray arrayWithObject:initialViewController];
    [_pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward  animated:NO  completion:nil];
    [self addChildViewController:_pageController];
    [[self view] addSubview:[_pageController view]];
    
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
    NSLog(@"====viewControllerBeforeViewController====1=====");
//    [self webviewLoadFinish];
    isFinishLoad=NO;
    NSLog(@"====viewControllerBeforeViewController====2=====");
    return [self BeforeView];
}

// 返回下一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(NTWebViewController *)viewController
{
    currentSpineIndex=viewController.currentSpineIndex;
    if (currentSpineIndex+1==loadedEpub.spineArray.count)
    {
        return nil;
    }
    NSLog(@"====viewControllerAfterViewController====1=====");
//    [self webviewLoadFinish];
    isFinishLoad=NO;
    NSLog(@"====viewControllerAfterViewController====2=====");
//    [NSThread detachNewThreadSelector:@selector(AfterView) toTarget:self withObject:nil];
    return [self AfterView];
//    return [NSThread pe]
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

-(void)webviewLoadFinish
{
    if (isFinishLoad)
    {
        return;
    }
    else
    {
        NSLog(@"=======================");
        [self webviewLoadFinish];
    }
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
    loadedEpub = [[NTEPub alloc] initWithEPubPath:@"机械制造基础.epub" WithSize:_EpubWebView.bounds fontPercentSize:currentTextSize];
    epubLoaded = YES;
}

-(void)webViewFinishLoadWithpagesInCurrentSpine:(int)Index
{
    isFinishLoad=YES;
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


#pragma mark - NavAction -

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showChapterList
{
    if (!_ChapterListView)
    {
        _ChapterListView =[[NTEPubChapterListView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _ChapterListView.chapterArray=loadedEpub.chapterArray;
        _ChapterListView.delegate=self;
        [self.view addSubview:_ChapterListView];
//        _ChapterListView.backgroundColor=[UIColor yellowColor];
        return;
    }
    _ChapterListView.hidden=!_ChapterListView.hidden;
}

-(void)webviewJumpChapterWithpath:(NSString *)path
{
    NSArray *urlpath=[path componentsSeparatedByString:@"#"];
    if (urlpath.count>1)
    {
        for (int i=0; i<loadedEpub.spineArray.count; i++)
        {
            if ([[urlpath objectAtIndex:0] isEqualToString:[[loadedEpub.spineArray objectAtIndex:i] spinePath]])
            {
                [self webviewJumpWithpath:[urlpath objectAtIndex:1] withIndex:i];
                _ChapterListView.hidden=YES;
                return;
            }
        }
    }
    
    
}


-(void)dealloc
{
    _EpubWebView.delegate=nil;
    [_EpubWebView stopLoading];
    _EpubWebView=nil;
    NSLog(@"===dealloc %@",self.class);
}

@end
