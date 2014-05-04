//
//  NTWebViewController.m
//  NTEPubiReader
//
//  Created by liying on 14-5-4.
//  Copyright (c) 2014年 liying. All rights reserved.
//

#import "NTWebViewController.h"
#import "SearchResult.h"
#import "NTChapter.h"
@interface NTWebViewController ()

@end

@implementation NTWebViewController

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
    _currentTextSize = 100;
    [self ResetView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadView
{
    [super loadView];
    
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
    [self  loadSpine:_currentSpineIndex atPageIndex:_currentPageInSpineIndex];
    
//    UISwipeGestureRecognizer* rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gotoNextPage)];
//	[rightSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
//	
//	UISwipeGestureRecognizer* leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gotoPrevPage)];
//	[leftSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
//	
//	[_EpubWebView addGestureRecognizer:rightSwipeRecognizer];
//	[_EpubWebView addGestureRecognizer:leftSwipeRecognizer];
    //    [self loadSpine:currentSpineIndex atPageIndex:currentPageInSpineIndex];
	
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
	NSString *setTextSizeRule = [NSString stringWithFormat:@"addCSSRule('body', '-webkit-text-size-adjust: %d%%;')", _currentTextSize];
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
	_pagesInCurrentSpineCount = (int)((float)totalWidth/_EpubWebView.bounds.size.width);
	
    [_delegate webViewFinishLoadWithpagesInCurrentSpineCount:_pagesInCurrentSpineCount withcurrentPageInSpineIndex:_currentPageInSpineIndex];
	[self gotoPageInCurrentSpine:_currentPageInSpineIndex];
    
}

- (void) loadSpine:(int)spineIndex atPageIndex:(int)pageIndex
{
	[self loadSpine:spineIndex atPageIndex:pageIndex highlightSearchResult:nil];
}

- (void) loadSpine:(int)spineIndex atPageIndex:(int)pageIndex highlightSearchResult:(SearchResult*)theResult
{
    if (_EpubWebView==nil)
    {
//        [self ResetView];
    }
	_EpubWebView.hidden = YES;
    NSString *str=[[_NTloadedEpub.spineArray objectAtIndex:spineIndex] spinePath];
	[_EpubWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:str]]];
	_currentPageInSpineIndex = pageIndex;
	_currentSpineIndex = spineIndex;
    
    //    UIWebView* webView = [[UIWebView alloc] initWithFrame:_EpubWebView.bounds];
    //    [webView setDelegate:self];
    //    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:@"/Users/biejia/Library/Application Support/iPhone Simulator/7.1/Applications/C66FD05A-B02D-4955-B5A8-F3B0FDE31D91/Documents/UnzippedEpub/呼吸机临床应用快速解读.epub/OPS/000-toc.html"]];
    //    [webView loadRequest:urlRequest];
    //
    //    [self.view addSubview:webView];
}

- (void) gotoPageInCurrentSpine:(int)pageIndex
{
	if(pageIndex>=_pagesInCurrentSpineCount)
    {
		pageIndex = _pagesInCurrentSpineCount - 1;
		_currentPageInSpineIndex = _pagesInCurrentSpineCount - 1;
	}
	
	float pageOffset = pageIndex*_EpubWebView.bounds.size.width;
    
	NSString* goToOffsetFunc = [NSString stringWithFormat:@" function pageScroll(xOffset){ window.scroll(xOffset,0); } "];
	NSString* goTo =[NSString stringWithFormat:@"pageScroll(%f)", pageOffset];
	
	[_EpubWebView stringByEvaluatingJavaScriptFromString:goToOffsetFunc];
	[_EpubWebView stringByEvaluatingJavaScriptFromString:goTo];
	_EpubWebView.hidden = NO;
}



@end
