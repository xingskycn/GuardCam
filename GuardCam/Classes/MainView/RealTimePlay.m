//
//  RealTimePlay.m
//  GuardCam
//
//  Created by zhou angel on 13-10-1.
//  Copyright (c) 2013年 zhou angel. All rights reserved.
//

#import "RealTimePlay.h"
#import "AsyncSocket.h"
#import "AsyncUdpSocket.h"

#define KENTER @"\r\n"
#define KBLACK @" "
#define MAX_BUF 65535

@interface RealTimePlay ()

@end

@implementation RealTimePlay
@synthesize socket,socketUdp,serverHost,serverPort,isRtp,portClient,portServer;

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
    // Do any additional setup after loading the view from its nib.
    serverHost=@"192.168.11.6";
    serverPort=554;
    
    
    socket = [[AsyncSocket alloc] initWithDelegate:self];
    NSError *error = nil;
    if(!([socket connectToHost:serverHost onPort:serverPort error:&error]))
        NSLog(@"error:%@",error);
    else  isRtp = 0;
    socketUdp = [[AsyncUdpSocket alloc] initWithDelegate:self];
}


 #pragma mark----------------------------- udp connect 4 string --------------------------------------------
/*
 *建立连接，返回服务器对OPTIONS请求的响应
 */
-(NSMutableString*)getOptions
{
    NSMutableString* options = [[NSMutableString alloc] init];
    [options appendFormat:@"OPTIONS rtsp://%@:%d/H264 RTSP/1.0%@",serverHost,serverPort,KENTER];
    [options appendFormat:@"CSeq: 2%@",KENTER];
    [options appendFormat:@"User-Agent: LibVLC/2.0.3 (LIVE555 Streaming Media v2011.12.23)%@%@",KENTER,KENTER];
    NSLog(@"options = %@",options);
    NSData *data=[[NSData alloc]initWithBytes:[options UTF8String] length:[options lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    [self.socket writeData:data withTimeout:3 tag:1];
    NSMutableString* readString = [[NSMutableString alloc] init];
    [self.socket readDataWithTimeout:3 tag:1];
    
    return readString;
}
/*
 *建立连接，返回服务器对DESCRIBE请求的响应
 */
-(NSMutableString*)getDescribe
{
    NSMutableString* describe = [[NSMutableString alloc] init];
    
    [describe appendFormat:@"DESCRIBE rtsp://%@:%d/H264 RTSP/1.0%@",serverHost,serverPort,KENTER];
    [describe appendFormat:@"CSeq: 3%@",KENTER];
    //YWRtaW46YWRtaW4=,dXNlcjp1c2Vy，YWRtaW4=YWRtaW4=
    [describe appendFormat:@"Authorization: Basic YWRtaW46YWRtaW4=%@%@",KENTER,KENTER];
    [describe appendFormat:@"User-Agent: LibVLC/2.0.3 (LIVE555 Streaming Media v2011.12.23)%@",KENTER];
    [describe appendFormat:@"Accept: application/sdp%@%@",KENTER,KENTER];
    NSLog(@"describe = %@",describe);
    NSData *data=[[NSData alloc]initWithBytes:[describe UTF8String] length:[describe lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    [self.socket writeData:data withTimeout:3 tag:1];
    NSMutableString* readString = [[NSMutableString alloc] init];
    [self.socket readDataWithTimeout:3 tag:2];
    
    return readString;
}
/*
 *建立连接，返回通过udp连接服务器对SETUP请求的响应
 */
-(NSMutableString*)getUdpSetup
{
    NSMutableString* udpsetup = [[NSMutableString alloc] init];
    
    [udpsetup appendFormat:@"SETUP rtsp://%@/H264/ RTSP/1.0%@",serverHost,KENTER];
    [udpsetup appendFormat:@"CSeq: 4%@",KENTER];
    [udpsetup appendFormat:@"User-Agent: LibVLC/2.0.3 (LIVE555 Streaming Media v2011.12.23)%@",KENTER];
    [udpsetup appendFormat:@"Transport: RTP/AVP;unicast;client_port=7777-7778%@%@",KENTER,KENTER];
    NSLog(@"udpsetup = %@",udpsetup);
    
    [self.socket writeData:[udpsetup dataUsingEncoding:NSUTF8StringEncoding] withTimeout:3 tag:1];
    NSMutableString* readString = [[NSMutableString alloc] init];
    [self.socket readDataWithTimeout:3 tag:3];
    
    return readString;
}
/*
 *建立连接，返回通过tcp连接服务器对SETUP请求的响应
 */
-(NSMutableString*)getTcpSetup
{
    NSMutableString* tcpsetup = [[NSMutableString alloc] init];
    
    [tcpsetup appendFormat:@"SETUP rtsp://%@:%d/H264/track1 RTSP/1.0%@",serverHost,serverPort,KENTER];
    [tcpsetup appendFormat:@"CSeq: 4%@",KENTER];
    
    [tcpsetup appendFormat:@"Authorization: Basic YWRtaW46YWRtaW4=%@",KENTER];
    [tcpsetup appendFormat:@"User-Agent: LibVLC/2.0.3 (LIVE555 Streaming Media v2011.12.23)%@",KENTER];
    [tcpsetup appendFormat:@"Transport: RTP/AVP/TCP;unicast;interleaved=0-1%@%@",KENTER,KENTER];
    NSLog(@"tcpsetup = %@",tcpsetup);
    
    NSData *data=[[NSData alloc]initWithBytes:[tcpsetup UTF8String] length:[tcpsetup lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    [self.socket writeData:data withTimeout:3 tag:1];
    NSMutableString* readString = [[NSMutableString alloc] init];
    [self.socket readDataWithTimeout:3 tag:3];
    
    return readString;
}
/*
 *建立连接，返回向服务器对PLAY请求的响应
 */
-(NSMutableString*)getPlay:(NSString*)session
{
    NSMutableString* play = [[NSMutableString alloc] init];
    
    [play appendFormat:@"PLAY rtsp://%@/H264 RTSP/1.0%@",serverHost,KENTER];
    [play appendFormat:@"CSeq: 5%@",KENTER];
    [play appendFormat:@"Range: npt=0.000-%@%@",KENTER,KENTER];
    [play appendFormat:@"Session:%@%@",session,KENTER];
    [play appendFormat:@"User-Agent: LibVLC/2.0.3 (LIVE555 Streaming Media v2011.12.23)%@%@",KENTER,KENTER];
    NSLog(@"play = %@",play);
    
    NSData *data=[[NSData alloc]initWithBytes:[play UTF8String] length:[play lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    [self.socket writeData:data withTimeout:3 tag:1];
    NSMutableString* readString = [[NSMutableString alloc] init];
    [self.socket readDataWithTimeout:3 tag:4];
    
    return readString;
}
/*
 *建立连接，返回向服务器对EARDOWN请求的响应
 */
-(NSMutableString*)getTeardown:(NSString*)session
{
    NSMutableString* teardown = [[NSMutableString alloc] init];
    
    [teardown appendFormat:@"TEARDOWN rtsp://%@:%d/H264 RTSP/1.0%@",serverHost,serverPort,KENTER];
    [teardown appendFormat:@"CSeq: 5%@",KENTER];
    [teardown appendFormat:@"Session:%@%@",session,KENTER];
    [teardown appendFormat:@"User-Agent: LibVLC/2.0.3 (LIVE555 Streaming Media v2011.12.23)%@%@",KENTER,KENTER];
    
    [self.socket writeData:[teardown dataUsingEncoding:NSUTF8StringEncoding] withTimeout:3 tag:1];
    NSMutableString* readString = [[NSMutableString alloc] init];
    [self.socket readDataWithTimeout:3 tag:5];
    return readString;
}


 #pragma mark----------------------------- udp connect other --------------------------------------------

-(NSString*)getServeraddr
{
    return serverHost;
}

-(NSString*)getSession:(NSString*)info
{
    
    //从文件中再一行一行读取数据，将包含session的一行保留出来
    NSString *tmp;
    NSArray *lines; /*将文件转化为一行一行的*/
    lines = [info componentsSeparatedByString:@"\r\n"];
    
    NSEnumerator *nse = [lines objectEnumerator];
    NSString* session = [[NSString alloc] init];
    while(tmp = [nse nextObject]) {
        if ([tmp hasPrefix:@"Session:"]) {
            //tmp为包含session那一行的
            NSInteger len = @"Session:".length;
            session = [[tmp substringFromIndex:len] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSLog(@"Session:%@\n",session);
            break;
        }
    }
    
    return  session;
}
/*
 *返回RTSP回话的Content-Base
 */
- (NSString*)getContentBase:(NSString*)info
{
    //info为Describe请求所响应的信息
    NSString *tmp;
    NSArray *lines; /*将文件转化为一行一行的*/
    lines = [info componentsSeparatedByString:@"\r\n"];
    
    NSEnumerator *nse = [lines objectEnumerator];
    NSString* contentbase = [[NSString alloc] init];
    while(tmp = [nse nextObject]) {
        if ([tmp hasPrefix:@"Content-Base:"]) {
            //tmp为包含session那一行的
            NSInteger len = @"Content-Base:".length;
            contentbase = [[info substringFromIndex:len] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSLog(@"Content-Base:%@\n",contentbase);
            break;
        }
    }
    
    return  contentbase;
    
}
/*
 *返回RTSP回话的Content-Type
 */
- (NSString*)getContentType:(NSString*)info
{
    //info为Describe请求所响应的信息
    NSString *tmp;
    NSArray *lines; /*将文件转化为一行一行的*/
    lines = [info componentsSeparatedByString:@"\r\n"];
    NSEnumerator *nse = [lines objectEnumerator];
    NSString* contenttype = [[NSString alloc] init];
    while(tmp = [nse nextObject]) {
        if ([tmp hasPrefix:@"Content-Type:"]) {
            //tmp为包含session那一行的
            NSInteger len = @"Content-Type:".length;
            contenttype = [[info substringFromIndex:len] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSLog(@"CContent-Type:%@\n",contenttype);
            break;
        }
    }
    return  contenttype;
}
/*
 *返回RTSP回话的contentlength
 */
-(NSString*)getContentLength:(NSString*)info
{
    
    //info为Describe请求所响应的信息
    NSString *tmp;
    NSArray *lines; /*将文件转化为一行一行的*/
    lines = [info componentsSeparatedByString:@"\r\n"];
    
    NSEnumerator *nse = [lines objectEnumerator];
    NSString* contentlength = [[NSString alloc] init];
    while(tmp = [nse nextObject]) {
        if ([tmp hasPrefix:@"Content-Type:"]) {
            //tmp为包含session那一行的
            NSInteger len = @"Content-Type:".length;
            contentlength = [[info substringFromIndex:len] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSLog(@"CContent-Type:%@\n",contentlength);
            break;
        }
    }
    return  contentlength;
}

- (int)getclientPort:(NSString *)info
{
    NSString *tmp;
    NSArray *lines; /*将文件转化为一行一行的*/
    lines = [info componentsSeparatedByString:@"\r\n"];
    NSEnumerator *nse = [lines objectEnumerator];
    NSString* contentlength = [[NSString alloc] init];
    while(tmp = [nse nextObject]) {
        if ([tmp hasPrefix:@"Transport:"]) {
            
            contentlength = [tmp substringWithRange:NSMakeRange(39,4)];
            NSLog(@"clientport:%@\n",contentlength);
            break;
        }
    }
    return  [contentlength intValue];
}

- (int)getserverPort:(NSString *)info
{
    NSString *tmp;
    NSArray *lines; /*将文件转化为一行一行的*/
    lines = [info componentsSeparatedByString:@"\r\n"];
    NSEnumerator *nse = [lines objectEnumerator];
    NSString* contentlength = [[NSString alloc] init];
    while(tmp = [nse nextObject]) {
        if ([tmp hasPrefix:@"Transport:"]) {
            
            contentlength = [tmp substringWithRange:NSMakeRange(61,4)];
            NSLog(@"CTransport:%@\n",contentlength);
            break;
        }
    }
    return  [contentlength intValue];
}


#pragma mark---------------------------------- udp connect receive data --------------------------------------------

-(void)RecvUDPData
{
    //  severs_port = [self getPort:Info];
    //  NSLog(@"severs_port = %d",severs_port);
    NSError * error1 = nil;
    [socketUdp bindToPort:portClient error:nil];
    [self.socketUdp enableBroadcast:YES error:nil];//设置为广播
    if(error1)
    {
        NSLog(@"error1:%@",error1);
    }
    NSLog(@"start udp server");
    
    if ([socketUdp connectToHost:serverHost onPort:portServer error:nil])
    {
        [socketUdp receiveWithTimeout:-1 tag:0];//将不断接受摄像头发送的数据
    }
}
/*
 *通过主机名和端口号连接服务器
 */
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"onSocket:%p didConnectToHost:%@ port:%hu", sock, host, port);
    if(isRtp == 0)
    {
        [self getOptions];
    }
    else
    {
        NSLog(@"start tcp server");
        // [rtpTcp readDataWithTimeout:-1 tag:5];
    }
}
/*
 *向内存中写入数据
 */
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSLog(@"did read data");
    NSString *message;
    NSString* info = [[NSString alloc] init];
    switch (tag) {
        case 1:
        {
            NSLog(@"getOptions:did read data");
            
            message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"message is: \n%@",message);
            if([[message substringToIndex:15] isEqualToString:@"RTSP/1.0 200 OK"])
                [self getDescribe];
        }
            break;
        case 2:
        {
            NSLog(@"getDescribe:did read data");
            message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"message is: \n%@",message);
            if([[message substringToIndex:15] isEqualToString:@"RTSP/1.0 200 OK"])
                [self getUdpSetup];
            // else if ([[message substringToIndex:25] isEqualToString:@"RTSP/1.0 401 Unauthorized"])
            // [self getDescribe];
            // [self getDescribeAuthenticate:message];
        }
            break;
        case 3:
        {
            NSLog(@"getUdpSetup:did read data");
            message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            info = message;
            NSLog(@"message is: \n%@",message);
            NSString* session = [self getSession:info];
            portClient = [self getclientPort:info];
            portServer = [self getserverPort:info];
            NSLog(@"session=%@",session);
            [self getPlay:session];
        }
            break;
        case 4:
        {
            NSLog(@"getPlay:did read data");
            message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"message is: \n%@",message);
            [self RecvUDPData];
        }
            break;
        case 5:
        {
            NSLog(@"getTeardown:did read data");
            message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"message is: \n%@",message);
            NSString* session1 = [self getSession:message];
            [self getTeardown:session1];
        }
            break;
        default:NSLog(@"case default");
            break;
    }
}

-(int)find_head:(unsigned char *)buffer withlen:(int)len
{
    int i;
    BOOL isMatch=FALSE;
    for (i=0;i<len;i++){
        if (buffer[i] == 0 && buffer[i+1] == 0 && buffer[i+2] == 0 && buffer[i+3] == 1 && buffer[i+4]==0x67){
            isMatch=TRUE;
            break;
        }
    }
    
    return isMatch?i:-1;
}
- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"start rece rtp by udp");
    NSLog(@"length = %d ",[data length]);
    Byte *testByte = (Byte *)[data bytes];
    for(char i=12;i<[data length];i++)
    {
        printf("%02x",testByte[i]);
    }
    [socketUdp receiveWithTimeout:-1 tag:0];
    
    return YES;
}
- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"UDP is missing");
    
    socketUdp = [[AsyncUdpSocket alloc] initWithDelegate:self];
    [socketUdp bindToPort:portClient error:nil];
    [socketUdp enableBroadcast:YES error:nil];//设置为广播
    [socketUdp receiveWithTimeout:-1 tag:0];//将不断接受摄像头发送的数据
}



#pragma mark----------------------------------- ffmpeg -------------------------------------------------------


@end
