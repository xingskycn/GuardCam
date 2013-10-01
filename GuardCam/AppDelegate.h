//
//  AppDelegate.h
//  GuardCam
//
//  Created by zhou angel on 13-8-6.
//  Copyright (c) 2013年 zhou angel. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LoginViewController;
@class RealTimePlay;
@class ScreenShot;
@class Setting;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LoginViewController *loginViewController;

@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) RealTimePlay *firstViewController;
@property (strong, nonatomic) ScreenShot *secondViewController;
@property (strong, nonatomic) Setting *thirdViewController;
-(void)pushTabBar;


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
