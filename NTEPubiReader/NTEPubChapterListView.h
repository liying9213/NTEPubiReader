//
//  NTEPubChapterListView.h
//  NTEPubiReader
//
//  Created by liying on 14-5-2.
//  Copyright (c) 2014年 liying. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NTEPubChapterListView;
@protocol NTEPubChapterListViewDelegate <NSObject>

@required
-(void)webviewJumpChapterWithpath:(NSString *)path;
@end


@interface NTEPubChapterListView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain) NSMutableArray *chapterArray;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, assign) id delegate;

@end
