//
//  ResultsTableViewController.h
//  playingWithMapKit
//
//  Created by Xida Zheng on 1/5/15.
//  Copyright (c) 2015 xidazheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface ResultsTableViewController : UITableViewController
@property (strong, nonatomic) NSArray *mapItems;
@property (nonatomic) MKCoordinateRegion startingRegion;
@end
