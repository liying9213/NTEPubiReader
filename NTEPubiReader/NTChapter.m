//
//  NTChapter.m
//  NTEPubiReader
//
//  Created by liying on 14-5-2.
//  Copyright (c) 2014年 liying. All rights reserved.
//

#import "NTChapter.h"
#import "NSString+HTML.h"
@implementation NTChapter


@synthesize delegate, chapterIndex, title, pageCount, spinePath, text, windowSize, fontPercentSize;

- (id) initWithPath:(NSString*)theSpinePath title:(NSString*)theTitle chapterIndex:(int) theIndex{
    if((self=[super init])){
        spinePath = theSpinePath;
        title = theTitle;
        chapterIndex = theIndex;
        
//		NSString* html = [[NSString alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:theSpinePath]] encoding:NSUTF8StringEncoding];
//		text = [html stringByConvertingHTMLToPlainText];
//		html=nil;
    }
    return self;
}

- (void) loadChapterWithWindowSize:(CGRect)theWindowSize fontPercentSize:(int) theFontPercentSize{
    fontPercentSize = theFontPercentSize;
    windowSize = theWindowSize;
    UIWebView* webView = [[UIWebView alloc] initWithFrame:windowSize];
    [webView setDelegate:self];
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:spinePath]];
    [webView loadRequest:urlRequest];
    UIViewController *viewcon=delegate;
    [viewcon.view addSubview:webView];
    webView.hidden=YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"%@", error);
    [webView removeFromSuperview];
	webView=nil;
}

- (void) webViewDidFinishLoad:(UIWebView*)webView
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
	
    //	NSLog(@"w:%f h:%f", webView.bounds.size.width, webView.bounds.size.height);
	
	NSString *insertRule1 = [NSString stringWithFormat:@"addCSSRule('html', 'padding: 0px; height: %fpx; -webkit-column-gap: 0px; -webkit-column-width: %fpx;')", webView.frame.size.height, webView.frame.size.width];
	NSString *insertRule2 = [NSString stringWithFormat:@"addCSSRule('p', 'text-align: justify;')"];
	NSString *setTextSizeRule = [NSString stringWithFormat:@"addCSSRule('body', '-webkit-text-size-adjust: %d%%;')",fontPercentSize];
    
	
	[webView stringByEvaluatingJavaScriptFromString:varMySheet];
	
	[webView stringByEvaluatingJavaScriptFromString:addCSSRule];
    
	[webView stringByEvaluatingJavaScriptFromString:insertRule1];
	
	[webView stringByEvaluatingJavaScriptFromString:insertRule2];
	
    [webView stringByEvaluatingJavaScriptFromString:setTextSizeRule];
    
	int totalWidth = [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollWidth"] intValue];
	pageCount = (int)((float)totalWidth/webView.bounds.size.width);
	
    //    NSLog(@"Chapter %d: %@ -> %d pages", chapterIndex, title, pageCount);
    [webView removeFromSuperview];
    webView=nil;
    [delegate chapterDidFinishLoad:self];
    
}
-(void)dealloc
{
    NSLog(@"===dealloc %@===",self.class);
}


@end
