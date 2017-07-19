# ChatToolBarAudioButton

* 导入头文件```#import "ChatToolBarAudioButton.h"```

* 添加代理 ```<ChatToolBarAudioDelegate>```

* 初始化  

``` 
ChatToolBarAudioButton *audioButton = [[ChatToolBarAudioButton alloc]init];
audioButton.delegate = self;
[self.view addSubview:audioButton];
```

* 效果图:  

![发送语音按钮.gif](http://upload-images.jianshu.io/upload_images/4842734-be6a0d21280e84b5.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/300)