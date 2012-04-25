//
//  TDNetworkQueue.m
//  TestDownload
//
//  Created by ChenYu Xiao on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TDNetworkQueue.h"
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"


@interface TDNetworkQueue() <ASIHTTPRequestDelegate>

@end


@implementation TDNetworkQueue 

@synthesize asiNetworkQueue = _asiNettworkQueue;
@synthesize requestArray = _requestArray;

+ (id)sharedTDNetworkQueue
{
    static dispatch_once_t pred;
    static TDNetworkQueue * tdNetworkQueue= nil;
	
    dispatch_once(&pred, ^{ tdNetworkQueue = [[self alloc] init];});
    return tdNetworkQueue;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.asiNetworkQueue = [[ASINetworkQueue alloc] init];
        [self.asiNetworkQueue setShowAccurateProgress:YES];
        [self.asiNetworkQueue go];
        
        self.requestArray = [[NSMutableArray alloc] init];
        
    }
    return self;
}

- (void)addDownloadRequestInQueue:(NSURL *)paramURL 
                     withTempPath:(NSString *)paramTempPath 
                 withDownloadPath:(NSString *)paramDownloadPath 
                 withProgressView:(UIProgressView *)paramProgressView
{
    //创建请求
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:paramURL];
    request.delegate = self;//代理
    [request setDownloadDestinationPath:paramDownloadPath];//下载路径
    [request setTemporaryFileDownloadPath:paramTempPath];//缓存路径
    [request setAllowResumeForFileDownloads:YES];//断点续传
    request.downloadProgressDelegate = paramProgressView;
    [self.asiNetworkQueue addOperation:request];//添加到队列，队列启动后不需重新启动
    if ([[NSFileManager defaultManager] fileExistsAtPath:paramTempPath]) {
        NSLog(@"有了");
    }
    else {
        NSLog(@"没有");
    }
}

- (void)clearAllRequestsDelegate
{
    for (ASIHTTPRequest *request in self.requestArray) {
        [request setDownloadProgressDelegate:nil];
    }
    
}


- (void)clearOneRequestDelegateWithURL:(NSString *)paramURL
{
    for (ASIHTTPRequest *request in self.requestArray) {
        if ([[request.url absoluteString] isEqualToString:paramURL]) {
            [request setDownloadProgressDelegate:nil];
        }
    }
    
}

- (void)requestsDelegateSettingWithDictonary:(NSDictionary *) paramDictonary
{
    for (ASIHTTPRequest *request in self.requestArray) {
        for (id key in paramDictonary)
        {
            if ([[request.url absoluteString] isEqualToString:(NSString *)key]) {
                [request setDownloadProgressDelegate:[paramDictonary objectForKey:key]];
            }
        }
    }
}

- (void)pauseDownload:(NSString *)paramPauseURL
{
    for (ASIHTTPRequest *request in self.requestArray) {
        if ([[request.url absoluteString] isEqualToString:paramPauseURL]) {
            // 取消请求
            [request clearDelegatesAndCancel];
            [self.requestArray removeObject:request];
        }
    }
    
}



#pragma mark ASIHTTPRequestDelegate

- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    NSLog(@"收到头部！");
    NSLog(@"%f",request.contentLength/1024.0/1024.0);
    NSLog(@"%@",responseHeaders);

}



- (void)requestStarted:(ASIHTTPRequest *)request
{
    NSLog(@"下载开始！");
    [self.requestArray addObject:request];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"下载成功！");

    for (ASIHTTPRequest *aRequest in self.requestArray) {
        NSLog(@"sURL:%@", [aRequest.url absoluteString]);
        if ([[aRequest.url absoluteString] isEqualToString:[request.url absoluteString]]) {
            [self.requestArray removeObject:request];
        }
    }
    
    for (ASIHTTPRequest *aRequest in self.requestArray) {
        NSLog(@"sURL:%@", [aRequest.url absoluteString]);
    }

    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"下载失败！");
    for (ASIHTTPRequest *aRequest in self.requestArray) {
        if ([[aRequest.url absoluteString] isEqualToString:[request.url absoluteString]]) {
            [self.requestArray removeObject:request];
        }
    }

}

- (void)dealloc
{
    
    [super dealloc];
}




@end
