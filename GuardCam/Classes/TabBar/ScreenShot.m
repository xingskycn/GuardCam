//
//  ScreenShot.m
//  GuardCam
//
//  Created by zhou angel on 13-10-1.
//  Copyright (c) 2013年 zhou angel. All rights reserved.
//

#import "ScreenShot.h"

@interface ScreenShot ()

@end

@implementation ScreenShot

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"截图";
        self.tabBarItem.image = [UIImage imageNamed:@"camera.png"];
         [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"cameraSelect.png"] withFinishedUnselectedImage:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tabBarItem.image = [UIImage imageNamed:@"cameraSelect.png"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
