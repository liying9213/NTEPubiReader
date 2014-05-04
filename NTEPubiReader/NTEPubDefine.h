//
//  NTEPubDefine.h
//  NTEPubiReader
//
//  Created by liying on 14-5-2.
//  Copyright (c) 2014年 liying. All rights reserved.
//
#define iOS7 (([[[UIDevice currentDevice] systemVersion] floatValue]>=7)?YES:NO)
#define NTEPubDocuments  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]