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
#import "NTEPubChapterListView.h"
@interface NTEPubViewController : UIViewController<UIWebViewDelegate,UIScrollViewDelegate,UIPageViewControllerDataSource,NTWebViewControllerDelegate,UIGestureRecognizerDelegate,UIPageViewControllerDelegate,NTEPubChapterListViewDelegate>
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
    
    BOOL isFinishLoad;
}
@property (nonatomic, strong)NTWebViewController *NTEpubWebView;
@property (strong, nonatomic) UIPageViewController *pageController;
@property (nonatomic, strong)NTEPubChapterListView *ChapterListView;

@property (nonatomic, strong) UIWebView *EpubWebView;
- (void) loadEpub:(NSURL*) epubURL;

@end
