# ChatToolBarAudioButton

* 导入头文件

```#import "ChatToolBarAudioButton.h"```

* 添加代理 

```<ChatToolBarAudioDelegate>```

* 初始化  

``` 
ChatToolBarAudioButton *audioButton = [[ChatToolBarAudioButton alloc]init];
audioButton.delegate = self;
[self.view addSubview:audioButton];
```

* 代理方法

```
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
```

* 效果图:  

![发送语音按钮.gif](http://upload-images.jianshu.io/upload_images/4842734-3e20efd1cdd09805.gif?imageMogr2/auto-orient/strip)