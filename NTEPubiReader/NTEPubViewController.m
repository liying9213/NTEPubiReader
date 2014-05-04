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
//    [self ResetView];
    [self loadEpub:nil];
    
    [self ResetPageView];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)ResetPageView
{
    // 设置UIPageViewController的配置项
    NSDictionary *options =[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin] forKey: UIPageViewControllerOptionSpineLocationKey];
    // 实例化UIPageViewController对象，根据给定的属性
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options: options];
    // 设置UIPageViewController对象的代理
    _pageController.dataSource = self;
    // 定义“这本书”的尺寸
    [[_pageController view] setFrame:[[self view] bounds]];
    
    // 让UIPageViewController对象，显示相应的页数据。
    // UIPageViewController对象要显示的页数据封装成为一个NSArray。
    // 因为我们定义UIPageViewController对象显示样式为显示一页（options参数指定）。
    // 如果要显示2页，NSArray中，应该有2个相应页数据。
    NTWebViewController *initialViewController =[[NTWebViewController alloc] init];// 得到第一页
    initialViewController.delegate=self;
    initialViewController.NTloadedEpub=loadedEpub;
    initialViewController.currentSpineIndex=currentSpineIndex;
    initialViewController.currentPageInSpineIndex=currentPageInSpineIndex;
//    [initialViewController loadSpine:currentSpineIndex atPageIndex:currentPageInSpineIndex];
    NSArray *viewControllers =[NSArray arrayWithObject:initialViewController];
    [_pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward  animated:NO  completion:nil];
    // 在页面上，显示UIPageViewController对象的View
    [self addChildViewController:_pageController];
    [[self view] addSubview:[_pageController view]];
}

#pragma mark- UIPageViewControllerDataSource

// 返回上一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(NTWebViewController *)viewController
{
    currentSpineIndex=viewController.currentSpineIndex;
    pagesInCurrentSpineCount=viewController.pagesInCurrentSpineCount;
    currentPageInSpineIndex=viewController.currentPageInSpineIndex;
    if (currentSpineIndex==0) {
        return nil;
    }
//    NSUInteger index = [self indexOfViewController:(MoreViewController *)viewController];
//    if ((index == 0) || (index == NSNotFound))
//    {
//        return nil;
//    }
//    index--;
    return [self BeforeView];
}

// 返回下一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(NTWebViewController *)viewController
{
    currentSpineIndex=viewController.currentSpineIndex;
    pagesInCurrentSpineCount=viewController.pagesInCurrentSpineCount;
    currentPageInSpineIndex=viewController.currentPageInSpineIndex;
    if (currentSpineIndex==loadedEpub.spineArray.count)
    {
        return nil;
    }
    
    
//    NSUInteger index = [self indexOfViewController:(MoreViewController *)viewController];
//    if (index == NSNotFound) {
//        return nil;
//    }
//    index++;
//    if (index == [self.pageContent count])
//    {
//        return nil;
//    }
    return [self AfterView];
}

-(NTWebViewController *)BeforeView
{
    NTWebViewController *dataViewController;
    if(currentPageInSpineIndex-1>=0)
    {
        dataViewController =[[NTWebViewController alloc] init];
//        dataViewController =_NTEpubWebView;
        dataViewController.NTloadedEpub=loadedEpub;
        dataViewController.currentSpineIndex=currentSpineIndex;
        dataViewController.currentPageInSpineIndex=--currentPageInSpineIndex;
//        [dataViewController gotoPageInCurrentSpine:--currentPageInSpineIndex];
    } else
    {
        dataViewController =[[NTWebViewController alloc] init];
        if(currentSpineIndex!=0)
        {
            int targetPage = [(NTChapter *)[loadedEpub.spineArray objectAtIndex:(currentSpineIndex-1)] pageCount];
            dataViewController.NTloadedEpub=loadedEpub;
            dataViewController.currentSpineIndex=--currentSpineIndex;
            dataViewController.currentPageInSpineIndex=targetPage-1;
//            [dataViewController loadSpine:--currentSpineIndex atPageIndex:targetPage-1];
        }
    }
    dataViewController.delegate=self;
    
//    _NTEpubWebView=dataViewController;
    return dataViewController;
}

-(NTWebViewController *)AfterView
{
    NTWebViewController *dataViewController;
    if(currentPageInSpineIndex+1<pagesInCurrentSpineCount)
    {
        dataViewController =[[NTWebViewController alloc] init];
//        dataViewController =_NTEpubWebView;
        dataViewController.NTloadedEpub=loadedEpub;
        dataViewController.currentSpineIndex=currentSpineIndex;
        dataViewController.currentPageInSpineIndex=++currentPageInSpineIndex;
//        [dataViewController gotoPageInCurrentSpine:++currentPageInSpineIndex];

    }
    else
    {
        dataViewController =[[NTWebViewController alloc] init];
        if(currentSpineIndex+1<[loadedEpub.spineArray count])
        {
            dataViewController.NTloadedEpub=loadedEpub;
            dataViewController.currentSpineIndex=++currentSpineIndex;
            dataViewController.currentPageInSpineIndex=0;
//			[dataViewController loadSpine:++currentSpineIndex atPageIndex:0];
		}
    }
    dataViewController.delegate=self;
//    dataViewController.NTloadedEpub=loadedEpub;
//    _NTEpubWebView=dataViewController;
    return dataViewController;
}

