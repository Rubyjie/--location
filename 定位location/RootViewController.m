//
//  RootViewController.m
//  定位location
//
//  Created by 赵中杰 on 14-7-7.
//  Copyright (c) 2014年 赵中杰. All rights reserved.
//


//  我们要在Xcode中添加“CoreLocation.framework”存在的框架

#import "RootViewController.h"

#import <CoreLocation/CoreLocation.h>



@interface RootViewController ()<CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    UILabel *dresslabel;
    
}

@end

@implementation RootViewController

- (void)dealloc
{
    [locationManager release];
    [dresslabel release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        locationManager = [[CLLocationManager alloc]init];
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = 10;
        locationManager.delegate = self;

        [locationManager startUpdatingLocation];


    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    dresslabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, 320, 140)];
    dresslabel.numberOfLines = 0;
    [self.view addSubview:dresslabel];
    
    self.title = @"当前位置";
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 100, 300, 100)];
    [self.view addSubview:label];
    [label release];

    
}



- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSString *longitude = [NSString stringWithFormat:@"%3.5f",manager.location.coordinate.longitude];
    NSString *latitude = [NSString stringWithFormat:@"%3.5f",manager.location.coordinate.latitude];
    
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"坐标" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:longitude,latitude, nil];

    [alert show];
    [alert release];
    
    NSLog(@"%3.5f  %3.5f",manager.location.coordinate.longitude,manager.location.coordinate.latitude);
    
    CLLocation* lo = [locations lastObject];
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:lo completionHandler:^(NSArray *placemarks, NSError *error) {
        if ( [placemarks count] > 0 ) {
            CLPlacemark* placemark = placemarks[0];
            NSDictionary *dictAddress = placemark.addressDictionary;

            NSString *FormattedAddressLines = [dictAddress objectForKey:@"FormattedAddressLines"];
            NSString *name = [dictAddress objectForKey:@"Name"];
            NSString *state = [dictAddress objectForKey:@"State"];
            NSLog(@"地址: %@ %@ %@ %@",dictAddress ,FormattedAddressLines ,name, state);
            dresslabel.text = [NSString stringWithFormat:@"%@",name];

        }
    }];
    
    
  //  http://api.map.baidu.com/geocoder/v2/?ak=E4805d16520de693a3fe707cdc962045&callback=renderReverse&location=39.983424,116.322987&output=json&pois=1

}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"didChangeAuthorizationStatus---%u",status);
    
    
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didChangeAuthorizationStatus----%@",error);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
