//
//  ChatToolBarAudioButton.m
//  XmppBlog
//
//  Created by Andrew on 2017/7/16.
//  Copyright © 2017年 lanouhn. All rights reserved.
//

#import "ChatToolBarAudioButton.h"
#import "DPAudioRecorder.h"

@interface ChatToolBarAudioButton ()
{
    BOOL isCancelSendAudioMessage;      //用户是否取消发送消息
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
        
        
        __weak typeof(self) weakSelf = self;
        //录音完成回调
        [DPAudioRecorder sharedInstance].audioRecorderFinishRecording = ^(NSData *data, NSUInteger audioTimeLength) {
            if (isCancelSendAudioMessage) {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户取消发送" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"消息发送" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                
                if ([weakSelf.delegate respondsToSelector:@selector(DPAudioRecordingFinishWithData:withBodyString:)]) {
                    [weakSelf.delegate DPAudioRecordingFinishWithData:data withBodyString:[NSString stringWithFormat:@"audio:%ld秒", audioTimeLength]];
                }               
            }
        };
        
        //录音开始回调
        [DPAudioRecorder sharedInstance].audioStartRecording = ^(BOOL isRecording) {
            if ([weakSelf.delegate respondsToSelector:@selector(DPAudioStartRecording:)]) {
                [weakSelf.delegate DPAudioStartRecording:isRecording];
            }
        };
        
        //音频值测量回调
        [DPAudioRecorder sharedInstance].audioSpeakPower = ^(float power) {
            if ([weakSelf.delegate respondsToSelector:@selector(DPAudioSpeakPower:)]) {
                [weakSelf.delegate DPAudioSpeakPower:power];
            }
        };
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
        [self audioStop];
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
}

//结束录音
- (void)audioStop
{
    [[DPAudioRecorder sharedInstance] stopRecording];
}

//录音失败
- (void)audioFailed
{
    //do something
}

@end
