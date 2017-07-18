//
//  ChatToolBarAudioButton.h
//  XmppBlog
//
//  Created by Andrew on 2017/7/16.
//  Copyright © 2017年 lanouhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChatToolBarAudioDelegate <NSObject>

- (void)sendAudioWithData:(NSData *)audioData withBodyString:(NSString *)body;

@end

@interface ChatToolBarAudioButton : UIButton

@property (nonatomic, assign) id <ChatToolBarAudioDelegate> delegate;

@end
