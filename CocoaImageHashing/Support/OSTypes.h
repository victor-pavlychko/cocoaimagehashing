//
//  OSTypes.h
//  CocoaImageHashing
//
//  Created by Andreas Meingast on 14/10/15.
//  Copyright © 2015 Andreas Meingast. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

/**
 * OSHashType represents a fingerprint of an image.
 *
 * OSHashTypeError represents an error in the hash calculation.
 */
typedef SInt64 OSHashType; // __attribute__((swift_wrapper(struct)));

/**
 * OSHashDistanceType represents the distance between two image fingerprints.
 */
typedef SInt64 OSHashDistanceType;

/**
 * A type alias to help identify images by an id.
 */
typedef NSString OSImageId;

#pragma mark - Error Values

/**
 * OSHashTypeError represents an OSHashType error result.
 */
extern const OSHashType OSHashTypeError NS_SWIFT_NAME(OSHashType.error);

NS_ASSUME_NONNULL_END
