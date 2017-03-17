//
//  ETTPhoto.h
//  ETTVenues
//
//  Created by Alexander Snigurskyi on 2017-03-16.
//  Copyright © 2017 Alexander Snegursky. All rights reserved.
//


#import "ETTBaseObject.h"
#import <UIKit/UIKit.h>


@class ETTVenue;


@interface ETTPhoto : ETTBaseObject

@property (nonatomic, strong, readonly) NSString *prefix;
@property (nonatomic, strong, readonly) NSString *suffix;
@property (nonatomic, strong) ETTVenue *venue;

+ (NSArray *)photosWithDictionary:(NSDictionary *)dictionary;
- (NSURL *)previewURLWithSize:(CGSize)size;
- (NSURL *)originalURL;

@end
