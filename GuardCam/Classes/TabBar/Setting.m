//
//  Setting.m
//  GuardCam
//
//  Created by zhou angel on 13-10-1.
//  Copyright (c) 2013年 zhou angel. All rights reserved.
//

#import "Setting.h"

@interface Setting ()

@end

@implementation Setting

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"设置";
        self.tabBarItem.image = [UIImage imageNamed:@"set.png"];
         [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"setSelect.png"] withFinishedUnselectedImage:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
