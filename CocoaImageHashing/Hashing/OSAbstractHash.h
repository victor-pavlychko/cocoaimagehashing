//
//  OSAbstractHash.h
//  CocoaImageHashing
//
//  Created by Andreas Meingast on 16/10/15.
//  Copyright © 2015 Andreas Meingast. All rights reserved.
//

#import "OSImageHashingProvider.h"

NS_ASSUME_NONNULL_BEGIN

@interface OSAbstractHash : NSObject <OSImageHashingProvider>

/**
 * Calculate the fingerprint/hash for a given image.
 *
 * The input is 32bpp RGBA raw bitmap data with `hashImageSizeInPiexls` dimensions.
 * The result is a 64-bit number. Returns OSHashTypeError if an error occurs during image processing.
 */
- (OSHashType)hashImagePixels:(NSData *)imagePixels;

@end

NS_ASSUME_NONNULL_END
