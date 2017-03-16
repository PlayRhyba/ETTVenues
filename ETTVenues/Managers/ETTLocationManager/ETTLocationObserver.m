//
//  ETTLocationObserver.m
//  ETTVenues
//
//  Created by Alexander Snegursky on 3/15/17.
//  Copyright © 2017 Alexander Snegursky. All rights reserved.
//


#import "ETTLocationObserver.h"


@interface ETTLocationObserver ()

@property (nonatomic, copy, readwrite) NSString *identifier;
@property (nonatomic, copy) ETTLocationObserverActionBlock actionBlock;
@property (nonatomic, strong) dispatch_queue_t queue;

@end


@implementation ETTLocationObserver


//MARK: NSObject


- (BOOL)isEqual:(id)object {
    if (self == object) return YES;
    if ([self class] != [object class]) return NO;
    return [_identifier isEqualToString:[(ETTLocationObserver*)object identifier]];
}


- (NSUInteger)hash {
    return [_identifier hash];
}


//MARK: Public Methods


- (instancetype)initWithIdentifier:(NSString *)identifier
                       actionBlock:(ETTLocationObserverActionBlock)actionBlock
                             queue:(dispatch_queue_t)queue {
    if (self = [super init]) {
        _identifier = identifier;
        _actionBlock = actionBlock;
        _queue = queue;
    }
    
    return self;
}


- (void)invokeWithLocation:(CLLocation *)location
                     error:(NSError *)error {
    dispatch_async(_queue, ^{
        self.actionBlock(location, error);
    });
}

@end
