//
//  BaseEntity.h
//  新浪微博
//
//  Created by bxipad on 15/10/19.
//  Copyright © 2015年 ibokan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseEntity : NSObject
@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * text;
@property (strong,nonatomic,readonly) NSAttributedString *attributedStringText;
@property (strong, nonatomic) NSString * headImageURL_str;
@property (strong, nonatomic,readonly) NSURL * headImageURL;
//转发数
@property (strong,nonatomic) NSString *reposts_count;
//评论数
@property (strong,nonatomic) NSString *comments_count;
//点赞数
@property (strong,nonatomic) NSString *attitudes_count;
//微博ID
@property (strong,nonatomic) NSString *weiboID;

@end
