//
//  ETTSettingsStorage.m
//  ETTVenues
//
//  Created by Alexander Snegursky on 3/15/17.
//  Copyright © 2017 Alexander Snegursky. All rights reserved.
//


#import "ETTSettingsStorage.h"


@implementation ETTSettingsStorage


@dynamic distanceFilter;


//MARK: Public Methods


+ (instancetype)sharedInstance {
    static ETTSettingsStorage *_sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[ETTSettingsStorage alloc]init];
    });
    
    return _sharedInstance;
}


//MARK: Getters/Setters


- (float)distanceFilter {
    return [[NSUserDefaults standardUserDefaults]floatForKey:NSStringFromSelector(@selector(distanceFilter))];
}


- (void)setDistanceFilter:(float)distanceFilter {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setFloat:distanceFilter forKey:NSStringFromSelector(@selector(distanceFilter))];
    [defaults synchronize];
}

@end