-(void)ResetView
{
    _EpubWebView = [[UIWebView alloc] initWithFrame:self.view.frame];
    _EpubWebView.delegate = self;
    _EpubWebView.backgroundColor=[UIColor lightGrayColor];
    _EpubWebView.scrollView.alwaysBounceHorizontal = YES;
    _EpubWebView.scrollView.alwaysBounceVertical = NO;
    _EpubWebView.scrollView.bounces = YES;
    _EpubWebView.scrollView.showsVerticalScrollIndicator = NO;
    _EpubWebView.scrollView.showsHorizontalScrollIndicator = NO;
    _EpubWebView.scrollView.delegate = self;
    _EpubWebView.scrollView.pagingEnabled = YES;
    _EpubWebView.backgroundColor = [UIColor clearColor];
    _EpubWebView.scrollView.scrollEnabled=NO;
    _EpubWebView.scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_EpubWebView];
    
    UISwipeGestureRecognizer* rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gotoNextPage)];
	[rightSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
	
	UISwipeGestureRecognizer* leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gotoPrevPage)];
	[leftSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
	
	[_EpubWebView addGestureRecognizer:rightSwipeRecognizer];
	[_EpubWebView addGestureRecognizer:leftSwipeRecognizer];
//    [self loadSpine:currentSpineIndex atPageIndex:currentPageInSpineIndex];
	
}

-(void)loadEpub
{
    [self loadEpub:nil];
}

- (void) loadEpub:(NSURL*) epubURL{
    currentSpineIndex = 0;
    currentPageInSpineIndex = 0;
    pagesInCurrentSpineCount = 0;
    totalPagesCount = 0;
	searching = NO;
    epubLoaded = NO;
    loadedEpub = [[NTEPub alloc] initWithEPubPath:@"机械制造基础.epub" WithSize:_EpubWebView.bounds fontPercentSize:currentTextSize];
    epubLoaded = YES;
	[self updatePagination];
}

- (void) chapterDidFinishLoad:(NTChapter*)chapter
{
    totalPagesCount+=chapter.pageCount;
    
	if(chapter.chapterIndex + 1 < [loadedEpub.spineArray count])
    {
		[[loadedEpub.spineArray objectAtIndex:chapter.chapterIndex+1] setDelegate:self];
		[[loadedEpub.spineArray objectAtIndex:chapter.chapterIndex+1] loadChapterWithWindowSize:_EpubWebView.bounds fontPercentSize:currentTextSize];
//		[currentPageLabel setText:[NSString stringWithFormat:@"?/%d", totalPagesCount]];
	}
    else
    {
//		[currentPageLabel setText:[NSString stringWithFormat:@"%d/%d",[self getGlobalPageCount], totalPagesCount]];
//		[pageSlider setValue:(float)100*(float)[self getGlobalPageCount]/(float)totalPagesCount animated:YES];
		paginating = NO;
		NSLog(@"Pagination Ended!");
	}
}

- (int) getGlobalPageCount
{
	int pageCount = 0;
	for(int i=0; i<currentSpineIndex; i++){
		pageCount+= [(NTChapter *)[loadedEpub.spineArray objectAtIndex:i] pageCount];
	}
	pageCount+=currentPageInSpineIndex+1;
	return pageCount;
}

- (void) loadSpine:(int)spineIndex atPageIndex:(int)pageIndex
{
	[self loadSpine:spineIndex atPageIndex:pageIndex highlightSearchResult:nil];
}

- (void) loadSpine:(int)spineIndex atPageIndex:(int)pageIndex highlightSearchResult:(SearchResult*)theResult
{
	_EpubWebView.hidden = YES;
    NSString *str=[[loadedEpub.spineArray objectAtIndex:spineIndex] spinePath];
	[_EpubWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:str]]];
	currentPageInSpineIndex = pageIndex;
	currentSpineIndex = spineIndex;
    
//    UIWebView* webView = [[UIWebView alloc] initWithFrame:_EpubWebView.bounds];
//    [webView setDelegate:self];
//    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:@"/Users/biejia/Library/Application Support/iPhone Simulator/7.1/Applications/C66FD05A-B02D-4955-B5A8-F3B0FDE31D91/Documents/UnzippedEpub/呼吸机临床应用快速解读.epub/OPS/000-toc.html"]];
//    [webView loadRequest:urlRequest];
//    
//    [self.view addSubview:webView];
}

- (void) gotoPageInCurrentSpine:(int)pageIndex
{
	if(pageIndex>=pagesInCurrentSpineCount)
    {
		pageIndex = pagesInCurrentSpineCount - 1;
		currentPageInSpineIndex = pagesInCurrentSpineCount - 1;
	}
	float pageOffset = pageIndex*_EpubWebView.bounds.size.width;
	NSString* goToOffsetFunc = [NSString stringWithFormat:@" function pageScroll(xOffset){ window.scroll(xOffset,0); } "];
	NSString* goTo =[NSString stringWithFormat:@"pageScroll(%f)", pageOffset];
	[_EpubWebView stringByEvaluatingJavaScriptFromString:goToOffsetFunc];
	[_EpubWebView stringByEvaluatingJavaScriptFromString:goTo];
	_EpubWebView.hidden = NO;
}

