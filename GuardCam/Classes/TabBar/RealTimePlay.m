//
//  RealTimePlay.m
//  GuardCam
//
//  Created by zhou angel on 13-10-1.
//  Copyright (c) 2013年 zhou angel. All rights reserved.
//

#import "RealTimePlay.h"

@interface RealTimePlay ()

@end

@implementation RealTimePlay

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"实时视频";
        self.tabBarItem.image = [UIImage imageNamed:@"video.png"];
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"videoSelect.png"] withFinishedUnselectedImage:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
