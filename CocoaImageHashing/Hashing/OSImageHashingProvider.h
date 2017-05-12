//
//  OSImageHashingProvider.h
//  CocoaImageHashing
//
//  Created by Victor Pavlychko on 5/12/17.
//  Copyright © 2017 Andreas Meingast. All rights reserved.
//

#import "OSTypes.h"
#import "OSImageHashable.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Create perceptual fingerprints for image data.
 *
 * OSImageHashingProviders have to offer the following functionality
 *
 * 1. Creating a 64-bit fingerprint for a given image
 * 2. Calculating the distance between two fingerprints
 * 3. Having a default similarity threshold that can be used if two images are similar
 * 4. Determining if two images are similar
 */
@protocol OSImageHashingProvider

/**
 * Returns a shared instance for the hashing provider.
 */
+ (instancetype)sharedInstance;

/**
 * Calculate the fingerprint/hash for a given image.
 *
 * The result is a 64-bit number. Returns OSHashTypeError if an error occurs during image processing.
 */
- (OSHashType)hashImage:(id<OSImageHashable>)image;

/**
 * Calculate the hash distance between two fingerprints/hashes.
 *
 * The hash distance is defined as the bit-to-bit difference between `leftHand` and `rightHand`.
 *
 * The `leftHand` and `rightHand` parameters must not be OSHashTypeError.
 */
- (OSHashDistanceType)hashDistance:(OSHashType)leftHand
                                to:(OSHashType)rightHand;

/**
 * Defines input image size used by the hasing algorithm.
 *
 * This value depends on the algorithm in the concrete OSImageHashingProvider implementation.
 */
@property (nonatomic, readonly) CGSize hashImageSizeInPiexls;

/**
 * Determines the threshold when two image fingerprints are to be considered similar.
 *
 * This value depends on the algorithm in the concrete OSImageHashingProvider implementation.
 */
@property (nonatomic, readonly) OSHashDistanceType hashDistanceSimilarityThreshold;

/**
 * Determines if two images (in this case, their data representation) are similar.
 *
 * Two images are said to be similar if the following statement holds:
 *
 *      distance(Fingerprint(image1), Fingerprint(image2)) < DistanceThreshold
 */
- (BOOL)compareImage:(id<OSImageHashable>)leftHandImage
                  to:(id<OSImageHashable>)rightHandImage;

/**
 * @see -[OSImageHashing compareImageData::]
 */
- (BOOL)compareImage:(id<OSImageHashable>)leftHandImage
                  to:(id<OSImageHashable>)rightHandImage
       withThreshold:(OSHashDistanceType)distanceThreshold;

/**
 * This method is used to create an NSComparator which can be used to sort an image collection wrt their similarity to a image.
 */
- (NSComparator)imageSimilarityComparatorForBaseImage:(id<OSImageHashable>)baseImage;

@end

NS_ASSUME_NONNULL_END
