//
//  WZ+ForwardWeibo.h
//  新浪微博
//
//  Created by bxipad on 15/10/19.
//  Copyright © 2015年 ibokan. All rights reserved.
//

#import "BaseEntity.h"

@interface WZ_ForwardWeibo : BaseEntity
@property (strong, nonatomic) NSString * retweeted_status;//被转发的原微博信息字段
@property (strong, nonatomic, readonly) NSAttributedString * attributedString_Retweeted_status;//用户转发微博富文本内容

@end
