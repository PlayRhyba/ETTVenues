//
//  ETTPhotoCell.m
//  ETTVenues
//
//  Created by Alexander Snigurskyi on 2017-03-16.
//  Copyright © 2017 Alexander Snegursky. All rights reserved.
//


#import "ETTPhotoCell.h"
#import "ETTPhoto.h"
#import "UIImageView+Loading.h"


@interface ETTPhotoCell ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@end


@implementation ETTPhotoCell


//MARK: Getters/Setters


- (void)setPhoto:(ETTPhoto *)photo {
    _photo = photo;
    [_imageView loadImageWithURL:[_photo url]];
}

@end
