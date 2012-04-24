//
//  TDViewController.h
//  TestDownload
//
//  Created by ChenYu Xiao on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ASINetworkQueue;

@interface TDViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *buttonPause;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView1;
@property (weak, nonatomic) IBOutlet UIButton *buttonDownload;

@property (weak, nonatomic) IBOutlet UIButton *buttonDownload2;

@property (weak, nonatomic) IBOutlet UIButton *buttonPause2;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView2;

@property (weak, nonatomic) IBOutlet UIButton *buttonClear;

//@property (nonatomic, strong) ASINetworkQueue *asiNetworkQueue;

@end