- (void) gotoNextSpine
{
	if(!paginating){
		if(currentSpineIndex+1<[loadedEpub.spineArray count]){
			[self loadSpine:++currentSpineIndex atPageIndex:0];
		}
	}
}

- (void) gotoPrevSpine
{
	if(!paginating){
		if(currentSpineIndex-1>=0){
			[self loadSpine:--currentSpineIndex atPageIndex:0];
		}
	}
}

- (void) gotoNextPage
{
	if(!paginating){
		if(currentPageInSpineIndex+1<pagesInCurrentSpineCount)
        {
			[self gotoPageInCurrentSpine:++currentPageInSpineIndex];
		} else {
			[self gotoNextSpine];
		}
	}
}

- (void) gotoPrevPage
{
	if (!paginating) {
		if(currentPageInSpineIndex-1>=0){
			[self gotoPageInCurrentSpine:--currentPageInSpineIndex];
		} else {
			if(currentSpineIndex!=0){
				int targetPage = [(NTChapter *)[loadedEpub.spineArray objectAtIndex:(currentSpineIndex-1)] pageCount];
				[self loadSpine:--currentSpineIndex atPageIndex:targetPage-1];
			}
		}
	}
}

- (void) updatePagination
{
	if(epubLoaded){
        if(!paginating){
            NSLog(@"Pagination Started!");
            paginating = YES;
            totalPagesCount=0;
//            [self loadSpine:currentSpineIndex atPageIndex:currentPageInSpineIndex];
            [[loadedEpub.spineArray objectAtIndex:0] setDelegate:self];
            [[loadedEpub.spineArray objectAtIndex:0] loadChapterWithWindowSize:_EpubWebView.bounds fontPercentSize:currentTextSize];
            paginating = NO;
        }
	}
}

- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
	NSString *varMySheet = @"var mySheet = document.styleSheets[0];";
	
	NSString *addCSSRule =  @"function addCSSRule(selector, newRule) {"
	"if (mySheet.addRule) {"
	"mySheet.addRule(selector, newRule);"								// For Internet Explorer
	"} else {"
	"ruleIndex = mySheet.cssRules.length;"
	"mySheet.insertRule(selector + '{' + newRule + ';}', ruleIndex);"   // For Firefox, Chrome, etc.
	"}"
	"}";
	
	NSString *insertRule1 = [NSString stringWithFormat:@"addCSSRule('html', 'padding: 0px; height: %fpx; -webkit-column-gap: 0px; -webkit-column-width: %fpx;')", _EpubWebView.frame.size.height, _EpubWebView.frame.size.width];
	NSString *insertRule2 = [NSString stringWithFormat:@"addCSSRule('p', 'text-align: justify;')"];
    NSString *insertRule3 = @"addCSSRule('img', 'max-width:100%; max-height:100%;border:none;')";
	NSString *setTextSizeRule = [NSString stringWithFormat:@"addCSSRule('body', '-webkit-text-size-adjust: %d%%;')", currentTextSize];
	NSString *setHighlightColorRule = [NSString stringWithFormat:@"addCSSRule('highlight', 'background-color: yellow;')"];
    
	
	[_EpubWebView stringByEvaluatingJavaScriptFromString:varMySheet];
	
	[_EpubWebView stringByEvaluatingJavaScriptFromString:addCSSRule];
    
	[_EpubWebView stringByEvaluatingJavaScriptFromString:insertRule1];
	
	[_EpubWebView stringByEvaluatingJavaScriptFromString:insertRule2];
    
    [_EpubWebView stringByEvaluatingJavaScriptFromString:insertRule3];
	
	[_EpubWebView stringByEvaluatingJavaScriptFromString:setTextSizeRule];
	
	[_EpubWebView stringByEvaluatingJavaScriptFromString:setHighlightColorRule];
	
//	if(currentSearchResult!=nil){
//        //	NSLog(@"Highlighting %@", currentSearchResult.originatingQuery);
//        [_EpubWebView highlightAllOccurencesOfString:currentSearchResult.originatingQuery];
//	}
	
	int totalWidth = [[_EpubWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollWidth"] intValue];
	pagesInCurrentSpineCount = (int)((float)totalWidth/_EpubWebView.bounds.size.width);
	[self gotoPageInCurrentSpine:currentPageInSpineIndex];
}

-(void)webViewFinishLoadWithpagesInCurrentSpineCount:(int)Count withcurrentPageInSpineIndex:(int)Index
{
    pagesInCurrentSpineCount=Count;
    currentPageInSpineIndex=Index;
}

-(void)dealloc
{
    _EpubWebView.delegate=nil;
    [_EpubWebView stopLoading];
    _EpubWebView=nil;
    NSLog(@"===dealloc %@",self.class);
}

@end
