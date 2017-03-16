//
//  ETTRequester.m
//  ETTVenues
//
//  Created by Alexander Snegursky on 3/15/17.
//  Copyright © 2017 Alexander Snegursky. All rights reserved.
//


#import "ETTRequester.h"
#import <AFNetworking/AFNetworking.h>
#import "ETTVenue.h"
#import "ETTPhoto.h"
#import "NSError+Errors.h"


static NSString * const kBaseURL = @"https://api.foursquare.com";
static NSString * const kClientID = @"LOCC0VDDYUO4YYZTBDAWR3ASJOLOG4BYEIUQUYK4RZGBKP5M";
static NSString * const kClientSecret = @"HSK400P2UBYM2G30MAMJGOWC3WI51PXRVMKBNN2DK4RN3YFI";
static NSString * const kVersionDate = @"20170316";

const NSUInteger ETTRequesterMaxPhotosAmount = 100;
static const NSUInteger kVenuesLimit = 50;


@interface ETTRequester ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

- (void)venuesWithLocation:(CLLocation *)location
                completion:(void(^)(NSArray<ETTVenue *> *venues, NSError *error))completion;

- (void)photosWithVenueID:(NSString *)venueID
               completion:(void(^)(NSArray<ETTPhoto *> *photos, NSError *error))completion;

- (NSMutableDictionary *)parameters;

@end




@implementation ETTRequester


//MARK: Public Methods


+ (instancetype)sharedInstance {
    static ETTRequester *_sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[ETTRequester alloc]init];
    });
    
    return _sharedInstance;
}


- (void)photosWithLocation:(CLLocation *)location
                completion:(void(^)(NSArray<ETTPhoto *> *photos, NSError *error))completion {
    __typeof(self) __weak weakSelf = self;
    
    [self venuesWithLocation:location completion:^(NSArray<ETTVenue *> *venues, NSError *error) {
        if (completion) {
            if (error) {
                completion(nil, error);
            }
            else {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSMutableArray<ETTPhoto *> *resultPhotos = [NSMutableArray array];
                    __block NSError *lastError = nil;
                    
                    [venues enumerateObjectsUsingBlock:^(ETTVenue * _Nonnull venue, NSUInteger idx, BOOL * _Nonnull stop) {
                        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
                        
                        [weakSelf photosWithVenueID:venue.objectID completion:^(NSArray<ETTPhoto *> *photos, NSError *error) {
                            if (error) {
                                lastError = error;
                            }
                            else {
                                for (ETTPhoto *photo in photos) {
                                    if (resultPhotos.count >= ETTRequesterMaxPhotosAmount) {
                                        *stop = YES;
                                        break;
                                    }
                                    
                                    photo.venue = venue;
                                    [resultPhotos addObject:photo];
                                }
                            }
                            
                            dispatch_semaphore_signal(semaphore);
                        }];
                        
                        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                    }];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(resultPhotos, lastError);
                    });
                });
            }
        }
    }];
}


//MARK: Lifecycle


- (instancetype)init {
    if (self = [super init]) {
        _sessionManager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    }
    
    return self;
}


//MARK: Internal Logic


- (void)venuesWithLocation:(CLLocation *)location
                completion:(void(^)(NSArray<ETTVenue *> *venues, NSError *error))completion {
    NSMutableDictionary *parameters = [self parameters];
    
    [parameters addEntriesFromDictionary:@{@"limit": @(kVenuesLimit),
                                           @"ll": [NSString stringWithFormat:@"%lf,%lf",
                                                   location.coordinate.latitude,
                                                   location.coordinate.longitude]}];
    [_sessionManager GET:@"v2/venues/search"
              parameters:parameters
                progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     if (completion) {
                         if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                             NSArray *venues = [ETTVenue venuesWithDictionary:responseObject];
                             completion(venues, nil);
                         }
                         else {
                             completion(nil, [NSError unexpectedResponseDataStructureError]);
                         }
                     }
                 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     if (completion) {
                         completion(nil, error);
                     }
                 }];
}


- (void)photosWithVenueID:(NSString *)venueID
               completion:(void(^)(NSArray<ETTPhoto *> *photos, NSError *error))completion {
    NSMutableDictionary *parameters = [self parameters];
    [parameters addEntriesFromDictionary:@{@"limit": @(ETTRequesterMaxPhotosAmount)}];
    
    [_sessionManager GET:[NSString stringWithFormat:@"v2/venues/%@/photos", venueID]
              parameters:parameters
                progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     if (completion) {
                         if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                             NSArray *photos = [ETTPhoto photosWithDictionary:responseObject];
                             completion(photos, nil);
                         }
                         else {
                             completion(nil, [NSError unexpectedResponseDataStructureError]);
                         }
                     }
                 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     if (completion) {
                         completion(nil, error);
                     }
                 }];
}


- (NSMutableDictionary *)parameters {
    return @{@"client_id": kClientID,
             @"client_secret": kClientSecret,
             @"v": kVersionDate}.mutableCopy;
}

@end
