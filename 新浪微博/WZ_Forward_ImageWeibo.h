//
//  WZ+Forward+ImageWeibo.h
//  新浪微博
//
//  Created by bxipad on 15/10/19.
//  Copyright © 2015年 ibokan. All rights reserved.
//

#import "BaseEntity.h"

@interface WZ_Forward_ImageWeibo : BaseEntity
@property(strong, nonatomic)NSString * retweeted_status;//被转发的原微博信息字段
@property (strong, nonatomic, readonly) NSAttributedString * attributedString_Retweeted_status;//用户转发微博富文本内容
@property (strong, nonatomic) NSString * weiboImageURL_Str;//用户发的图片地址字符串类型
@property (strong, nonatomic, readonly) NSURL * weiboImageURL;//用户发的图片地址url类型

@end
