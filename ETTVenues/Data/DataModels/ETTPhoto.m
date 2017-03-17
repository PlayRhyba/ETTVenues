//
//  ETTPhoto.m
//  ETTVenues
//
//  Created by Alexander Snigurskyi on 2017-03-16.
//  Copyright © 2017 Alexander Snegursky. All rights reserved.
//


#import "ETTPhoto.h"


@interface ETTPhoto ()

@property (nonatomic, strong, readwrite) NSString *prefix;
@property (nonatomic, strong, readwrite) NSString *suffix;

- (NSURL *)urlWithPhotoSize:(NSString *)size;

@end


@implementation ETTPhoto


//MARK: ETTBaseObject


- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super initWithDictionary:dictionary]) {
        _prefix = dictionary[@"prefix"];
        _suffix = dictionary[@"suffix"];
    }
    
    return self;
}


//MARK: Public Methods


+ (NSArray *)photosWithDictionary:(NSDictionary *)dictionary {
    NSMutableArray *result = [NSMutableArray array];
    
    NSArray *photos = dictionary[@"response"][@"photos"][@"items"];
    
    if (photos && [photos isKindOfClass:[NSArray class]]) {
        for (NSDictionary *p in photos) {
            [result addObject:[[ETTPhoto alloc]initWithDictionary:p]];
        }
    }
    
    return [result copy];
}


- (NSURL *)previewURLWithSize:(CGSize)size {
    int cap = (int)MAX(size.width, size.height) * 2;
    return [self urlWithPhotoSize:[NSString stringWithFormat:@"cap%d", cap]];
}


- (NSURL *)originalURL {
    return [self urlWithPhotoSize:@"original"];
}


//MARK: Internal Logic


- (NSURL *)urlWithPhotoSize:(NSString *)size {
    return [[[NSURL URLWithString:_prefix]
             URLByAppendingPathComponent:size]
            URLByAppendingPathComponent:_suffix];
}

@end
