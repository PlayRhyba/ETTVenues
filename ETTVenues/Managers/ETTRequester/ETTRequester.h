//
//  ETTRequester.h
//  ETTVenues
//
//  Created by Alexander Snegursky on 3/15/17.
//  Copyright © 2017 Alexander Snegursky. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>


@class ETTPhoto;


@interface ETTRequester : NSObject

+ (instancetype)sharedInstance;

- (void)photosWithLocation:(CLLocation *)location
                completion:(void(^)(NSArray<ETTPhoto *> *photos, NSError *error))completion;
@end
