//
//  HMXMLTool.m
//  05-XML解析(掌握)
//
//  Created by apple on 15/9/22.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "HMXMLTool.h"
#import "HMVideo.h"

@interface HMXMLTool()<NSXMLParserDelegate>
// videos数组
@property(nonatomic,strong) NSMutableArray *videos;
/**
 *  正在解析的模型
 */
@property(nonatomic,strong) HMVideo *currentVideo;
/**
 *  用来拼接数据的字符串
 */
@property(nonatomic,strong) NSMutableString *elementString;
/**
 *  记录回调block
 */
@property(nonatomic,copy) void (^finishedBlock)(NSArray *datas);
@end

@implementation HMXMLTool

// 如果传人的block,在当前方法不执行，一定要用属性记录
+(void)parse:(NSXMLParser *)parser finished:(void (^)(NSArray *))finishedBlock{
    // 断言
    NSAssert(finishedBlock != nil, @"完成回调不能为空");
    
    
    // 创建工具类对象
    HMXMLTool *tool = [[HMXMLTool alloc] init];
    
    // 记录block
    tool.finishedBlock = finishedBlock;
    
    // 设置代理
    parser.delegate = tool;
    
    // 开始解析 -- 一旦开始解析，后续的所有解析工作由代理完成
    // 同步方法 要等代理方法解析完之后才继续往下执行，阻塞式方法
    [parser parse];
}


#pragma mark NSXMLParserDelegate 代理方法
/**
 *  1.开始解析文档
 */
- (void)parserDidStartDocument:(NSXMLParser *)parser {
    // 清空数组
    [self.videos removeAllObjects];
}

// 2.开始节点
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    // 如果是video节点，创建模型
    if([elementName isEqualToString:@"video"]) {
        // 创建模型
        self.currentVideo = [[HMVideo alloc] init];
        // 设置video id
        self.currentVideo.videoId = @([attributeDict[@"videoId"] intValue]);
    }
    // 清空字符串
    [self.elementString setString:@""];
    // 下面写法是错误的
    //    self.elementString = @"";
}

// 3.发现节点文字 可能会多调用
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    // 将节点内容拼接到字符串后面
    [self.elementString appendString:string];
}

// 4.结束节点 elementName没有反斜杠
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if ([elementName isEqualToString:@"video"]) { // video结束节点
        // 将正在解析的模型添加到数组中
        [self.videos addObject:self.currentVideo];
    } else if(![elementName isEqualToString:@"videos"]){
        // 使用kvc设置
        [self.currentVideo setValue:self.elementString forKey:elementName];
    }
}

// 5.结束解析
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    // 将解析好的数据返回给调用方
   
    dispatch_async(dispatch_get_main_queue(), ^{
        // 调用block
        self.finishedBlock(self.videos);
    });
    
}


#pragma mark - 懒加载
- (NSMutableArray *)videos {
    if (_videos == nil) {
        _videos = [NSMutableArray array];
    }
    return _videos;
}

- (NSMutableString *)elementString {
    if (_elementString == nil) {
        _elementString = [NSMutableString string];
    }
    return _elementString;
}
@end
