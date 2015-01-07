//
//  ViewController.m
//  playingWithMapKit
//
//  Created by Xida Zheng on 1/2/15.
//  Copyright (c) 2015 xidazheng. All rights reserved.
//

#import "MapViewController.h"
#import "ResultsTableViewController.h"

@interface MapViewController ()
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (strong, nonatomic) NSMutableArray *matchingItems;
- (IBAction)zoomIn:(id)sender;
- (IBAction)changeMapType:(id)sender;
- (IBAction)textFieldReturn:(id)sender;
- (IBAction)checkInTapped:(id)sender;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    NSLog(@"%d", status);
    
    if (status == kCLAuthorizationStatusRestricted || status == kCLAuthorizationStatusDenied) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Permission to Access Location Not Received" message:@"Please Turn On Location Sharing in Settings" preferredStyle:UIAlertControllerStyleAlert];
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
        } else if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
            
            if ([CLLocationManager locationServicesEnabled]) {
                NSLog(@"showsUserLocation reached");
                self.mapView.showsUserLocation = YES;
            }
        }
    }
    

    
    self.mapView.delegate = self;
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"viewdidapppear");
    
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

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
//    NSLog(@"locationManager didUpdateLocations %@", locations[0]);
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
//    NSLog(@"mapView didUpdateUserLocation %@", userLocation.location);
    self.mapView.centerCoordinate = userLocation.location.coordinate;
}

- (IBAction)zoomIn:(id)sender {
    MKUserLocation *userLocation = self.mapView.userLocation;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 1000, 1000);
    [self.mapView setRegion:region animated:NO];
    

    NSLog(@"%f %f %f %f", region.center.latitude, region.center.longitude, region.span.latitudeDelta, region.span.longitudeDelta);
    NSLog(@"%f %f %f %f", self.mapView.region.center.latitude, self.mapView.region.center.longitude, self.mapView.region.span.latitudeDelta, self.mapView.region.span.longitudeDelta);
}

- (IBAction)changeMapType:(id)sender {
    if (self.mapView.mapType == MKMapTypeStandard) {
        self.mapView.mapType = MKMapTypeHybrid;
    }else {
        self.mapView.mapType = MKMapTypeStandard;
    }
}

- (IBAction)textFieldReturn:(id)sender {
    [sender resignFirstResponder];
    [self.mapView removeAnnotations:[self.mapView annotations]];
    [self performSearch];
}

- (IBAction)checkInTapped:(id)sender {
    
}

- (void) performSearch {
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = self.searchText.text;
    request.region = self.mapView.region;
    
    self.matchingItems = [[NSMutableArray alloc] init];
    
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        MKPointAnnotation *lastAnnotation;
        
        if (response.mapItems.count == 0) {
            NSLog(@"No Matches");
        }else
        {
            for (MKMapItem *item in response.mapItems)
            {
                [self.matchingItems addObject:item];
                MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                annotation.coordinate = item.placemark.coordinate;
                annotation.title = item.name;
                [self.mapView addAnnotation:annotation];
                
                lastAnnotation = annotation;
            }
        }
        
        [self.mapView selectAnnotation:lastAnnotation animated:YES];
    }];
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ResultsTableViewController *destination = [segue destinationViewController];
    destination.mapItems = self.matchingItems;
}

@end
