//
//  HMXMLTool.h
//  05-XML解析(掌握)
//
//  Created by apple on 15/9/22.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMXMLTool : NSObject

+(void)parse:(NSXMLParser *)parser finished:(void (^)(NSArray *))finishedBlock;
@end
