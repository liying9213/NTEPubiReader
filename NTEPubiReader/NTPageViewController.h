//
//  NTPageViewController.h
//  NTEPubiReader
//
//  Created by liying on 14-5-15.
//  Copyright (c) 2014年 liying. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class NTPageViewController;
//@protocol NTPageViewControllerDelegate <NSObject>
//
//@required
//- (void)BeforeAndAfterViewController;
//
//@end



@interface NTPageViewController : UIPageViewController<UIPageViewControllerDataSource,UIPageViewControllerDelegate>
- (void)pageViewControllerAfterViewController:(UIPageViewController *)pageViewController;
@end
