//
//  ETTBaseObject.m
//  ETTVenues
//
//  Created by Alexander Snigurskyi on 2017-03-16.
//  Copyright © 2017 Alexander Snegursky. All rights reserved.
//


#import "ETTBaseObject.h"


@implementation ETTBaseObject


//MARK: Public Methods


- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        _objectID = dictionary[@"id"];
    }
    
    return self;
}

@end
