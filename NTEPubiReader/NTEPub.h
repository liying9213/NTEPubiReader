//
//  NTEPub.h
//  NTEPubiReader
//
//  Created by liying on 14-5-2.
//  Copyright (c) 2014年 liying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NTEPub : NSObject
{
    NSString* epubFilePath;
    NSString* epubFileName;
    NSInteger fontSize;
    CGRect webViewSize;
    NSMutableDictionary *_NTitemDictionary;
    NSString *_NTbookBasePath;
}

@property(nonatomic, strong) NSMutableArray* spineArray;
@property(nonatomic) NSInteger theChp;
@property(nonatomic, retain) NSMutableArray* chapterArray;
- (id) initWithEPubPath:(NSString*)EPubName;
- (id) initWithEPubPath:(NSString*)EPubName WithSize:(CGRect)theWindowSize fontPercentSize:(int)FontSize;

@end
