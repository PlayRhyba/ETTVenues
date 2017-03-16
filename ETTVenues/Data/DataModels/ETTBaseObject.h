//
//  ETTBaseObject.h
//  ETTVenues
//
//  Created by Alexander Snigurskyi on 2017-03-16.
//  Copyright © 2017 Alexander Snegursky. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface ETTBaseObject : NSObject

@property (nonatomic, copy) NSString *objectID;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
