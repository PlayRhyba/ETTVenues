//
//  ETTSettingsStorage.h
//  ETTVenues
//
//  Created by Alexander Snegursky on 3/15/17.
//  Copyright © 2017 Alexander Snegursky. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface ETTSettingsStorage : NSObject

@property (nonatomic) float distanceFilter;

+ (instancetype)sharedInstance;

@end
