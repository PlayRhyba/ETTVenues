//
//  NSError+Errors.m
//  ETTVenues
//
//  Created by Alexander Snigurskyi on 2017-03-16.
//  Copyright © 2017 Alexander Snegursky. All rights reserved.
//


#import "NSError+Errors.h"


NSString * const NSError_Errors_ResponseObjectErrorsDomain = @"NSError_Errors_ResponseObjectErrorsDomain";
NSString * const NSError_Errors_InternalErrorsDomain = @"NSError_Errors_InternalErrorsDomain";


@implementation NSError (Errors)


+ (NSError *)unexpectedResponseDataStructureError {
    return [NSError errorWithDomain:NSError_Errors_ResponseObjectErrorsDomain
                               code:NSError_Errors_UnexpectedResponseDataStructureErrorCode
                           userInfo:@{NSLocalizedDescriptionKey: @"Unexpected response data structure."}];
}


+ (NSError *)internalError {
    return [NSError errorWithDomain:NSError_Errors_InternalErrorsDomain
                               code:NSError_Errors_InternalErrorCode
                           userInfo:@{NSLocalizedDescriptionKey: @"Internal error."}];
}

@end
