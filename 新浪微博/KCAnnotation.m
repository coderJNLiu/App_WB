//
//  KCAnnotation.m
//  新浪微博
//
//  Created by bxipad on 15/10/20.
//  Copyright © 2015年 ibokan. All rights reserved.
//

#import "KCAnnotation.h"

@implementation KCAnnotation

- (NSString *)title
{
    return self.userName;
}

- (NSString *)subtitle
{
    return self.text;
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocationDegrees lat = [self.coor_Arr[0] doubleValue];
    CLLocationDegrees longti = [self.coor_Arr[1] doubleValue];
    CLLocationCoordinate2D coor ;
    coor.latitude = lat;
    coor.longitude = longti;
    return coor;
}


@end
