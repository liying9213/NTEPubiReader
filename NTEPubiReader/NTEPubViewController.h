//
//  NTEPubViewController.h
//  NTEPubiReader
//
//  Created by liying on 14-5-2.
//  Copyright (c) 2014年 liying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTEPub.h"
#import "NTChapter.h"
#import "NTWebViewController.h"
@interface NTEPubViewController : UIViewController<UIWebViewDelegate,UIScrollViewDelegate,NTChapterDelegate,UIPageViewControllerDataSource,NTWebViewControllerDelegate>
{
    NTEPub* loadedEpub;
	int currentSpineIndex;
	int currentPageInSpineIndex;
	int pagesInCurrentSpineCount;
	int currentTextSize;
	int totalPagesCount;
    
    BOOL epubLoaded;
    BOOL paginating;
    BOOL searching;
}
@property (nonatomic, strong)NTWebViewController *NTEpubWebView;
@property (strong, nonatomic) UIPageViewController *pageController;

@property (nonatomic, strong) UIWebView *EpubWebView;
- (void) loadEpub:(NSURL*) epubURL;

@end
