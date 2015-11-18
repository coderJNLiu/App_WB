//
//  WeiboManager.h
//  新浪微博
//
//  Created by bxipad on 15/10/19.
//  Copyright © 2015年 ibokan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLs.h"
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
typedef void (^RWDB)(NSArray *weibos);
typedef void(^WMBB)(BOOL isOK);

//Map
typedef void(^WMRNB)(NSArray * nearbys);
typedef void(^WMRUHI)(UIImage * image);
@interface WeiboManager : NSObject

+ (instancetype)shareWeiboManager;


//请求数据的方法
- (void)requestWeiboInfoWithCount:(int)count HandleBlock:(RWDB)block;

//发送数据的方法
- (void)sendWeiboWithText:(NSString *)text andImage:(UIImage *)image;


//转发微博的方法
- (void)repostWeiboWithWeiboID:(NSString *)weiboID WithText:(NSString *)text HandelBlock:(WMBB)block;

//评论某条微博
- (void)sendWeiboComment:(NSString *)text WithWeiboID:(NSString *)weiboID HandelBlock:(WMBB)block;

//请求某条微博的评论
- (void)getWeiboCommentsWithWeiboID:(NSString *)weiboID HandleBlock:(RWDB)block;

//Map
+ (instancetype)shareWeiboManager;

- (void)requestNearbyWeiboWithLocation:(CLLocationCoordinate2D)coordinates andCount:(NSString *)count HandleBlock:(WMRNB)block;

- (void)requestNearbyUserHeadIamgeWithUrl:(NSString *)str_url HandleBlock:(WMRUHI)block;


@end
