//
//  ETTPhotosListViewController.m
//  ETTVenues
//
//  Created by Alexander Snegursky on 3/15/17.
//  Copyright © 2017 Alexander Snegursky. All rights reserved.
//


#import "ETTPhotosListViewController.h"
#import "ETTLocationManager.h"


@interface ETTPhotosListViewController ()

@end


@implementation ETTPhotosListViewController


//MARK: Lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[ETTLocationManager sharedInstance]addObservationBlock:^(CLLocation *location, NSError *error) {
        if (location) {
            
            
            NSLog(@"LOCATION: %@", location);
            
            
        }
    } withIdentifier:NSStringFromClass([self class]) queue:dispatch_get_main_queue()];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[ETTLocationManager sharedInstance]startObserving];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[ETTLocationManager sharedInstance]stopObserving];
}


//MARK: Navigation


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
