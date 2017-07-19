//
//  ViewController.m
//  ChatToolBarAudioButton
//
//  Created by Andrew on 2017/7/18.
//  Copyright © 2017年 Andrew. All rights reserved.
//

/*
 * 目录文件结构
 
 * |Recorder&Player 录音机和播放器
 * || amr_wav_converter     ----- 用于amr文件和wav文件互转
 * || DPAudioRecorder       ----- 录音机
 * || DPAudioPlayer         ----- 播放器
 
 * |Timer 定时器用于录音时长计数
 * ||JX_GCDTimerManager     ----- 定时器
 
 * |AudioButton 按钮
 * ||ChatToolBarAudioButton ----- 发送语音按钮
 */


#import "ViewController.h"
#import "ChatToolBarAudioButton.h"

@interface ViewController () <ChatToolBarAudioDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *bar = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 49, self.view.bounds.size.width, 49)];
    bar.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:bar];
    
    //发送语音按钮
    ChatToolBarAudioButton *audioButton = [[ChatToolBarAudioButton alloc]init];
    audioButton.frame = CGRectMake(50, 0, 200, 49);
    audioButton.delegate = self;
    [bar addSubview:audioButton];
}

#pragma mark - ChatToolBarAudioDelegate
- (void)sendAudioWithData:(NSData *)audioData withBodyString:(NSString *)body
{
    NSLog(@"发送amr格式的data数据%@给服务器或存储,以及消息内容,可以是音频时长",audioData);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
