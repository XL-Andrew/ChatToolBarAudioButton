//
//  AmrRecorder.h
//  aaaa
//
//  Created by Andrew on 2017/7/17.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DPAudioRecorderDelegate <NSObject>

/*
 * 完成录音代理
 
 * @prarma data 返回amr格式的data数据
 */
- (void)audioRecorderDidFinishRecordingWithData:(NSData *)data;

/*
 * 音频值测量
*/
- (void)audioRecorderDidPickSpeakPower:(float)power;

@end

@interface DPAudioRecorder : NSObject

@property (nonatomic, assign) id <DPAudioRecorderDelegate> delegate;

+ (DPAudioRecorder *)sharedInstance;

- (void)startRecording;

- (void)stopRecording;

@end
