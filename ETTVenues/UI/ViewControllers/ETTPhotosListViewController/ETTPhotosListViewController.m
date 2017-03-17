//
//  ETTPhotosListViewController.m
//  ETTVenues
//
//  Created by Alexander Snegursky on 3/15/17.
//  Copyright © 2017 Alexander Snegursky. All rights reserved.
//


#import "ETTPhotosListViewController.h"
#import "ETTLocationManager.h"
#import "ETTRequester.h"
#import "ETTPhotoCell.h"
#import "ETTPhotoViewController.h"


@interface ETTPhotosListViewController () <UICollectionViewDataSource>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *photos;

@end


@implementation ETTPhotosListViewController


//MARK: Lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    __typeof(self) __weak weakSelf = self;
    
    [[ETTLocationManager sharedInstance]addObservationBlock:^(CLLocation *location, NSError *error) {
        if (location) {
            NSLog(@"LOCATION UPDATED: %@", location);
            
            UIApplication *application = [UIApplication sharedApplication];
            application.networkActivityIndicatorVisible = YES;
            
            [[ETTRequester sharedInstance]photosWithLocation:location completion:^(NSArray<ETTPhoto *> *photos, NSError *error) {
                application.networkActivityIndicatorVisible = NO;
                
                weakSelf.photos = photos;
                [weakSelf.collectionView reloadData];
            }];
        }
        else if (error) {
            NSLog(@"LOCATION UPDATING ERROR: %@", error.localizedDescription);
        }
    } withIdentifier:NSStringFromClass([self class]) queue:dispatch_get_main_queue()];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[ETTLocationManager sharedInstance]startObserving];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[ETTLocationManager sharedInstance]stopObserving];
}


//MARK: UICollectionViewDataSource


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _photos.count;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ETTPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ETTPhotoCell class]) forIndexPath:indexPath];
    cell.photo = _photos[indexPath.row];
    return cell;
}


//MARK: Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *vc = [segue destinationViewController];
    
    if ([vc isKindOfClass:[ETTPhotoViewController class]] && [sender isKindOfClass:[ETTPhotoCell class]]) {
        [(ETTPhotoViewController *)vc setPhoto:[(ETTPhotoCell *)sender photo]];
    }
}

@end
