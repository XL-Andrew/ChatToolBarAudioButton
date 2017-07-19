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
#import "DPAudioPlayer.h"
#import "AudioModel.h"

@interface ViewController () <ChatToolBarAudioDelegate, UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *dataSource;
    UITableView *myTableView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataSource = [NSMutableArray array];
    
    UIView *bar = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 49, self.view.bounds.size.width, 49)];
    bar.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:bar];
    
    //发送语音按钮
    ChatToolBarAudioButton *audioButton = [[ChatToolBarAudioButton alloc]init];
    audioButton.frame = CGRectMake(50, 0, 200, 49);
    audioButton.delegate = self;
    [bar addSubview:audioButton];
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height - 69)];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
    
}

#pragma mark - ChatToolBarAudioDelegate
- (void)sendAudioWithData:(NSData *)audioData withBodyString:(NSString *)body
{
    AudioModel *model = [[AudioModel alloc]init];
    model.audioData = audioData;
    model.duration = body;
    [dataSource addObject:model];
    [myTableView reloadData];
    NSLog(@"发送amr格式的data数据%@给服务器或存储,以及消息内容,可以是音频时长",audioData);
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AudioModel *model = [dataSource objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = model.duration;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AudioModel *model = [dataSource objectAtIndex:indexPath.row];
    [[DPAudioPlayer sharedInstance] startPlayWithData:model.audioData];
    [DPAudioPlayer sharedInstance].finished = ^{
        NSLog(@"播放完成");
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
