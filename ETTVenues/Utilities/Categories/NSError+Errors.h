//
//  NSError+Errors.h
//  ETTVenues
//
//  Created by Alexander Snigurskyi on 2017-03-16.
//  Copyright © 2017 Alexander Snegursky. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString * const NSError_Errors_ResponseObjectErrorsDomain;
extern NSString * const NSError_Errors_InternalErrorsDomain;


typedef NS_ENUM(NSInteger, NSError_Errors) {
    NSError_Errors_UnexpectedResponseDataStructureErrorCode = -5000,
    NSError_Errors_InternalErrorCode,
};


@interface NSError (Errors)

+ (NSError *)unexpectedResponseDataStructureError;
+ (NSError *)internalError;

@end
