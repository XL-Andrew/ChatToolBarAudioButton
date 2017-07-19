//
//  ChatToolBarAudioButton.m
//  XmppBlog
//
//  Created by Andrew on 2017/7/16.
//  Copyright © 2017年 lanouhn. All rights reserved.
//

#import "ChatToolBarAudioButton.h"
#import "JX_GCDTimerManager.h"
#import "DPAudioRecorder.h"

#define TimerName @"audioTimer_999"

@interface ChatToolBarAudioButton () <DPAudioRecorderDelegate>
{
    BOOL isCancelSendAudioMessage;      //用户是否取消发送消息
    NSUInteger __block audioTimeLength; //录音时长
}

@end

@implementation ChatToolBarAudioButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.layer.cornerRadius = 4;
        self.clipsToBounds = YES;
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitle:@"按住 说话" forState:UIControlStateNormal];
        [self setTitle:@"松开 结束" forState:UIControlStateHighlighted];
        [self setBackgroundImage:[UIImage imageNamed:@"chatBar_recordBg"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"chatBar_recordSelectedBg"] forState:UIControlStateHighlighted];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        longPress.minimumPressDuration = 0;
        [self addGestureRecognizer:longPress];
        
        [DPAudioRecorder sharedInstance].delegate = self;

    }
    return self;
}

- (void)longPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:self];
    
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self setTitle:@"松开 结束" forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"chatBar_recordSelectedBg"] forState:UIControlStateNormal];
        [self audioStart];
    } else if(gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self setTitle:@"按住 说话" forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"chatBar_recordBg"] forState:UIControlStateNormal];
        if (isCancelSendAudioMessage) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户取消发送" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            [self audioFailed];
        } else {
            [[DPAudioRecorder sharedInstance] stopRecording];
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"消息发送" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    } else if(gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        if ([self.layer containsPoint:point]) {
            [self setTitle:@"松开 结束" forState:UIControlStateNormal];
            isCancelSendAudioMessage = NO;
        } else {
            [self setTitle:@"松开 取消" forState:UIControlStateNormal];
            isCancelSendAudioMessage = YES;
        }
    } else if (gestureRecognizer.state == UIGestureRecognizerStateFailed) {
        NSLog(@"失败");
    } else if (gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        NSLog(@"取消");
    }
}

- (void)audioStart
{
    //开始录音
    [[DPAudioRecorder sharedInstance] startRecording];
    
    //录音时长
    audioTimeLength = 0;
    
    [[JX_GCDTimerManager sharedInstance]scheduledDispatchTimerWithName:TimerName timeInterval:1 queue:nil repeats:YES actionOption:AbandonPreviousAction action:^{
        audioTimeLength ++;
        if (audioTimeLength >= 60) { //大于等于60秒停止
            [[DPAudioRecorder sharedInstance] stopRecording];
        }
    }];
}

//完成录音
- (void)audioRecorderDidFinishRecordingWithData:(NSData *)data
{
    [[JX_GCDTimerManager sharedInstance]cancelAllTimer]; //定时器停止
    if (audioTimeLength > 1) {
        if ([self.delegate respondsToSelector:@selector(sendAudioWithData:withBodyString:)]) {
            [self.delegate sendAudioWithData:data withBodyString:[NSString stringWithFormat:@"audio:%ld", audioTimeLength]];
        }
    } else {
        NSLog(@"时间短于一秒");
    }
}

- (void)audioRecorderDidPickSpeakPower:(float)power
{
//    NSLog(@"当前音量值是%f",power);
}

- (void)audioFailed
{
    [[DPAudioRecorder sharedInstance] stopRecording];
    [[JX_GCDTimerManager sharedInstance] cancelAllTimer];//定时器停止
}



@end
