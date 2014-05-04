//
//  NTEPubListViewController.m
//  NTEPubiReader
//
//  Created by liying on 14-5-2.
//  Copyright (c) 2014年 liying. All rights reserved.
//

#import "NTEPubListViewController.h"
#import "NTEPubDefine.h"
#import "NTEPubViewController.h"
@interface NTEPubListViewController ()

@end

@implementation NTEPubListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self ResetNav];
    [self ResetView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)ResetNav
{
    NSString *headImgStr;
    if (iOS7)
    {
        headImgStr= @"bg_header_content_2.png";
    }
    else
        headImgStr=@"bg_header_content_1.png";
    UIImage * headImg = [UIImage imageNamed:headImgStr];
    [[self.navigationController navigationBar] setBackgroundImage:headImg forBarMetrics:UIBarMetricsDefault];
}

-(void)ResetView
{
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor=[UIColor lightGrayColor];
    button.frame=CGRectMake(120, 150, 50, 30);
    [button addTarget:self action:@selector(readBook) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)readBook
{
    NSFileManager *file=[[NSFileManager alloc]init];
//    [file copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"呼吸机临床应用快速解读" ofType:@"epub"] toPath:[NSString stringWithFormat:@"%@/呼吸机临床应用快速解读.epub",NTEPubDocuments] error:nil];
    [file copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"机械制造基础" ofType:@"epub"] toPath:[NSString stringWithFormat:@"%@/机械制造基础.epub",NTEPubDocuments] error:nil];
    NSLog(@"===%@",NTEPubDocuments);
    NTEPubViewController *viewController=[[NTEPubViewController alloc] init];
//    [viewController loadEpub:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
