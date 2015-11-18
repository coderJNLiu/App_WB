//
//  WeiboManager.m
//  新浪微博
//
//  Created by bxipad on 15/10/19.
//  Copyright © 2015年 ibokan. All rights reserved.
//

#import "WeiboManager.h"
#import "AFNetworking.h"
#import "WZWeibo.h"
#import "TPWeibo.h"
#import "WZ_ForwardWeibo.h"
#import "WZ_Forward_ImageWeibo.h"
#import "commentEntity.h"
#import "KCAnnotation.h"
@interface WeiboManager ()
@property (strong,nonatomic) AFHTTPRequestOperationManager *afManager;
@end
@implementation WeiboManager

+ (instancetype)shareWeiboManager
{
    static WeiboManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[WeiboManager alloc]init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.afManager = [[AFHTTPRequestOperationManager alloc]init];
        self.afManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return self;
}

//获取微博
- (void)requestWeiboInfoWithCount:(int)count HandleBlock:(RWDB)block
{
    NSString * count_Str = [NSString stringWithFormat:@"%d",count];
    NSDictionary * dic = @{@"access_token":access_token,@"count":count_Str};
    [self.afManager GET:getWeiboURL parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //1、将请求回来的数据进行解析
        NSError * error = nil;
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
        if (!dic)
        {
            NSLog(@"解析失败%@",error.localizedDescription);
        }
        NSArray * weibos = dic[@"statuses"];
        //初始化一个可变数组用于存储实体对象
        NSMutableArray * mWeibos = [NSMutableArray arrayWithCapacity:weibos.count];
        for (int i = 0; i < weibos.count; i++)
        {
            NSDictionary * dic1 = weibos[i];
            BaseEntity * w = [self convertDictionaryToEntity:dic1];
            [mWeibos addObject:w];
            block([NSArray arrayWithArray:mWeibos]);//让block将存放实体数据的数组传回去
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败：%@",error.localizedDescription);
    }];
}

//发送微博
- (void)sendWeiboWithText:(NSString *)text andImage:(UIImage *)image
{
    NSDictionary *dict = @{@"access_token":access_token,@"status":text};
    if (image)
    {
        NSData *data = UIImagePNGRepresentation(image);
        [self.afManager POST:sendWeiboWithImageURL parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:data name:@"pic" fileName:@"123.png" mimeType:@"image/png"];
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"发送带图片的微博成功！");

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"发送带图片微博失败！");
            NSLog(@"error = %@",error.localizedDescription);
            
        }];
    }else
    {
        [self.afManager POST:sendWeiboWithTextURL parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"发送纯文本微博成功！");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"发送纯文本微博失败%@",error.localizedDescription);
        }];

    }
}

- (BaseEntity *)convertDictionaryToEntity:(NSDictionary *)dic1
{
    if (dic1[@"retweeted_status"] == nil)
    {
        if (dic1[@"thumbnail_pic"] == nil)
        {//如果当前微博没有图片则执行如下操作
            WZWeibo * w = [[WZWeibo alloc]init];
            w.name = dic1[@"user"][@"name"];
            w.text = dic1[@"text"];
            w.headImageURL_str = dic1[@"user"][@"profile_image_url"];
            w.reposts_count = dic1[@"reposts_count"];
            w.comments_count = dic1[@"comments_count"];
            w.attitudes_count = dic1[@"attitudes_count"];
            w.weiboID = dic1[@"id"];
            return w;
        }else
        {
            //有图片时的情况
            TPWeibo * w = [[TPWeibo alloc]init];
            w.name = dic1[@"user"][@"name"];
            w.text = dic1[@"text"];
            w.headImageURL_str = dic1[@"user"][@"profile_image_url"];
            w.weiboImageURL_Str = dic1[@"thumbnail_pic"];
            w.reposts_count = dic1[@"reposts_count"];
            w.comments_count = dic1[@"comments_count"];
            w.attitudes_count = dic1[@"attitudes_count"];
            w.weiboID = dic1[@"id"];

            return w;
        }
    }else
    {
        if (dic1[@"retweeted_status"][@"thumbnail_pic"] == nil)
        {//如果转发的微博没有图片则执行如下操作
            WZ_ForwardWeibo * w = [[WZ_ForwardWeibo alloc]init];
            w.name = dic1[@"user"][@"name"];
            w.text = dic1[@"text"];
            w.headImageURL_str = dic1[@"user"][@"profile_image_url"];
            w.retweeted_status = dic1[@"retweeted_status"][@"text"];
            w.reposts_count = dic1[@"reposts_count"];
            w.comments_count = dic1[@"comments_count"];
            w.attitudes_count = dic1[@"attitudes_count"];
            w.weiboID = dic1[@"id"];

            return w;
        }else
        {
            //有图片时的情况
            WZ_Forward_ImageWeibo * w = [[WZ_Forward_ImageWeibo alloc]init];
            w.name = dic1[@"user"][@"name"];
            w.text = dic1[@"text"];
            w.headImageURL_str = dic1[@"user"][@"profile_image_url"];
            w.retweeted_status = dic1[@"retweeted_status"][@"text"];
            w.weiboImageURL_Str = dic1[@"retweeted_status"][@"thumbnail_pic"];
            w.reposts_count = dic1[@"reposts_count"];
            w.comments_count = dic1[@"comments_count"];
            w.attitudes_count = dic1[@"attitudes_count"];
            w.weiboID = dic1[@"id"];
            return w;
        }
    }

}

