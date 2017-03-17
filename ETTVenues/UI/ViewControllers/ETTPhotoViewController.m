//
//  ETTPhotoViewController.m
//  ETTVenues
//
//  Created by Alexander Snegursky on 3/15/17.
//  Copyright © 2017 Alexander Snegursky. All rights reserved.
//

#import "ETTPhotoViewController.h"
#import "UIImageView+Loading.h"
#import "ETTPhoto.h"
#import "ETTVenue.h"


@interface ETTPhotoViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@end


@implementation ETTPhotoViewController


//MARK: Lifecycle


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.title = _photo.venue.name;
    [_imageView loadImageWithURL:[_photo originalURL]];
}

@end
