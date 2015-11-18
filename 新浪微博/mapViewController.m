//
//  mapViewController.m
//  新浪微博
//
//  Created by bxipad on 15/10/20.
//  Copyright © 2015年 ibokan. All rights reserved.
//

#import "mapViewController.h"
#import <MapKit/MapKit.h>
#import "KCAnnotation.h"
#import "WeiboManager.h"
@interface mapViewController ()<CLLocationManagerDelegate,MKMapViewDelegate>
@property (strong,nonatomic) CLLocationManager *manager;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong,nonatomic) WeiboManager *wbmanager;
@property (strong,nonatomic) CLGeocoder *geoCoder;

@end

@implementation mapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.manager = [[CLLocationManager alloc]init];
    [self.manager requestWhenInUseAuthorization];
    self.manager.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    
    self.wbmanager = [WeiboManager shareWeiboManager];
    self.geoCoder = [[CLGeocoder alloc]init];
    
    
    
}

//当访问位置时，检测用户设置的访问权限
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusNotDetermined)
    {
        [manager requestWhenInUseAuthorization];
    }else if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        [manager startUpdatingLocation];//进行定位操作
    }else
    {
        NSLog(@"无法进行定位");
    }

}

//当定位成功后调用
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    [manager stopUpdatingLocation];
    CLLocation * loc = locations.lastObject;//获取位置
    //    loc.coordinate.latitude;
    //    loc.coordinate.longitude;
    
    MKCoordinateRegion region;
    region.center = loc.coordinate;
    region.span.latitudeDelta = 0.54;
    region.span.longitudeDelta = 0.54;
    NSLog(@"===");
    [self.mapView setRegion:region];
    __weak __block mapViewController * copy_self = self;
    [self.wbmanager requestNearbyWeiboWithLocation:loc.coordinate andCount:@"5" HandleBlock:^(NSArray *nearbys) {
        [copy_self.mapView addAnnotations:nearbys];
    }];
    
    
}

//定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error = %@",error.localizedDescription);
}

//当要加载地图上大头针时调用
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(KCAnnotation<MKAnnotation>*)annotation
{
    NSLog(@"----");
    if ([annotation isKindOfClass:[KCAnnotation class]])
    {
        MKAnnotationView * annotationV = [mapView dequeueReusableAnnotationViewWithIdentifier:@"aaa"];
        if (annotationV == nil)
        {
            annotationV = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"aaa"];
            annotationV.canShowCallout = YES;
        }
        //        annotationV.image = [UIImage imageNamed:@"1"];
        [self.wbmanager requestNearbyUserHeadIamgeWithUrl:annotation.userImage HandleBlock:^(UIImage *image) {
            annotationV.image = image;
            annotationV.rightCalloutAccessoryView = [[UIImageView alloc]initWithImage:image];
        }];
        return annotationV;
    }
    return nil;
    
}


- (IBAction)tapFuncBtn:(id)sender
{
    [self requestAddressNameWithLatitude:39.91 andLongtitude:116.17];

}

- (void)requestInformationWithAddress:(NSString *)address
{
    [self.geoCoder geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark * placeMark = [placemarks firstObject];
        NSLog(@"位置：%@,区域：%@,详细信息：%@",placeMark.location,placeMark.region,placeMark.addressDictionary);
    }];
}

- (void)requestAddressNameWithLatitude:(CLLocationDegrees)lat andLongtitude:(CLLocationDegrees)longti
{
    CLLocation * loc = [[CLLocation alloc]initWithLatitude:lat longitude:longti];
    [self.geoCoder reverseGeocodeLocation:loc completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark * placeMark = [placemarks firstObject];
        NSLog(@"%@",placeMark.addressDictionary);
    }];
}




@end
