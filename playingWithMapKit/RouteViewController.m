//
//  RouteViewController.m
//  playingWithMapKit
//
//  Created by Xida Zheng on 1/5/15.
//  Copyright (c) 2015 xidazheng. All rights reserved.
//

#import "RouteViewController.h"
#import "DirectionsTableViewController.h"

@interface RouteViewController ()
@property (strong, nonatomic) NSMutableArray *directions;
@property (nonatomic) MKCoordinateRegion adjustedRegion;
@property (nonatomic) BOOL destinationVisible;

@end

@implementation RouteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"RouteViewDidLoad");
    
    self.directions = [[NSMutableArray alloc]init];
    self.routeMap.delegate = self;
    self.routeMap.showsUserLocation = YES;
    
    [self.routeMap setRegion:self.startingRegion animated:NO];
    
    [self getDirections];
    
}

- (void)resizeRegionWithDestination:(MKMapItem *)destination userLocation:(MKUserLocation *)userLocation
{
    NSLog(@"need to resize");
    CLLocationCoordinate2D destinationCoordinate = destination.placemark.location.coordinate;
    CLLocationCoordinate2D userCoordinate = userLocation.location.coordinate;
    
    double scaleFactor = 2;
    CLLocationDegrees latitudeDelta = (userCoordinate.latitude - destinationCoordinate.latitude)*scaleFactor;
    CLLocationDegrees longitudeDelta = (userCoordinate.longitude - destinationCoordinate.longitude)*scaleFactor;
    
    if (latitudeDelta < 0) {
        latitudeDelta = latitudeDelta * -1;
    }
    if (longitudeDelta < 0) {
        longitudeDelta = longitudeDelta * -1;
    }
    
    MKCoordinateSpan span = MKCoordinateSpanMake(latitudeDelta, longitudeDelta);

    CLLocationDegrees averageLatitude = (userCoordinate.latitude + destinationCoordinate.latitude)/2;
    CLLocationDegrees averageLongitude = (userCoordinate.longitude + destinationCoordinate.longitude)/2;
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(averageLatitude, averageLongitude);

    MKCoordinateRegion region = MKCoordinateRegionMake(centerCoordinate, span);
    
    self.adjustedRegion = [self.routeMap regionThatFits:region];
    [self.routeMap setRegion:self.adjustedRegion animated:YES];
    
}

- (void)getDirections{
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    
    request.source = [MKMapItem mapItemForCurrentLocation];
    request.destination = self.destination;
    request.requestsAlternateRoutes = NO;
    request.transportType = MKDirectionsTransportTypeAny;
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (error) {
            NSLog(@"error %@", error.localizedDescription);
        } else{
            [self showRoute:response];
//            if (!self.destinationVisible && !(self.adjustedRegion.center.latitude == 0)) {
//                [self.routeMap setRegion:self.adjustedRegion animated:YES];
//            }
        }
    }];
}


- (void)showRoute:(MKDirectionsResponse *)response
{
    for (MKRoute *route in response.routes) {
        [self.routeMap addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
        
        [self.directions removeAllObjects];
        for (MKRouteStep *step in route.steps) {
            [self.directions addObject:[NSString stringWithFormat:@"%@ for %0.f meters.", step.instructions, step.distance ]];
        }
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 5.0;
    return renderer;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    NSLog(@"mapView didUpdateUserLocation %@", userLocation.location);
    [self.routeMap setRegion:self.startingRegion animated:NO];
  
    MKMapPoint destionationPoint = MKMapPointForCoordinate(self.destination.placemark.location.coordinate);
    MKMapRect mapRect = self.routeMap.visibleMapRect;
    self.destinationVisible = MKMapRectContainsPoint(mapRect, destionationPoint);

    if (!self.destinationVisible) {
        [self resizeRegionWithDestination:self.destination userLocation:userLocation];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *navigationVC = [segue destinationViewController];
    DirectionsTableViewController *directionsTVC = (DirectionsTableViewController *)navigationVC.topViewController;
    directionsTVC.directions = self.directions;
    
}


@end
