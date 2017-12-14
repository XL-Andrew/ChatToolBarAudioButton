//
//  DPAudioPlayer.m
//  AMRMedia
//
//  Created by Andrew on 2017/7/17.
//  Copyright © 2017年 prinsun. All rights reserved.
//

#import "DPAudioPlayer.h"
#import "amr_wav_converter.h"
#import "AFNetworking.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface DPAudioPlayer () <AVAudioPlayerDelegate>
{
    BOOL isPlaying;
}

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end

@implementation DPAudioPlayer

static DPAudioPlayer *playerManager = nil;
+ (DPAudioPlayer *)sharedInstance
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken,^{
        playerManager = [[DPAudioPlayer alloc] init];
    });
    return playerManager;
}

- (instancetype)init
{
    if (self) {
        //创建缓存录音文件到Tmp
        NSString *wavPlayerFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"WAVtemporaryPlayer.wav"];
        NSString *amrPlayerFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"AMRtemporaryPlayer.amr"];
        
        if (![[NSFileManager defaultManager]fileExistsAtPath:wavPlayerFilePath]) {
            [[NSData data] writeToFile:wavPlayerFilePath atomically:YES];
        }
        if (![[NSFileManager defaultManager]fileExistsAtPath:amrPlayerFilePath]) {
            [[NSData data] writeToFile:amrPlayerFilePath atomically:YES];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximityStateDidChange) name:UIDeviceProximityStateDidChangeNotification object:nil];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];

    }
    return self;
}

- (void)startPlayWithURL:(NSString *)urlStr
{
    __weak __typeof(&*self)weakSelf = self;
    [self downloadFileWithURL:urlStr parameters:@{} savedPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"AMRTemporaryRadio.amr"] downloadSuccess:^(NSURLResponse *response, NSURL *filePath) {
        NSData *data = [NSData dataWithContentsOfURL:filePath];
        [weakSelf startPlayWithData:data];
    } downloadFailure:^(NSError *error) {
        NSLog(@"");
    } downloadProgress:^(NSProgress *downloadProgress) {
        NSLog(@"总大小：%lld,当前大小:%lld",downloadProgress.totalUnitCount,downloadProgress.completedUnitCount);
    }];
}

- (void)startPlayWithData:(NSData *)data
{
    if (isPlaying) return;
    //打开红外传感器
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    //默认情况下扬声器播放
    AVAudioSessionPortOverride portOverride = AVAudioSessionPortOverrideNone;
    [[AVAudioSession sharedInstance] overrideOutputAudioPort:portOverride error:nil];
    
    self.audioPlayer = [[AVAudioPlayer alloc]initWithData:[self conversionAMRDataToWAVData:data] error:nil];
    self.audioPlayer.meteringEnabled = YES;
    self.audioPlayer.delegate = self;
    self.audioPlayer.volume = 1.0;
    self.audioPlayer.numberOfLoops = 0;
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
    
    if ([self.audioPlayer isPlaying]) {
        isPlaying = YES;
        if (self.startPlaying) {
            self.startPlaying(YES);
        }
    } else {
        isPlaying = NO;
        if (self.startPlaying) {
            self.startPlaying(NO);
        }
    }
}

- (void)stopPlaying
{
    if (!isPlaying) return;
    //关闭红外传感器
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    [self.audioPlayer stop];
    self.audioPlayer = nil;
    isPlaying = NO;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (flag) {
        [self stopPlaying];
        if (self.playComplete) {
            self.playComplete();
        }
    }
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer*)player error:(NSError *)error{
    //解码错误执行的动作
    NSLog(@"");
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    isPlaying = NO;
    [player stop];
}

//转换amr文件类型data为wav文件类型data
- (NSData *)conversionAMRDataToWAVData:(NSData *)amrData
{
    
    NSString *wavPlayerFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"WAVtemporaryPlayer.wav"];
    NSString *amrPlayerFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"AMRtemporaryPlayer.amr"];
    
    //amr的data写入文件
    [amrData writeToFile:amrPlayerFilePath atomically:YES];
    //将AMR文件转码成WAVE文件
    amr_file_to_wave_file([amrPlayerFilePath cStringUsingEncoding:NSUTF8StringEncoding],
                          [wavPlayerFilePath cStringUsingEncoding:NSUTF8StringEncoding]);

    //得到转码后wav的data
    return [NSData dataWithContentsOfFile:wavPlayerFilePath];
}

- (void)proximityStateDidChange
{
    if ([UIDevice currentDevice].proximityState) {
        NSLog(@"有物品靠近");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    } else {
        NSLog(@"有物品离开");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}

- (void)downloadFileWithURL:(NSString *)requestURLString
                 parameters:(NSDictionary *)parameters
                  savedPath:(NSString *)savedPath
            downloadSuccess:(void (^)(NSURLResponse *response, NSURL *filePath))success
            downloadFailure:(void (^)(NSError *error))failure
           downloadProgress:(void (^)(NSProgress *downloadProgress))progress

{
    
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *request = [serializer requestWithMethod:@"GET" URLString:requestURLString parameters:parameters error:nil];
    NSURLSessionDownloadTask *task = [[AFHTTPSessionManager manager] downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        progress(downloadProgress);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        if ([[NSFileManager defaultManager]fileExistsAtPath:savedPath]) {
            [[NSFileManager defaultManager]removeItemAtPath:savedPath error:nil];
        }
        return [NSURL fileURLWithPath:savedPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSString *fullPath = [NSTemporaryDirectory() stringByAppendingPathComponent:response.suggestedFilename];
        [NSURL fileURLWithPath:fullPath];
        if(error){
            failure(error);
        }else{
            success(response,filePath);
        }
    }];
    [task resume];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceProximityStateDidChangeNotification object:nil];
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
}

@end
