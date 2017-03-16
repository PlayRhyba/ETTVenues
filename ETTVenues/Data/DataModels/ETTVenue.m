//
//  ETTVenue.m
//  ETTVenues
//
//  Created by Alexander Snigurskyi on 2017-03-16.
//  Copyright © 2017 Alexander Snegursky. All rights reserved.
//


#import "ETTVenue.h"


@implementation ETTVenue


//MARK: ETTBaseObject


- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super initWithDictionary:dictionary]) {
        _name = dictionary[@"name"];
    }
    
    return self;
}


//MARK: Public Methods


+ (NSArray *)venuesWithDictionary:(NSDictionary *)dictionary {
    NSMutableArray *result = [NSMutableArray array];
    
    NSArray *venues = dictionary[@"response"][@"venues"];
    
    if (venues && [venues isKindOfClass:[NSArray class]]) {
        for (NSDictionary *v in venues) {
            [result addObject:[[ETTVenue alloc]initWithDictionary:v]];
        }
    }
    
    return [result copy];
}

@end
