//
//  ViewController.m
//  playingWithMapKit
//
//  Created by Xida Zheng on 1/2/15.
//  Copyright (c) 2015 xidazheng. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
- (IBAction)zoomIn:(id)sender;
- (IBAction)changeMapType:(id)sender;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    NSLog(@"%d", status);
    
    if (status == kCLAuthorizationStatusRestricted || status == kCLAuthorizationStatusDenied) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Permission to Access Location Not Received" message:@"Please Turn On Location Sharing" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }];
        [alert addAction:defaultAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        
        if (status == kCLAuthorizationStatusNotDetermined) {
            NSLog(@"requestWhenInUseAuthorization reached");
            [self.locationManager requestWhenInUseAuthorization];
//            [self.locationManager startUpdatingLocation];
        } else if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
            
            if ([CLLocationManager locationServicesEnabled]) {
//                NSLog(@"showsUserLocation reached");
                self.mapView.showsUserLocation = YES;
            }
        }
    }
    
    
    
}

//need a handler for status messages because it comes up in two places

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"didChangeAuthorizationStatus %d", status);
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
        if ([CLLocationManager locationServicesEnabled]) {
            
            self.mapView.showsUserLocation = YES;
        }
    }

}

- (IBAction)zoomIn:(id)sender {
}

- (IBAction)changeMapType:(id)sender {
}
@end
