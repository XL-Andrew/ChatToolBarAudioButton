//
//  audioModel.h
//  ChatToolBarAudioButton
//
//  Created by Andrew on 2017/7/19.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioModel : NSObject

@property (nonatomic, retain) NSData *audioData;

@property (nonatomic, copy) NSString *duration;

@end
