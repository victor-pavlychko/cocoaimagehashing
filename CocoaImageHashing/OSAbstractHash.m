//
//  OSAbstractHash.m
//  CocoaImageHashing
//
//  Created by Andreas Meingast on 16/10/15.
//  Copyright © 2015 Andreas Meingast. All rights reserved.
//

#import "OSAbstractHash.h"
#import "OSCategories.h"
#import "OSImageHashing.h"
#import "OSTypes+Internal.h"

@implementation OSAbstractHash

#pragma mark - OSImageHashing Protocol

- (OSHashType)hashImage:(id<OSImageHashable>)image
{
    NSAssert(image, @"Image must not be null");
    CGSize imageSize = self.hashImageSizeInPiexls;
    NSData *pixels = [image os_RGBABitmapDataWithSize:imageSize];
    if (!pixels) {
        return OSHashTypeError;
    }
    
    return [self hashImagePixels:pixels];
}

- (OSHashDistanceType)hashDistance:(OSHashType)leftHand
                                to:(OSHashType)rightHand
{
    NSAssert(leftHand != OSHashTypeError, @"Left hand hash must not be OSHashTypeError");
    NSAssert(rightHand != OSHashTypeError, @"Right hand hash must not be OSHashTypeError");
    return OSHammingDistance(leftHand, rightHand);
}

- (BOOL)compareImage:(id<OSImageHashable>)leftHandImage
                  to:(id<OSImageHashable>)rightHandImage
{
    NSAssert(leftHandImage, @"Left hand image must not be null");
    NSAssert(rightHandImage, @"Right hand image must not be null");
    BOOL result = [self compareImage:leftHandImage
                                  to:rightHandImage
                       withThreshold:[self hashDistanceSimilarityThreshold]];
    return result;
}

- (BOOL)compareImage:(id<OSImageHashable>)leftHandImage
                  to:(id<OSImageHashable>)rightHandImage
       withThreshold:(OSHashDistanceType)distanceThreshold
{
    NSAssert(leftHandImage, @"Left hand image must not be null");
    NSAssert(rightHandImage, @"Right hand image must not be null");
    OSHashType leftHandImageHash = [self hashImage:leftHandImage];
    OSHashType rightHandImageHash = [self hashImage:rightHandImage];
    if (leftHandImageHash == OSHashTypeError || rightHandImageHash == OSHashTypeError) {
        return NO;
    }
    OSHashDistanceType distance = [self hashDistance:leftHandImageHash
                                                  to:rightHandImageHash];
    return distance < distanceThreshold;
}

- (NSComparisonResult)imageSimilarityComparatorForImageForBaseImage:(id<OSImageHashable>)baseImage
                                                   forLeftHandImage:(id<OSImageHashable>)leftHandImage
                                                  forRightHandImage:(id<OSImageHashable>)rightHandImage
{
    NSAssert(baseImage, @"Base image must not be null");
    NSAssert(rightHandImage, @"Right hand image must not be null");
    NSAssert(leftHandImage, @"Left hand image must not be null");
    NSAssert(rightHandImage, @"Right hand image must not be null");
    OSHashType leftHandImageHash = [self hashImage:leftHandImage];
    OSHashType rightHandImageHash = [self hashImage:rightHandImage];
    OSHashType baseImageHash = [self hashImage:baseImage];
    if (baseImageHash == OSHashTypeError) {
        return NSOrderedSame;
    } else if (leftHandImageHash == OSHashTypeError) {
        return NSOrderedDescending;
    } else if (rightHandImageHash == OSHashTypeError) {
        return NSOrderedAscending;
    }
    OSHashDistanceType distanceToLeftImage = [self hashDistance:leftHandImageHash
                                                             to:baseImageHash];
    OSHashDistanceType distanceToRightImage = [self hashDistance:rightHandImageHash
                                                              to:baseImageHash];
    if (distanceToLeftImage < distanceToRightImage) {
        return NSOrderedAscending;
    } else if (distanceToLeftImage > distanceToRightImage) {
        return NSOrderedDescending;
    } else {
        return NSOrderedSame;
    }
}

#pragma mark - Abstract methods

+ (instancetype)sharedInstance
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Abstract method called."
                                 userInfo:nil];
}

- (CGSize)hashImageSizeInPiexls
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Abstract method called."
                                 userInfo:nil];
}

- (OSHashDistanceType)hashDistanceSimilarityThreshold
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Abstract method called."
                                 userInfo:nil];
}

- (OSHashType)hashImagePixels:(NSData * OS_UNUSED)imagePixels
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Abstract method called."
                                 userInfo:nil];
}

@end
