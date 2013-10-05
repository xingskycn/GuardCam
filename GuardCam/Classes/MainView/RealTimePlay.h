//
//  RealTimePlay.h
//  GuardCam
//
//  Created by zhou angel on 13-10-1.
//  Copyright (c) 2013年 zhou angel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncSocket.h"
#import "AsyncUdpSocket.h"

@interface RealTimePlay : UIViewController

@property (nonatomic,retain) AsyncSocket *socket;
@property (nonatomic,retain) AsyncUdpSocket *socketUdp;
@property (nonatomic,retain) NSString *serverHost;
@property (nonatomic,assign) int serverPort,portServer,portClient;
@property (nonatomic,assign) int isRtp;

@end
