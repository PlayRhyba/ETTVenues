//
//  UIImageView+Loading.m
//  ETTVenues
//
//  Created by Alexander Snigurskyi on 2017-03-16.
//  Copyright © 2017 Alexander Snegursky. All rights reserved.
//


#import "UIImageView+Loading.h"
#import <AFNetworking/UIImageView+AFNetworking.h>


@implementation UIImageView (Loading)


- (void)loadImageWithURL:(NSURL *)url {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    if (request) {
        [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
        
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        indicator.color = [UIColor grayColor];
        
        CGRect frame = indicator.frame;
        CGFloat x = self.frame.size.width / 2.0 - frame.size.width / 2.0;
        CGFloat y = self.frame.size.height / 2.0 - frame.size.height / 2.0;
        frame.origin = CGPointMake(x, y);
        indicator.frame = frame;
        
        [self addSubview:indicator];
        
        [indicator startAnimating];
        
        self.image = nil;
        
        __typeof(self) __weak weakSelf = self;
        
        [self setImageWithURLRequest:request
                    placeholderImage:nil
                             success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                 [weakSelf.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                                 weakSelf.image = image;
                             } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                 [weakSelf.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                             }];
    }
}

@end
