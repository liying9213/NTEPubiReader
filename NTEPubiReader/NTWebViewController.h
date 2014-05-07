//
//  NTWebViewController.h
//  NTEPubiReader
//
//  Created by liying on 14-5-4.
//  Copyright (c) 2014年 liying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTEPub.h"
@class NTWebViewController;
@protocol NTWebViewControllerDelegate <NSObject>

@required
-(void)webViewFinishLoadWithpagesInCurrentSpine:(int)Index;
-(void)webviewJumpWithpath:(NSString *)path withIndex:(int)index;
@end


@interface NTWebViewController : UIViewController<UIWebViewDelegate,UIScrollViewDelegate>
@property (nonatomic, assign) id delegate;
@property (nonatomic, strong) UIWebView *EpubWebView;
@property (nonatomic) int currentSpineIndex;
@property (nonatomic) int pagesInCurrentSpineCount;
@property (nonatomic) int currentTextSize;
@property (nonatomic) int totalPagesCount;
@property (nonatomic) BOOL epubLoaded;
@property (nonatomic) BOOL paginating;
@property (nonatomic) BOOL searching;
@property (nonatomic,strong) NSString *URLAnchor;
@property (nonatomic) BOOL isNeedJump;
@property (nonatomic) BOOL isNeedLastPage;

@property (nonatomic, strong) NTEPub* NTloadedEpub;
- (void) gotoPageInCurrentSpine:(int)pageIndex;
- (void) loadSpine:(int)spineIndex atPageIndex:(int)pageIndex;
@end
