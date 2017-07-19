//
//  ChatToolBarAudioButton.h
//  XmppBlog
//
//  Created by Andrew on 2017/7/16.
//  Copyright © 2017年 lanouhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DPChatToolBarAudioDelegate <NSObject>

@required
/*
 * 录音完成
 *
 * @param audioData amr文件data
 * @prram body      附带信息,比如录音时长等信息
 */
- (void)DPAudioRecordingFinishWithData:(NSData *)audioData withBodyString:(NSString *)body;

@optional

/*
 * 开始录音
 *
 * @param isRecording 是否开始
 *
 */
- (void)DPAudioStartRecording:(BOOL)isRecording;

/*
 * 录音失败
 */
- (void)DPAudioRecordingFail:(NSString *)reason;

/*
 * 音频值测量
 *
 * @param power 音频值
 */
- (void)DPAudioSpeakPower:(float)power;

@end

@interface ChatToolBarAudioButton : UIButton

@property (nonatomic, assign) id <DPChatToolBarAudioDelegate> delegate;

@end
