//
//  ViewController.m
//  13-AFN演练
//
//  Created by apple on 15/9/29.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "HMXMLTool.h"
#import "NSString+Base64.h"
@interface ViewController ()
@property(nonatomic,strong) NSProgress *progress;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self test];
//    [self upload];
//    [self download];
}

- (void)download{
    // 获得会话管理器
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // request
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost/001.mp4"]];
    
    // 进度对象
    NSProgress *progress = nil;
    [[manager downloadTaskWithRequest:request progress:&progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        // 指定下载文件保存的路径
        // 下载到沙盒doc目录下
        //hahahah
       NSURL *docUrl =  [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:NULL create:YES error:NULL];
        NSLog(@"docUrl = %@",docUrl);
        return [docUrl URLByAppendingPathComponent:response.suggestedFilename];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"filePath = %@",filePath);
    }] resume];
    
    // 使用kvo
    [progress addObserver:self forKeyPath:@"completedUnitCount" options:0 context:nil];
    self.progress = progress;
    NSLog(@"progress = %@",progress);
}


- (void)dealloc {
    // 移除kvo
    [self.progress removeObserver:self forKeyPath:@"completedUnitCount"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//    NSLog(@"object = %@",object);
    if ([object isKindOfClass:[NSProgress class]]) {
        // 获得进度
        NSProgress *progress = (NSProgress *) object;
//        NSLog(@"%lld--%lld",progress.completedUnitCount,progress.totalUnitCount);
        // 获得进度百分比
        NSLog(@"%f",progress.fractionCompleted);
//        NSLog(@"%@",progress.localizedDescription);
    }
}

/**
 *  上传文件
 */
- (void)upload{
    AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
    
    [manage POST:@"http://localhost/post/upload.php" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // 要上传的文件url
        NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"ab.png" withExtension:nil];
        // name:服务器接收文件信息字段名
//        [formData appendPartWithFileURL:fileUrl name:@"userfile" error:NULL];
        [formData appendPartWithFileURL:fileUrl name:@"userfile" fileName:@"xxx.png" mimeType:@"image/png" error:NULL];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
    }];
}
//
- (void)test{
    // 获得会话管理器
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // request
    NSURL *url = [NSURL URLWithString:@"http://192.168.35.8/uploads/ab.png"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 设置请求方法
    request.HTTPMethod = @"PUT";
    // 设置身份验证
    [request setValue:[self authorString] forHTTPHeaderField:@"authorization"]; //authorization
    // 设置ContentType
    //    [request setValue:@"multipart/form-data; boundary=xx" forHTTPHeaderField:@"Content-Type"];
    // 要上传的文件url
    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"ab.png" withExtension:nil];
    // 上传
    [[manager uploadTaskWithRequest:request fromFile:fileUrl progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        NSLog(@"responseObject = %@,response = %@",responseObject,response);
    }] resume];
}
- (NSString *)authorString{
    return [@"admin:123456" basicAuthString];
}
@end
