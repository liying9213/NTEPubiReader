//
//  NTEPub.m
//  NTEPubiReader
//
//  Created by liying on 14-5-2.
//  Copyright (c) 2014年 liying. All rights reserved.
//

#import "NTEPub.h"
#import "TouchXML.h"
#import "ZipArchive.h"
#import "NTEPubDefine.h"
#import "CXMLDocument.h"
#import "NTChapter.h"
@implementation NTEPub

-(id)initWithEPubPath:(NSString *)EPubName
{
    if((self=[super init])){
        epubFileName =EPubName;
		epubFilePath =[NSString stringWithFormat:@"%@/%@",NTEPubDocuments,EPubName];
		_spineArray = [[NSMutableArray alloc] init];
		[self parseEpub];
	}
    return self;
}
- (id) initWithEPubPath:(NSString*)EPubName WithSize:(CGRect)theWindowSize fontPercentSize:(int)FontSize
{
    if((self=[super init])){
        webViewSize=theWindowSize;
        fontSize=FontSize;
        epubFileName =EPubName;
		epubFilePath =[NSString stringWithFormat:@"%@/%@",NTEPubDocuments,EPubName];
		_spineArray = [[NSMutableArray alloc] init];
		[self parseEpub];
	}
    return self;
}

/* 解析Epub */
-(void)parseEpub
{
    [self unzipAndSaveFileNamed:epubFilePath];
    [self parseOPF:[self parseManifestPath]];
    
}

/* 解压Epub */
-(void)unzipAndSaveFileNamed:(NSString*)fileName
{
    ZipArchive* za = [[ZipArchive alloc] init];
	if( [za UnzipOpenFile:epubFilePath])
    {
		NSString *strPath=[NSString stringWithFormat:@"%@/UnzippedEpub/%@",NTEPubDocuments,epubFileName];
		NSFileManager *filemanager=[[NSFileManager alloc] init];
		if ([filemanager fileExistsAtPath:strPath])
        {
			NSError *error;
			[filemanager removeItemAtPath:strPath error:&error];
		}
		filemanager=nil;
		BOOL ret = [za UnzipFileTo:[NSString stringWithFormat:@"%@/",strPath] overWrite:YES];
		if( NO==ret )
        {
			UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Error while unzipping the epub"delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
			alert=nil;
		}
		[za UnzipCloseFile];
	}
}

