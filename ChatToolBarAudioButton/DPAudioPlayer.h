//
//  DPAudioPlayer.h
//  AMRMedia
//
//  Created by Andrew on 2017/7/17.
//  Copyright © 2017年 prinsun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^PlayCompleteBlock)();

typedef void(^StartPlayingBlock)(BOOL isPlaying);

@interface DPAudioPlayer : NSObject

@property (nonatomic, copy) PlayCompleteBlock playComplete;

@property (nonatomic, copy) StartPlayingBlock startPlaying;

+ (DPAudioPlayer *)sharedInstance;

- (void)startPlayWithData:(NSData *)data;

- (void)stopPlaying;

@end
