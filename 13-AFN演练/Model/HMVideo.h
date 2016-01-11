#import <Foundation/Foundation.h>

@interface HMVideo : NSObject
/**
 *  视频 id
 */
@property (nonatomic, copy) NSNumber *videoId;
/**
 *  视频名称
 */
@property (nonatomic, copy) NSString *name;
/**
 *  视频长度
 */
@property (nonatomic, copy) NSNumber *length;
/**
 *  视频路径
 */
@property (nonatomic, copy) NSString *videoURL;
/**
 *  图片路径
 */
@property (nonatomic, copy) NSString *imageURL;
/**
 *  视频描述
 */
@property (nonatomic, copy) NSString *desc;
/**
 *  老师
 */
@property (nonatomic, copy) NSString *teacher;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)videoWithDict:(NSDictionary *)dict;

@end