/* 解析OPF */
- (void) parseOPF:(NSString*)opfPath
{
    if (opfPath==nil) {
        return;
    }
	CXMLDocument* opfFile = [[CXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:opfPath] options:0 error:nil];
	NSArray* itemsArray = [opfFile nodesForXPath:@"//opf:item" namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.idpf.org/2007/opf" forKey:@"opf"] error:nil];
    NSString* ncxFileName;
	
    NSMutableDictionary* itemDictionary = [[NSMutableDictionary alloc] init];
	for (CXMLElement* element in itemsArray)
    {
		[itemDictionary setValue:[[element attributeForName:@"href"] stringValue] forKey:[[element attributeForName:@"id"] stringValue]];
        if([[[element attributeForName:@"media-type"] stringValue] isEqualToString:@"application/x-dtbncx+xml"])
        {
            ncxFileName = [[element attributeForName:@"href"] stringValue];
        }
        if([[[element attributeForName:@"media-type"] stringValue] isEqualToString:@"application/xhtml+xml"])
        {
            ncxFileName = [[element attributeForName:@"href"] stringValue];
        }
	}
    NSInteger lastSlash = [opfPath rangeOfString:@"/" options:NSBackwardsSearch].location;
	NSString* ebookBasePath = [opfPath substringToIndex:(lastSlash +1)];
    CXMLDocument* ncxToc = [[CXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", ebookBasePath, ncxFileName]] options:0 error:nil];
    NSMutableDictionary* titleDictionary = [[NSMutableDictionary alloc] init];
    for (CXMLElement* element in itemsArray)
    {
        NSString* href = [[element attributeForName:@"href"] stringValue];
        NSString* xpath = [NSString stringWithFormat:@"//ncx:content[@src='%@']/../ncx:navLabel/ncx:text", href];
        NSArray* navPoints = [ncxToc nodesForXPath:xpath namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.daisy.org/z3986/2005/ncx/" forKey:@"ncx"] error:nil];
        if([navPoints count]!=0){
            CXMLElement* titleElement = [navPoints objectAtIndex:0];
            [titleDictionary setValue:[titleElement stringValue] forKey:href];
        }
    }
	NSArray* itemRefsArray = [opfFile nodesForXPath:@"//opf:itemref" namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.idpf.org/2007/opf" forKey:@"opf"] error:nil];
	NSMutableArray* tmpArray = [[NSMutableArray alloc] init];
    int count = 0;
	for (CXMLElement* element in itemRefsArray) {
        NSString* chapHref = [itemDictionary valueForKey:[[element attributeForName:@"idref"] stringValue]];
        
        NTChapter* tmpChapter = [[NTChapter alloc] initWithPath:[NSString stringWithFormat:@"%@%@", ebookBasePath, chapHref]
                                                      title:[titleDictionary valueForKey:chapHref]
                                               chapterIndex:count++];
//        [tmpChapter loadChapterWithWindowSize:webViewSize fontPercentSize:fontSize];
		[tmpArray addObject:tmpChapter];
	}
	_spineArray = [NSMutableArray arrayWithArray:tmpArray];
    
    
//    NSString *Thepath;
//    NSArray* itemsArray1 = [opfFile nodesForXPath:@"//opf:spine" namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.idpf.org/2007/opf" forKey:@"opf"] error:nil];
//    for (CXMLElement* element in itemsArray1)
//    {
//        NSString* chapHref2 = [itemDictionary valueForKey:[[element attributeForName:@"toc"] stringValue]];
//        Thepath=[NSString stringWithFormat:@"%@%@",_bookBasePath,chapHref2];
//    }
//    CXMLDocument* ncxToc1 = [[CXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:Thepath] options:0 error:nil];
//    
//    NSString* idpath = [NSString stringWithFormat:@"//ncx:navMap"];
//    NSArray* idPoints = [ncxToc1 nodesForXPath:idpath namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.daisy.org/z3986/2005/ncx/" forKey:@"ncx"] error:nil];
//    if (idPoints && idPoints.count != 0)
//    {
//        CXMLElement* titleElement = [idPoints objectAtIndex:0];
//        _theNavPoints = [titleElement elementsForName:@"navPoint"];
//        NSMutableArray *ary=[self GetChapterTitle:_theNavPoints];
//        [self arywithOldArray:ary];
//    }

}

- (void) parseOPFncx:(NSString*)opfPath
{
    
}

//-(NSMutableArray *)GetChapterTitle:(NSArray *)theNavPoints
//{
//    NSMutableArray *chapterArray=[[NSMutableArray alloc] init];
//    
//    for (int i = 0; i<theNavPoints.count;i++)
//    {
//        //        NSMutableDictionary *titleDictionary=[[NSMutableDictionary alloc] init];
//        EPubChapter *chapter = [[EPubChapter alloc] init];
//        CXMLElement* element = [theNavPoints objectAtIndex:i];//一个navPoint中包含的东西
//        CXMLElement* contentElement = [[element elementsForName:@"content"]objectAtIndex:0];
//        NSString *href = [[[contentElement attributes]objectAtIndex:0] stringValue];//章节地址src
//        CXMLElement *navLabel = [[element elementsForName:@"navLabel"]objectAtIndex:0];//获得navLabel节点
//        CXMLNode *textNode = [[navLabel elementsForName:@"text"]objectAtIndex:0];//获得text节点
//        [chapter setTitle:[textNode stringValue]];
//        NSString *hrefpath=[NSString stringWithUTF8String:href.UTF8String];
//        NSString *path=[NSString stringWithFormat:@"%@%@",_bookBasePath,hrefpath];
//        [chapter setSpinePath:path];
//        
//        //        [titleDictionary setValue:[textNode stringValue] forKey:@"title"];
//        //        [titleDictionary setValue:href forKey:@"src"];
//        NSArray *secondeNavPoints = [element elementsForName:@"navPoint"];
//        if (secondeNavPoints && secondeNavPoints.count!=0)
//        {
//            _theChp++;
//            //            [titleDictionary setObject:[self GetChapterTitle:secondeNavPoints] forKey:@"chirden"];
//            [chapter setChirederArray:[self GetChapterTitle:secondeNavPoints]];
//        }
//        [chapter setLayer:_theChp];
//        //        [titleDictionary setValue:[NSNumber numberWithInt:_theChp] forKey:@"layer"];
//        [chapterArray addObject:chapter];
//        chapter=nil;
//    }
//    _theChp--;
//    return chapterArray;
//}
//
//-(void )arywithOldArray:(NSMutableArray *)ary
//{
//    for (EPubChapter *dic in ary)
//    {
//        [_chapterArray addObject:dic];
//        if (dic.chirederArray&&dic.chirederArray.count>0)
//        {
//            [self arywithOldArray:dic.chirederArray];
//        }
//    }
//}

/* 获取解压后EPub路径 */
- (NSString*) parseManifestPath
{
	NSString* manifestFilePath = [NSString stringWithFormat:@"%@/UnzippedEpub/%@/META-INF/container.xml",NTEPubDocuments,epubFileName];
	NSFileManager *fileManager = [[NSFileManager alloc] init];
	if ([fileManager fileExistsAtPath:manifestFilePath])
    {
		CXMLDocument* manifestFile = [[CXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:manifestFilePath] options:0 error:nil];
		CXMLNode* opfPath = [manifestFile nodeForXPath:@"//@full-path[1]" error:nil];
		return [NSString stringWithFormat:@"%@/UnzippedEpub/%@/%@",NTEPubDocuments,epubFileName,[opfPath stringValue]];
	} else
    {
		NSLog(@"ERROR: ePub not Valid");
		return nil;
	}
    fileManager=nil;
}

@end
