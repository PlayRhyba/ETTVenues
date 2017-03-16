//
//  ETTSettingsViewController.m
//  ETTVenues
//
//  Created by Alexander Snegursky on 3/15/17.
//  Copyright © 2017 Alexander Snegursky. All rights reserved.
//


#import "ETTSettingsViewController.h"
#import "ETTLocationManager.h"


@interface ETTSettingsViewController ()

@property (nonatomic, weak) IBOutlet UISlider *slider;
@property (nonatomic, weak) IBOutlet UILabel *label;

- (IBAction)sliderValueChanged:(UISlider *)sender;
- (void)updateLabel;

@end


@implementation ETTSettingsViewController


//MARK: Lifecycle


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateLabel];
    self.slider.value = [ETTLocationManager sharedInstance].distanceFilter;
}


//MARK: IBAction


- (IBAction)sliderValueChanged:(UISlider *)sender {
    [ETTLocationManager sharedInstance].distanceFilter = sender.value;
    [self updateLabel];
}


//MARK: Internal Logic


- (void)updateLabel {
    _label.text = [NSString stringWithFormat:@"Distance Filter: %.1f m", [ETTLocationManager sharedInstance].distanceFilter];
}

@end
