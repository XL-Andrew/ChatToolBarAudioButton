//
//  ChatToolBarAudioButton.h
//  XmppBlog
//
//  Created by Andrew on 2017/7/16.
//  Copyright © 2017年 lanouhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChatToolBarAudioDelegate <NSObject>

/*
 * 录音完成代理方法
 * 
 * @param audioData amr文件data
 * @prram body      附带信息,比如录音时长等信息
 */

- (void)sendAudioWithData:(NSData *)audioData withBodyString:(NSString *)body;

@end

@interface ChatToolBarAudioButton : UIButton

@property (nonatomic, assign) id <ChatToolBarAudioDelegate> delegate;

@end
