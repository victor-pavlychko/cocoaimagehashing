//
//  OSDHash.m
//  CocoaImageHashing
//
//  Created by Andreas Meingast on 10/10/15.
//  Copyright © 2015 Andreas Meingast. All rights reserved.
//

#import "CocoaImageHashing+Internal.h"

static const NSUInteger OSDHashImageWidthInPixels = 9;
static const NSUInteger OSDHashImageHeightInPixels = 9;
static const OSHashDistanceType OSDHashDistanceThreshold = 9;

@implementation OSDHash

#pragma mark - OSImageHashing Protocol

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
    OSHashType result = dhash_rgba_9_9([imagePixels bytes]);
    return result;
}

- (CGSize)hashImageSizeInPiexls
{
    return CGSizeMake(OSDHashImageWidthInPixels, OSDHashImageHeightInPixels);
}

- (OSHashDistanceType)hashDistanceSimilarityThreshold
{
    return OSDHashDistanceThreshold;
}

@end
