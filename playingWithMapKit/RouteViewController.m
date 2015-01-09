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

- (void)getDirections{
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    
    request.source = [MKMapItem mapItemForCurrentLocation];
    request.destination = self.destination;
    request.requestsAlternateRoutes = NO;
    request.transportType = MKDirectionsTransportTypeWalking;
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (error) {
            NSLog(@"error %@", error.localizedDescription);
        } else{
            [self showRoute:response];
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
//    NSLog(@"mapView didUpdateUserLocation %@", userLocation.location);
//    [self.routeMap setRegion:MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 1000, 1000) animated:NO];
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
