//
//  NTEPubChapterListView.m
//  NTEPubiReader
//
//  Created by liying on 14-5-2.
//  Copyright (c) 2014年 liying. All rights reserved.
//

#import "NTEPubChapterListView.h"
#import "NTChapter.h"
@implementation NTEPubChapterListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self ResetView];
        // Initialization code
    }
    return self;
}

-(void)ResetView
{
    _tableView=[[UITableView alloc] initWithFrame:self.frame style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor whiteColor];
    _tableView.rowHeight=50;
    [self addSubview:_tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _chapterArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    static NSString * _cellIdentify = @"CellIdentify";
    UITableViewCell * _cell = [tableView  dequeueReusableCellWithIdentifier:_cellIdentify];
    if (_cell == nil)
    {
        _cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_cellIdentify];
        
        UILabel *NTTitleLabel=[[UILabel alloc] init];
        NTTitleLabel.font=[UIFont systemFontOfSize:13];
        NTTitleLabel.backgroundColor=[UIColor clearColor];
        NTTitleLabel.tag=1024;
        [_cell.contentView addSubview:NTTitleLabel];
    }
    
    
    return _cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel * _titleLabel = (UILabel *)[cell.contentView viewWithTag:1024];
    NTChapter *chapter=(NTChapter *)[_chapterArray objectAtIndex:indexPath.row];
    _titleLabel.text=chapter.title;
    _titleLabel.frame=CGRectMake(chapter.layer*15+10, 0, 300-chapter.layer*15, 50);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_delegate webviewJumpChapterWithpath:[(NTChapter *)[_chapterArray objectAtIndex:indexPath.row] spinePath]];
}





@end
