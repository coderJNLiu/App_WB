//
//  commentEntity.h
//  新浪微博
//
//  Created by bxipad on 15/10/20.
//  Copyright © 2015年 ibokan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface commentEntity : NSObject
@property (strong, nonatomic) NSString * name;//用户名
@property (strong, nonatomic) NSString * commentsText;//评论内容
@property (strong, nonatomic, readonly) NSAttributedString * attributedStringCommentsText;//评论富文本内容
@property (strong, nonatomic) NSString * headImageURL_str;//头像地址字符串格式
@property (strong, nonatomic,readonly) NSURL * headImageURL;//头像地址url格式
@property (strong,nonatomic) NSString *weiboID;
@end
