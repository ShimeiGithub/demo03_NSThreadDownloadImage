//
//  ViewController.m
//  demo03_NSThreadDownloadImage
//
//  Created by LuoShimei on 16/5/11.
//  Copyright © 2016年 罗仕镁. All rights reserved.
//
//
/**
    运行程序后发现控制台输出这样的提示：
 
    App Transport Security has blocked a cleartext HTTP (http://) resource load since it is insecure. 
    Temporary exceptions can be configured via your app's Info.plist file.
    意思是 应用传输安全性已阻止明文HTTP（HTTP：//）资源负载，因为它是不安全的。临时的异常可以通过应用程序的Info.plist文件进行配置。
 
    原因和处理方法：
    Xcode7以后，apple公司对网络地址请求有严格的要求
    网络地址请求分为两种协议http和https。然而apple公司规定必须使用https的方式请求
    所以需要在info.plist文件中添加：字典类型的 NSAppTransportSecurity，其中有个bool类型的key是 
    NSAllowsArbitraryLoads 的值是 YES
 */

#import "ViewController.h"

@interface ViewController ()
/** 显示图片的控件 */
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/** 创建线程对象 */
@property(nonatomic,strong) NSThread *thread;

@end

@implementation ViewController
#pragma mark======懒加载=======
- (NSThread *)thread{
    if (_thread == nil) {
        _thread = [[NSThread alloc] initWithTarget:self selector:@selector(download) object:nil];
    }
    return _thread;
}

/** 点击下载图片按钮 */
- (IBAction)clickDownloadImageButton:(id)sender {
    //开启一个线程需要判断这个线程是否已经执行完毕或者是否正在执行
    if (self.thread.executing | self.thread.isFinished) {
        //线程已经执行完毕，或者线程不在执行
        self.thread = nil;
    }
    
    //启动线程
    [self.thread start];
}

/** 下载操作 放于子线程中执行 */
- (void)download{
    //创建需要下载的图片的路劲
    NSString *imagePath = @"http://d.hiphotos.baidu.com/image/pic/item/8cb1cb13495409232ed9fac69058d109b2de49d2.jpg";
    
    NSURL *url = [NSURL URLWithString:imagePath];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    UIImage *image = [UIImage imageWithData:data];
    
    //将图片的刷新操作放到主线程中
    [self performSelectorOnMainThread:@selector(refreshImageView:) withObject:image waitUntilDone:NO];
    
}

/** 将下载好的图片刷新到imageView上 */
- (void)refreshImageView:(UIImage *)image{
    self.imageView.image = image;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
