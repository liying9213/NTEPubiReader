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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _currentTextSize = 100;
    [self ResetView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    _EpubWebView.scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_EpubWebView];
    [self loadSpine:_currentSpineIndex atPageIndex:0];
}

- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
    _isNeedJump=YES;
	NSString *varMySheet = @"var mySheet = document.styleSheets[0];";
	
	NSString *addCSSRule =  @"function addCSSRule(selector, newRule) {"
	"if (mySheet.addRule) {"
	"mySheet.addRule(selector, newRule);"								// For Internet Explorer
	"} else {"
	"ruleIndex = mySheet.cssRules.length;"
	"mySheet.insertRule(selector + '{' + newRule + ';}', ruleIndex);"   // For Firefox, Chrome, etc.
	"}"
	"}";
	
//	NSString *insertRule1 = [NSString stringWithFormat:@"addCSSRule('html', 'padding: 0px; height: %fpx; -webkit-column-gap: 0px; -webkit-column-width: %fpx;')", _EpubWebView.frame.size.height, _EpubWebView.frame.size.width];
    NSString *insertRule1 = [NSString stringWithFormat:@"addCSSRule('html', 'font-size:10px;padding: 0px; height: %fpx; -webkit-column-gap: 0px; -webkit-column-width: %fpx;')", _EpubWebView.frame.size.height - 20, _EpubWebView.frame.size.width - 20];
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
	
	int totalWidth = [[_EpubWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollWidth"] intValue];
	_pagesInCurrentSpineCount = (int)((float)totalWidth/_EpubWebView.bounds.size.width);

    [_delegate webViewFinishLoadWithpagesInCurrentSpine:_currentSpineIndex];
    if (_URLAnchor)
    {
        _isNeedJump=NO;
        [self gotoAnchorInCurrentSpine:_URLAnchor];
    }
    if (_isNeedLastPage)
    {
        [self gotoLastPageInCurrentSpine];
    }
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (!_isNeedJump)
    {
        return YES;
    }
    NSString *urlString = [[request URL] absoluteString];
    NSArray *urlComps = [urlString componentsSeparatedByString:@"://"];
    if([urlComps count]>1 && [[urlComps objectAtIndex:0] isEqualToString:@"file"])
    {
        NSArray *urlpath=[[urlComps objectAtIndex:1]componentsSeparatedByString:@"#"];
        if (urlpath.count>1)
        {
            NSString *localurlString = [[webView.request URL] absoluteString];
            NSArray *localurlComps = [localurlString componentsSeparatedByString:@"://"];
            if (localurlComps.count>1&&[[urlComps objectAtIndex:0]isEqualToString:[localurlComps objectAtIndex:1]])
            {
                [self gotoAnchorInCurrentSpine:[urlComps objectAtIndex:1]];
                return NO;
            }
            else
            {
                NSArray *NewurlComps = [urlString componentsSeparatedByString:@"#"];
                
                for (int i=0; i<_NTloadedEpub.spineArray.count; i++)
                {
                    NSURL *iurl= [NSURL fileURLWithPath:[[_NTloadedEpub.spineArray objectAtIndex:i] spinePath]];
                    NSString *str=iurl.absoluteString;
                    
                    if ([str isEqualToString:[NewurlComps objectAtIndex:0]])
                    {
                        [_delegate webviewJumpWithpath:[NewurlComps objectAtIndex:1] withIndex:i];
                        return NO;
                    }
                }
            }
        }
    }
    return YES;
}

- (void) loadSpine:(int)spineIndex atPageIndex:(int)pageIndex
{
	[self loadSpine:spineIndex atPageIndex:pageIndex highlightSearchResult:nil];
}

- (void) loadSpine:(int)spineIndex atPageIndex:(int)pageIndex highlightSearchResult:(SearchResult*)theResult
{
    NSString *str=[[_NTloadedEpub.spineArray objectAtIndex:spineIndex] spinePath];
    NSURL *url;
    if (_URLAnchor)
    {
        NSURL *baseURL = [NSURL fileURLWithPath:str];
        url= [NSURL URLWithString:[NSString stringWithFormat:@"#%@", _URLAnchor] relativeToURL:baseURL];
        _isNeedJump=NO;
    }
    else
    {
        url=[NSURL fileURLWithPath:str];
        _isNeedJump=YES;
    }
	[_EpubWebView loadRequest:[NSURLRequest requestWithURL:url]];
	_currentSpineIndex = spineIndex;
}

- (void) gotoAnchorInCurrentSpine:(NSString *)anchor
{
    NSString *str=[NSString stringWithFormat:@"window.location.href = '#%@'",anchor];
    [_EpubWebView stringByEvaluatingJavaScriptFromString:str];
    _isNeedJump=YES;
//
//    [_EpubWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"request(\"%@\")",anchor]];
}

- (void) gotoLastPageInCurrentSpine
{
    int  pageIndex = _pagesInCurrentSpineCount - 1;
    
	float pageOffset = pageIndex*_EpubWebView.bounds.size.width;
    
	NSString* goToOffsetFunc = [NSString stringWithFormat:@" function pageScroll(xOffset){ window.scroll(xOffset,0); } "];
	NSString* goTo =[NSString stringWithFormat:@"pageScroll(%f)", pageOffset];
	
	[_EpubWebView stringByEvaluatingJavaScriptFromString:goToOffsetFunc];
	[_EpubWebView stringByEvaluatingJavaScriptFromString:goTo];
}



@end
