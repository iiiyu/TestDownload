TestDownload
============


## 主要问题
需要请求Http协议，下载一个zip包。包比较大，希望能后台下载。退出应用再次打开的时候能接着上一次的下载。专业名称：断点续传。

## 寻找方案
iOS目前三大开源网络库

* ASIHTTPRequest
* AFNetWorking
* MKNetworkKit

个人以Google出来的信息得出的对比：

| 网络库 | 优点 | 缺点 |
| ------------ | ------------- | ------------ |
| ASIHTTPRequest | 老牌、功能强大、文档丰富  | 停止更新、新特性少、厚重 |
| AFNetWorking | github上比较火的项目、有稳定的两个主要负责人、能支持比较新的特性、一直有更新  | 文档数目一般、有些功能貌似要自己写 |
| MKNetworkKit | 支持ARC、号称要有 ASIHTTPRequest的功能，AFNetWorking的轻便 | 文档数目最少、只有作者一个主要负责人 |

在结合我是一个新新手的缘由。如果用库的话，首选ASIHTTPRequest。
候选AFNetWorking。

AFNetWorking 被Google到[这样的解决方法](https://github.com/AFNetworking/AFNetworking/pull/270).本来准备fork了。然后仔细看了看下面的讨论。

觉得自己实现一个？ [原理在这里](https://developer.apple.com/library/ios/#qa/qa1761/_index.html)

sunmmer大神给了一个不用库[实现的例子](https://developer.apple.com/library/ios/#qa/qa1761/_index.html)

后面想了想，对于网络其实我也是新手来的。自己写，未必有成熟的库写的好。所以决定使用ASIHTTPRequest。

<!--more-->

## ASIHTTPRequest

我就简单说一下ASIHTTPRequest怎么使用到自己的项目当中。

下载ASIHTTPRequest以后。我们需要用到这些文件拖入我们的项目当中(记得copy打勾)

![ios6-1](http://farm8.staticflickr.com/7106/6963897920_837ba36cdd.jpg)

然后我们需要导入

* CFNetwork.framework
* SystemConfiguration.framework
* MobileCoreServices.framework
* CoreGraphics.framework
* libz.dylib

这些framework。
至此，我们已经可以很高兴快乐的使用ASIHTTPRequest了。

## 断点续传

### 官方实现

[官方实例](http://allseeing-i.com/ASIHTTPRequest/How-to-use#resuming_interrupted_downloads)

### 民间实现

曹哥找了一个[demo](http://ryan.easymorse.com/?p=12)

ryan的这个demo对于我来说存在几个问题：

* 关闭View controller以后无法保持下载(无法保持下载的状态)
* 无法跟踪多个UIProgressView

等一些细小问题。



### 我的实现

我就在ryan这个demo的基础上改。

#### 下载持久化
解决关闭View controller以后无法保持下载(无法保持下载的状态)这个问题。

我新定义了一个类。并且把这个类定义成单例，ASINetworkQueue作为这个单例的一个property。这样一来，就不怕view controller被pop掉，被关闭的时候，ASINetworkQueue被释放掉。

定义单例的技巧，可以说是一个模板。新建一个继承NSObject的类。
主要实现一个名叫shareXXXX的类方法。XXXX就是你类的名字。比如我的这个类叫TDNetworkQueue。就要实现一个

``` objc
+ (id)sharedTDNetworkQueue;
```

而sharexxxx方法可以参照一下模板。


``` objc

+ (id)sharedxxx
{
    static dispatch_once_t pred;
    static xxx *xx = nil;
	
    dispatch_once(&pred, ^{ xx = [[self alloc] init];});
    return xx;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}
```

如果有属性初始化的话都放到init方法里面。share方法用到了一些GCD和block的东西。照搬就好。

#### 保持进度条

解决无法跟踪多个UIProgressView的问题。
为了跟踪到UIProgressView，我在单例的类里面实现了

```
// 增加下载的request进入队列
- (void)addDownloadRequestInQueue:(NSURL *)paramURL 
                     withTempPath:(NSString *)paramTempPath 
                 withDownloadPath:(NSString *)paramDownloadPath 
                 withProgressView:(UIProgressView *)paramProgressView;

// 当controller被关闭清除内存的时候，设置到delegate的view要设置为nil
- (void)clearAllRequestsDelegate;

// 当controller被关闭清除内存的时候，设置到delegate的view要设置为nil.只对一个有效果
- (void)clearOneRequestDelegateWithURL:(NSString *)paramURL;

// 恢复progressview的进度
- (void)requestsDelegateSettingWithDictonary:(NSDictionary *) paramDictonary;

```
这些方法。
值得注意的是

```
- (void)addDownloadRequestInQueue:(NSURL *)paramURL 
                     withTempPath:(NSString *)paramTempPath 
                 withDownloadPath:(NSString *)paramDownloadPath 
                 withProgressView:(UIProgressView *)paramProgressView;
```
这里的paramProgressView对应于你的请求下载的URL(request)。

```
// 恢复progressview的进度
- (void)requestsDelegateSettingWithDictonary:(NSDictionary *) paramDictonary;
```
这里的字典key是URL，object是UIProgressView。我在view controller中的viewDidLoad方法调用。


## 总结
我改写的很简单，特别的地方都在上面注明了。如果不明白就留言吧。大神们也请轻拍，我在慢慢努力中。

改写的github地址：

	git clone git://github.com/iiiyu/TestDownload.git
	
最后附送两篇队列优先级的文章

[使用NSOperationQueue简化多线程开发](http://blog.colcy.com/archives/2011/217/11/25/使用nsoperationqueue简化多线程开发/)

[队列的优先级](http://blog.colcy.com/archives/2011/222/11/25/队列的优先级/)













