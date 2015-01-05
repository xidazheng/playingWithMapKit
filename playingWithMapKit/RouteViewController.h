//
//  RouteViewController.h
//  playingWithMapKit
//
//  Created by Xida Zheng on 1/5/15.
//  Copyright (c) 2015 xidazheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface RouteViewController : UIViewController <MKMapViewDelegate>
@property (strong, nonatomic) MKMapItem *destination;
@property (weak, nonatomic) IBOutlet MKMapView *routeMap;

@end
