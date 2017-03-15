//
//  ETTLocationObserver.h
//  ETTVenues
//
//  Created by Alexander Snegursky on 3/15/17.
//  Copyright © 2017 Alexander Snegursky. All rights reserved.
//


#import <CoreLocation/CoreLocation.h>


typedef void(^ETTLocationObserverActionBlock)(CLLocation *location, NSError *error);


@interface ETTLocationObserver : NSObject

@property (nonatomic, copy, readonly) NSString *identifier;

- (instancetype)initWithIdentifier:(NSString *)identifier
                       actionBlock:(ETTLocationObserverActionBlock)actionBlock
                             queue:(dispatch_queue_t)queue;

- (void)invokeWithLocation:(CLLocation *)location
                     error:(NSError *)error;
@end