//转发微博
- (void)repostWeiboWithWeiboID:(NSString *)weiboID WithText:(NSString *)text HandelBlock:(WMBB)block
{
    if ([text isEqualToString:@""])
    {
        text = @"//转发微博";
    }
    int count = [self textLength:text];
    if (count > 140)
    {
        block(NO);
        return;
    }else
    {
        block(YES);
    }
    
    NSDictionary *dict = @{@"access_token":access_token,@"id":weiboID,@"status":text};
    [self.afManager POST:repostWeibo parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError * error = nil;
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&error];
        if (dic == nil)
        {
            NSLog(@"返回数据错误：%@",error.localizedDescription);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"转发请求失败：%@",error.localizedDescription);

    }];
    
}

//请求某条微博的评论
- (void)getWeiboCommentsWithWeiboID:(NSString *)weiboID HandleBlock:(RWDB)block
{
    NSDictionary * dic = @{@"access_token":access_token,@"id":weiboID};
    [self.afManager GET:getWeiboComments parameters:dic success:^(AFHTTPRequestOperation *operation, NSData * responseObject) {
        NSError * error = nil;
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&error];
        NSArray * comments = dic[@"comments"];
        NSMutableArray * m_Comments = [NSMutableArray arrayWithCapacity:comments.count];
        for (int i = 0; i < comments.count; i++)
        {
            NSDictionary * dic1 = comments[i];
            commentEntity * c = [[commentEntity alloc]init];
            c.name = dic1[@"user"][@"name"];
            c.commentsText = dic1[@"text"];
            c.headImageURL_str = dic1[@"user"][@"profile_image_url"];
            c.weiboID = dic1[@"id"];
            [m_Comments addObject:c];
        }
        block([NSArray arrayWithArray:m_Comments]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求评论出错：%@",error.localizedDescription);
    }];

}


//评论微博
- (void)sendWeiboComment:(NSString *)text WithWeiboID:(NSString *)weiboID HandelBlock:(WMBB)block
{
    int count = [self textLength:text];
    if (count > 140)
    {
        block(NO);
        return;
    }else
    {
        block(YES);
    }
    NSDictionary * dic = @{@"access_token":access_token,@"id":weiboID,@"comment":text};
    [self.afManager POST:sendWeiboComments parameters:dic success:^(AFHTTPRequestOperation *operation, NSData * responseObject) {
        NSError * error;
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&error];
        if (dic == nil)
        {
            NSLog(@"返回数据错误：%@",error.localizedDescription);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发送评论请求失败：%@",error.localizedDescription);
    }];


}



//判断文字是否符合少于140字
-(int)textLength:(NSString *)text
{
    float sum = 0.0;
    for(int i=0;i<[text length];i++)
    {
        NSString *character = [text substringWithRange:NSMakeRange(i, 1)];
        if([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3)
        {
            sum++;
        }
        else
            sum += 0.5;
    }
    
    return ceil(sum);
}


//Map
- (void)requestNearbyWeiboWithLocation:(CLLocationCoordinate2D)coordinates andCount:(NSString *)count HandleBlock:(WMRNB)block
{
    CLLocationDegrees lat = coordinates.latitude;
    CLLocationDegrees longti = coordinates.longitude;
    NSString *lat_str = [NSString stringWithFormat:@"%lf", lat];
    NSString *longti_str = [NSString stringWithFormat:@"%lf", longti];
    NSDictionary *dict = @{@"access_token":@"2.00FhYUhFr3m8tD86ffb019a1Vv4GOD",@"lat":lat_str,@"long":longti_str,@"count":count};
    [self.afManager GET:@"https://api.weibo.com/2/place/nearby_timeline.json" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSArray *arr = dict[@"statuses"];
        NSMutableArray *m_Arr = [NSMutableArray arrayWithCapacity:arr.count];
        for (NSDictionary *dict1 in arr)
        {
            KCAnnotation * annotation = [[KCAnnotation alloc]init];
            annotation.userName = dict1[@"user"][@"name"];
            annotation.userImage = dict1[@"user"][@"profile_image_url"];
            annotation.text = dict1[@"text"];
            annotation.coor_Arr = dict1[@"geo"][@"coordinates"];
            [m_Arr addObject:annotation];

        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求附近微博 error = %@",error.localizedDescription);

    }];
    
}

- (void)requestNearbyUserHeadIamgeWithUrl:(NSString *)str_url HandleBlock:(WMRUHI)block
{
    [self.afManager GET:str_url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        UIImage * image = [UIImage imageWithData:responseObject];
        block(image);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求头像error = %@",error.localizedDescription);
    }];

}





@end
