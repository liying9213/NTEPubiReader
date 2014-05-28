//
//  NTChapter.h
//  NTEPubiReader
//
//  Created by liying on 14-5-2.
//  Copyright (c) 2014年 liying. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NTChapter;

@protocol NTChapterDelegate <NSObject>
@required
- (void) chapterDidFinishLoad:(NTChapter*)chapter;
@end


@interface NTChapter : NSObject<UIWebViewDelegate>{
    NSString* spinePath;
    NSString* title;
	NSString* text;
//    id <ChapterDelegate> idelegate;
    int pageCount;
    int chapterIndex;
    CGRect windowSize;
    int fontPercentSize;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, readonly) int pageCount, chapterIndex, fontPercentSize;
//@property (nonatomic, readonly) NSString *spinePath, *title, *text;
@property (nonatomic, readonly) CGRect windowSize;
@property (nonatomic, strong) NSString  *title;
@property (nonatomic, strong) NSString  *spinePath;
@property (nonatomic, strong) NSMutableArray  *chirederArray;
@property (nonatomic) NSInteger  layer;
@property (nonatomic, assign) NSInteger spineIndex;


- (id) initWithPath:(NSString*)theSpinePath title:(NSString*)theTitle chapterIndex:(int) theIndex;

- (void) loadChapterWithWindowSize:(CGRect)theWindowSize fontPercentSize:(int) theFontPercentSize;

@end
