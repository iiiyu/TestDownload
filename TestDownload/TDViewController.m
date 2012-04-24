//
//  TDViewController.m
//  TestDownload
//
//  Created by ChenYu Xiao on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TDViewController.h"
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"
#import "TDNetworkQueue.h"
#import "ZipArchive.h"


static NSString *test1URL = @"http://kevincao.com/download/auto-apps-review.zip";
static NSString *test2URL = @"http://pixelresort.com/downloads/safariset_mac.zip";

@interface TDViewController ()

@property (nonatomic, strong) NSMutableDictionary *urlAndProgressView;


@end

@implementation TDViewController
@synthesize buttonPause = _buttonPause;
@synthesize progressView1 = _progressView1;
@synthesize buttonDownload = _buttonDownload;
@synthesize buttonDownload2 = _buttonDownload2;
@synthesize buttonPause2 = _buttonPause2;
@synthesize progressView2 = _progressView2;
@synthesize buttonClear = _buttonClear;
@synthesize urlAndProgressView = _urlAndProgressView;
//@synthesize asiNetworkQueue = _asiNetworkQueue;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    TDNetworkQueue *tdNetworkQueue = [TDNetworkQueue sharedTDNetworkQueue];
    
    self.urlAndProgressView = [[NSMutableDictionary alloc] init];
    [self.urlAndProgressView setValue:self.progressView1 forKey:test1URL];
    [self.urlAndProgressView setValue:self.progressView2 forKey:test2URL];
    // 还原progressview的状态
    [tdNetworkQueue requestsDelegateSettingWithDictonary:self.urlAndProgressView];
}

- (void)viewDidUnload
{
    [self setButtonDownload:nil];
    [self setButtonPause:nil];
    [self setProgressView1:nil];
    [self setButtonDownload2:nil];
    [self setButtonPause2:nil];
    [self setProgressView2:nil];
    [self setButtonClear:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    TDNetworkQueue *tdNetworkQueue = [TDNetworkQueue sharedTDNetworkQueue];
    [tdNetworkQueue clearAllRequestsDelegate];
//    [tdNetworkQueue.asiNetworkQueue reset];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}



- (IBAction)downloadOneAction:(id)sender {
    TDNetworkQueue *tdNetworkQueue = [TDNetworkQueue sharedTDNetworkQueue];
    NSLog(@"创建请求1");
       //初始化Documents路径
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *downloadPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/1.zip"];
    NSString *tempPath = [path stringByAppendingPathComponent:@"1.temp"];
    NSURL *url = [NSURL URLWithString:test1URL];
    [tdNetworkQueue addDownloadRequestInQueue:url withTempPath:tempPath withDownloadPath:downloadPath withProgressView:self.progressView1];
     NSLog(@"URl:%@", [url absoluteURL]);

}


- (IBAction)downloadTwoAction:(id)sender {
    TDNetworkQueue *tdNetworkQueue = [TDNetworkQueue sharedTDNetworkQueue];
    NSLog(@"创建请求2");
    //初始化Documents路径
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *downloadPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/2.zip"];
    NSString *tempPath = [path stringByAppendingPathComponent:@"2.temp"];
    NSURL *url = [NSURL URLWithString:test2URL];
   
    [tdNetworkQueue addDownloadRequestInQueue:url withTempPath:tempPath withDownloadPath:downloadPath withProgressView:self.progressView2];
    
}

- (IBAction)buttonPauseAction:(UIButton *)sender {
    NSLog(@"%d", sender.tag);
    TDNetworkQueue *tdNetworkQuese = [TDNetworkQueue sharedTDNetworkQueue];
    switch (sender.tag) {
        case 0:
            [tdNetworkQuese pauseDownload:test1URL];
            break;
        case 1:
            [tdNetworkQuese pauseDownload:test2URL];
            break;
    }
 
}



- (IBAction)buttonUnzipAction:(id)sender {
//    NSString *downloadPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/1.zip"];
    NSString *dowloadPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/1.zip"];
    NSString *unzipPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/1"];
    ZipArchive *unzip = [[ZipArchive alloc] init];
    if ([unzip UnzipOpenFile:dowloadPath]) {
        BOOL result = [unzip UnzipFileTo:unzipPath overWrite:YES];
        if (result) {
            NSLog(@"解压成功！");
        } else {
            NSLog(@"解压失败1");

        }
        [unzip UnzipCloseFile];
    }
    else {
        NSLog(@"解压失败2");
    }



    
}




@end
