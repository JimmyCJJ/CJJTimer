# CJJTimer
简单好用的定时器封装（短信、商品秒杀倒计时）(持续迭代)  
优点：高性能，自动管理内存，自动释放，高定制化，易用（支持链式语法调用）  

# 使用方法
##### 手动管理
下载demo，直接把demo里的文件夹CJJTimer拖进工程即可

##### CocoaPods管理(目前最新版本为2.0.2)
```
pod 'CJJTimer'
```

下图是demo所呈现出来的几种效果，还有更多的效果等你定制～  
![定时器效果](https://github.com/JimmyCJJ/CJJTimer/blob/master/Example/CJJTimer/Demo/Resource/demo.png)

**支持链式语法调用**
```
- (CJJTimerView *)timer{
    if(!_timer){
        CJJTimerViewConfiguration *configuration = [CJJTimerViewConfiguration configureTimerView];
        configuration.viewWidth(18)
        .viewHeight(18)
        .hiddenWhenFinished(NO)
        .lastTime([NSString stringWithFormat:@"%ld",[self getNowTimeTimeStampSec].integerValue+10])
        .cornerRadius(3)
        .backgroundColor([UIColor colorWithRed:238/255.0 green:39/255.0 blue:5/255.0 alpha:1])
        .textLabelFont([UIFont systemFontOfSize:11 weight:UIFontWeightBold])
        .textLabelColor([UIColor whiteColor])
        .colonLabelFont([UIFont systemFontOfSize:11 weight:UIFontWeightBold])
        .colonLabelColor([UIColor colorWithRed:238/255.0 green:39/255.0 blue:5/255.0 alpha:1]);

        _timer = [CJJTimerView timerViewWithConfiguration:configuration];
        _timer.delegate = self;
    }
    return _timer;
}
```

[简书地址](https://www.jianshu.com/p/38a1f6329820)
