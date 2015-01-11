//
//  DirectionsTableViewController.m
//  playingWithMapKit
//
//  Created by Xida Zheng on 1/9/15.
//  Copyright (c) 2015 xidazheng. All rights reserved.
//

#import "DirectionsTableViewController.h"

@interface DirectionsTableViewController ()
- (IBAction)doneTapped:(id)sender;

@end

@implementation DirectionsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.directions count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"directionCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = self.directions[indexPath.row];
    cell.textLabel.numberOfLines = 0;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}
- (IBAction)doneTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
