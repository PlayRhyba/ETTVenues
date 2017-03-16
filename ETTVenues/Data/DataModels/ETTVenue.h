//
//  ETTVenue.h
//  ETTVenues
//
//  Created by Alexander Snigurskyi on 2017-03-16.
//  Copyright © 2017 Alexander Snegursky. All rights reserved.
//


#import "ETTBaseObject.h"


@interface ETTVenue : ETTBaseObject

@property (nonatomic, strong, readonly) NSString *name;

+ (NSArray *)venuesWithDictionary:(NSDictionary *)dictionary;

@end
