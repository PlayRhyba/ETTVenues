//
//  ETTVenuesTests.m
//  ETTVenuesTests
//
//  Created by Alexander Snegursky on 3/15/17.
//  Copyright © 2017 Alexander Snegursky. All rights reserved.
//


#import <XCTest/XCTest.h>
#import "ETTVenue.h"
#import "ETTPhoto.h"
#import "ETTRequester.h"
#import "ETTLocationManager.h"
#import <CoreLocation/CLLocation.h>


static const NSTimeInterval kTimeout = 20.0;


@interface ETTVenuesTests : XCTestCase

- (void)testPhotoDataModel;
- (void)testVenueDataModel;
- (void)testRequester;
- (void)testLocationManager;

@end


@implementation ETTVenuesTests


- (void)testPhotoDataModel {
    NSDictionary *i_dictionary = @{@"id": @"58c1a27f7b43b418712a98ed",
                                   @"prefix": @"https://igx.4sqi.net/img/general/",
                                   @"suffix": @"/1322106_h4X6cYGloL7t0eirbyNlt_f87bs4XaWhFOhMF0Ib7qs.jpg"};
    
    ETTPhoto *photo = [[ETTPhoto alloc]initWithDictionary:i_dictionary];
    XCTAssertEqualObjects(photo.objectID, @"58c1a27f7b43b418712a98ed", @"ETTPhoto initialization test failed.");
    XCTAssertEqualObjects(photo.prefix, @"https://igx.4sqi.net/img/general/", @"ETTPhoto initialization test failed.");
    XCTAssertEqualObjects(photo.suffix, @"/1322106_h4X6cYGloL7t0eirbyNlt_f87bs4XaWhFOhMF0Ib7qs.jpg", @"ETTPhoto initialization test failed.");
    XCTAssertNotNil([photo previewURLWithSize:CGSizeMake(50.0, 50.0)], @"ETTPhoto \"preview\" URL building test failed.");
    XCTAssertNotNil([photo originalURL], @"ETTPhoto \"original\" URL building test failed.");
    
    NSDictionary *m_dictionary = @{@"response": @{@"photos": @{@"items": @[
                                                                       i_dictionary,
                                                                       i_dictionary,
                                                                       ]}}};
    NSArray *photos = [ETTPhoto photosWithDictionary:m_dictionary];
    XCTAssert(photos.count == 2, @"ETTPhoto multiple objects initialization test failed.");
}


- (void)testVenueDataModel {
    NSDictionary *i_dictionary = @{@"id": @"4f60d6e2e4b02a8707792bfa",
                                   @"name" : @"Downtown San Francisco"};
    
    ETTVenue *venue = [[ETTVenue alloc]initWithDictionary:i_dictionary];
    XCTAssertEqualObjects(venue.objectID, @"4f60d6e2e4b02a8707792bfa", @"ETTVenue initialization test failed.");
    XCTAssertEqualObjects(venue.name, @"Downtown San Francisco", @"ETTVenue initialization test failed.");
    
    NSDictionary *m_dictionary = @{@"response": @{@"venues" : @[
                                                          i_dictionary,
                                                          i_dictionary,
                                                          ]}};
    
    NSArray *venues = [ETTVenue venuesWithDictionary:m_dictionary];
    XCTAssert(venues.count == 2, @"ETTVenue multiple objects initialization test failed.");
}


- (void)testRequester {
    XCTestExpectation *requesterExpectation = [self expectationWithDescription:@"Requester expectation"];
    CLLocation *location = [[CLLocation alloc]initWithLatitude:37.785834 longitude:-122.406417];
    
    [[ETTRequester sharedInstance]photosWithLocation:location completion:^(NSArray<ETTPhoto *> *photos, NSError *error) {
        XCTAssertNil(error, @"Requester test failed. Error: %@", error.localizedDescription);
        XCTAssert(photos.count > 0, @"Requester test failed. photos.count == 0");
        XCTAssert(photos.count <= ETTRequesterMaxPhotosAmount, @"Requester test failed. photos.count > %lu", ETTRequesterMaxPhotosAmount);
        [requesterExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:kTimeout handler:^(NSError * _Nullable error) {
        XCTAssertNil(error, @"Requester test failed. Error: %@", error.localizedDescription);
    }];
}


- (void)testLocationManager {
    ETTLocationManager *locationManager = [ETTLocationManager sharedInstance];
    
    [locationManager addObservationBlock:^(CLLocation *location, NSError *error) {}
                          withIdentifier:@"first"
                                   queue:dispatch_get_main_queue()];
    
    [locationManager addObservationBlock:^(CLLocation *location, NSError *error) {}
                          withIdentifier:@"first"
                                   queue:dispatch_get_main_queue()];
    
    [locationManager addObservationBlock:^(CLLocation *location, NSError *error) {}
                          withIdentifier:@"second"
                                   queue:dispatch_get_main_queue()];
    
    XCTAssert(locationManager.observationBlocksCount == 2, @"LocationManager test failed.");
    
    [locationManager removeObservationBlockWithIdentifier:@"first"];
    [locationManager removeObservationBlockWithIdentifier:@"second"];
    XCTAssert(locationManager.observationBlocksCount == 0, @"LocationManager test failed.");
    
    XCTestExpectation *locationObserverExpectation1 = [self expectationWithDescription:@"Location observer expectation 1"];
    XCTestExpectation *locationObserverExpectation2 = [self expectationWithDescription:@"Location observer expectation 2"];
    
    ETTLocationManagerObservationBlock test = ^(CLLocation *location, NSError *error) {
        XCTAssertNil(error, @"LocationManager test failed. Error: %@", error.localizedDescription);
        XCTAssertNotNil(location, @"LocationManager test failed. Location is unreachable");
    };
    
    [locationManager addObservationBlock:^(CLLocation *location, NSError *error) {
        test(location, error);
        [locationObserverExpectation1 fulfill];
    } withIdentifier:@"first" queue:dispatch_get_main_queue()];
    
    [locationManager addObservationBlock:^(CLLocation *location, NSError *error) {
        test(location, error);
        [locationObserverExpectation2 fulfill];
    } withIdentifier:@"second" queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
    [locationManager startObserving];
    
    [self waitForExpectationsWithTimeout:kTimeout handler:^(NSError * _Nullable error) {
        [locationManager stopObserving];
        XCTAssertNil(error, @"LocationManager test failed. Error: %@", error.localizedDescription);
    }];
}

@end
