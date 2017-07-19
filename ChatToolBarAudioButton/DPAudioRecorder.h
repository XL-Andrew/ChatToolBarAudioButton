//
//  AmrRecorder.h
//  aaaa
//
//  Created by Andrew on 2017/7/17.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^AudioRecorderFinishRecordingBlock)(NSData *data, NSUInteger audioTimeLength);

typedef void(^AudioStartRecordingBlock)(BOOL isRecording);

typedef void(^AudioSpeakPowerBlock)(float power);

@interface DPAudioRecorder : NSObject

@property (nonatomic, copy) AudioRecorderFinishRecordingBlock audioRecorderFinishRecording;  //播放完成回调

@property (nonatomic, copy) AudioStartRecordingBlock audioStartRecording;                    //开始播放回调

@property (nonatomic, copy) AudioSpeakPowerBlock audioSpeakPower;                            //音频值测量回调

+ (DPAudioRecorder *)sharedInstance;

- (void)startRecording;

- (void)stopRecording;

@end
