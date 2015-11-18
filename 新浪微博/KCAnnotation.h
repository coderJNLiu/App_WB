//
//  KCAnnotation.h
//  新浪微博
//
//  Created by bxipad on 15/10/20.
//  Copyright © 2015年 ibokan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface KCAnnotation : NSObject<MKAnnotation>
@property (copy,nonatomic) NSString *title;
@property (copy,nonatomic) NSString *subtitle;
@property (assign,nonatomic) CLLocationCoordinate2D coordinate;

//用于接收数据
@property (copy, nonatomic) NSString * userName;
@property (copy, nonatomic) NSString * userImage;
@property (copy, nonatomic) NSString * text;//微博信息
@property (strong, nonatomic) NSArray * coor_Arr;//存储位置
@end


