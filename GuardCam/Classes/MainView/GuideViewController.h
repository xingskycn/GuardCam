//
//  GuideViewController.h
//  GuardCam
//
//  Created by zhou angel on 13-8-6.
//  Copyright (c) 2013年 zhou angel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuideViewController : UIViewController
{
    BOOL _animating;
    UIScrollView *_pageScroll;
}

@property (nonatomic, assign) BOOL animating;
@property (nonatomic, strong) UIScrollView *pageScroll;

+ (GuideViewController *) sharedGuide;
+ (void)show;
+ (void)hide;

@end
