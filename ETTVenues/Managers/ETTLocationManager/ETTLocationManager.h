//
//  ETTLocationManager.h
//  ETTVenues
//
//  Created by Alexander Snegursky on 3/15/17.
//  Copyright © 2017 Alexander Snegursky. All rights reserved.
//


#import <CoreLocation/CoreLocation.h>


typedef void(^ETTLocationManagerObservationBlock)(CLLocation *location, NSError *error);


@interface ETTLocationManager : NSObject

@property (nonatomic, assign) CLLocationDistance distanceFilter;

+ (instancetype)sharedInstance;
- (void)startObserving;
- (void)stopObserving;

- (void)addObservationBlock:(ETTLocationManagerObservationBlock)block
             withIdentifier:(NSString *)identifier
                      queue:(dispatch_queue_t)queue;

- (void)removeObservationBlockWithIdentifier:(NSString *)identifier;
- (NSUInteger)observationBlocksCount;

@end
