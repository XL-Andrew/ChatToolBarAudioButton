//
//  ChatToolBarAudioButton.h
//  XmppBlog
//
//  Created by Andrew on 2017/7/16.
//  Copyright © 2017年 lanouhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DPChatToolBarAudioDelegate <NSObject>

/*
 * 录音完成代理方法
 * 
 * @param audioData amr文件data
 * @prram body      附带信息,比如录音时长等信息
 */
- (void)DPAudioRecordingFinishWithData:(NSData *)audioData withBodyString:(NSString *)body;

/*
 * 开始录音代理方法
 *
 * @param isRecording 是否开始
 *
 */
- (void)DPAudioStartRecording:(BOOL)isRecording;

/*
 * 音频值测量回调
 *
 * @param power 音频值
 */
- (void)DPAudioSpeakPower:(float)power;

@end

@interface ChatToolBarAudioButton : UIButton

@property (nonatomic, assign) id <DPChatToolBarAudioDelegate> delegate;

@end
