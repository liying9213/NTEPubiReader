//
//  NTPageViewController.m
//  NTEPubiReader
//
//  Created by liying on 14-5-15.
//  Copyright (c) 2014年 liying. All rights reserved.
//

#import "NTPageViewController.h"

@interface NTPageViewController ()

@end

@implementation NTPageViewController

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pageViewControllerAfterViewController:(UIPageViewController *)pageViewController
{
    [self pageViewController:pageViewController viewControllerBeforeViewController:[pageViewController.childViewControllers objectAtIndex:0]];
}




@end
