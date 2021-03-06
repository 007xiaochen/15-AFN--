
//  02-Put上传
//
//  Created by pkxing on 15/09/28.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Base64)

/**
 返回base64编码的字符串内容
 */
- (NSString *)base64encode;

/**
 返回base64解码的字符串内容
 */
- (NSString *)base64decode;

/**
 返回服务器基本授权字符串
 
 示例代码格式如下：
 
 @code
 [request setValue:[@"admin:123456" basicAuthString] forHTTPHeaderField:@"Authorization"];
 @endcode
 */
- (NSString *)basicAuthString;

@end
