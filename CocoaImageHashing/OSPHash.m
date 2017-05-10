//
//  OSPHash.m
//  CocoaImageHashing
//
//  Created by Andreas Meingast on 10/10/15.
//  Copyright © 2015 Andreas Meingast. All rights reserved.
//

#import "OSCategories.h"
#import "OSFastGraphics.h"
#import "OSPHash.h"

static const NSUInteger OSPHashImageWidthInPixels = 32;
static const NSUInteger OSPHashImageHeightInPixels = 32;
static const OSHashDistanceType OSPHashDistanceThreshold = 10;

@implementation OSPHash

#pragma mark - OSImageHashingProvider

+ (instancetype)sharedInstance
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (OSHashType)hashImagePixels:(NSData *)imagePixels
{
    NSAssert(imagePixels, @"Image pixels must not be null");
    double greyscalePixels[OSPHashImageWidthInPixels][OSPHashImageHeightInPixels] = {{0.0}};
    double dctPixels[OSPHashImageWidthInPixels][OSPHashImageHeightInPixels] = {{0.0}};
    greyscale_pixels_rgba_32_32([imagePixels bytes], greyscalePixels);
    fast_dct_rgba_32_32(greyscalePixels, dctPixels);
    double dctAverage = fast_avg_no_first_el_rgba_8_8(dctPixels);
    OSHashType result = phash_rgba_8_8(dctPixels, dctAverage);
    return result;
}

- (CGSize)hashImageSizeInPiexls
{
    return CGSizeMake(OSPHashImageWidthInPixels, OSPHashImageHeightInPixels);
}

- (OSHashDistanceType)hashDistanceSimilarityThreshold
{
    return OSPHashDistanceThreshold;
}

@end
