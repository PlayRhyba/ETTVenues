//
//  ETTLocationManager.m
//  ETTVenues
//
//  Created by Alexander Snegursky on 3/15/17.
//  Copyright © 2017 Alexander Snegursky. All rights reserved.
//


#import "ETTLocationManager.h"
#import "ETTLocationObserver.h"


@interface ETTLocationManager () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableSet<ETTLocationObserver *> *observers;

@end


@implementation ETTLocationManager


@dynamic distanceFilter;


//MARK: Getters/Setters


- (CLLocationDistance)distanceFilter {
    return _locationManager.distanceFilter;
}


- (void)setDistanceFilter:(CLLocationDistance)distanceFilter {
    _locationManager.distanceFilter = distanceFilter > 0 ?: kCLDistanceFilterNone;
}


- (NSMutableSet *)observers {
    if (_observers == nil) {
        _observers = [NSMutableSet set];
    }
    
    return _observers;
}


//MARK: Public Methods


+ (instancetype)sharedInstance {
    static ETTLocationManager *_sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[ETTLocationManager alloc]init];
    });
    
    return _sharedInstance;
}


- (void)startObserving {
    [_locationManager startUpdatingLocation];
}


- (void)stopObserving {
    [_locationManager stopUpdatingLocation];
}


- (void)addObservationBlock:(ETTLocationManagerObservationBlock)block
             withIdentifier:(NSString *)identifier
                      queue:(dispatch_queue_t)queue {
    ETTLocationObserver *observer = [[ETTLocationObserver alloc]initWithIdentifier:identifier
                                                                       actionBlock:block
                                                                             queue:queue];
    [self.observers addObject:observer];
}


- (void)removeObservationBlockWithIdentifier:(NSString *)identifier {
    for (ETTLocationObserver *observer in self.observers) {
        if ([observer.identifier isEqualToString:identifier]) {
            [self.observers removeObject:observer];
            break;
        }
    }
}


//MARK: Lifecycle


- (instancetype)init {
    if (self = [super init]) {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        
        [_locationManager requestWhenInUseAuthorization];
    }
    
    return self;
}


//MARK: CLLocationManagerDelegate


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    for (ETTLocationObserver *observer in self.observers) {
        [observer invokeWithLocation:locations.lastObject error:nil];
    }
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    for (ETTLocationObserver *observer in self.observers) {
        [observer invokeWithLocation:nil error:error];
    }
}

@end
