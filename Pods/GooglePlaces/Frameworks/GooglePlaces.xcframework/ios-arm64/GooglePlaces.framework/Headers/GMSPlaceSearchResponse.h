//
//  GMSPlaceSearchResponse.h
//  Google Places SDK for iOS
//
//  Copyright 2025 Google LLC
//
//  Usage of this SDK is subject to the Google Maps/Google Earth APIs Terms of
//  Service: https://cloud.google.com/maps-platform/terms
//

#import "GMSPlace.h"


/**
 * Protocol for the response to a place search request.
 */
@protocol GMSPlaceSearchResponse <NSObject>

/** The array of places that match the request. */
@property(readonly, nonatomic, copy, nullable) NSArray<GMSPlace *> *places;


@end
