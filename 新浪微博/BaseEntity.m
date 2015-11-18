//
//  BaseEntity.m
//  新浪微博
//
//  Created by bxipad on 15/10/19.
//  Copyright © 2015年 ibokan. All rights reserved.
//

#import "BaseEntity.h"
#import <UIKit/UIKit.h>
@implementation BaseEntity

- (NSURL *)headImageURL
{
    return [NSURL URLWithString:self.headImageURL_str];
}

-(NSAttributedString *)attributedStringText
{
    NSString * str = self.text;
    //把str转成attributedString类型
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]initWithString:str];
    //获取plist文件
    NSString * path = [[NSBundle mainBundle]pathForResource:@"emoticons" ofType:@"plist"];
    NSArray * arr = [NSArray arrayWithContentsOfFile:path];
    
    //创建正则匹配对象
    //正则表达式
    NSString * pattern = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    NSError * error = nil;
    NSRegularExpression * re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSArray * results = [re matchesInString:str options:NSMatchingReportProgress range:NSMakeRange(0, str.length)];
    for (int i = (int)results.count-1; i >= 0; i--)
    {
        NSTextCheckingResult * r = results[i];
        NSString * tempStr = [str substringWithRange:r.range];
        for (int j = 0 ; j < arr.count; j++)
        {
            NSDictionary * dic = arr[j];
            NSString * name = dic[@"chs"];
            if ([name isEqualToString:tempStr])
            {
                //获取图片对应的名字
                NSString * imageName = dic[@"png"];
                UIImage * image = [UIImage imageNamed:imageName];
                NSTextAttachment * attachment = [[NSTextAttachment alloc]init];
                attachment.image = image;
                NSAttributedString * attStr = [NSAttributedString attributedStringWithAttachment:attachment];
                NSLog(@"range = %@",NSStringFromRange(r.range));
                [attributedString replaceCharactersInRange:r.range withAttributedString:attStr];
                break;
            }
            
        }
    }
    return attributedString;
}


@end
