//
//  OSImageHashing.h
//  CocoaImageHashing
//
//  Created by Andreas Meingast on 10/10/15.
//  Copyright © 2015 Andreas Meingast. All rights reserved.
//

#import "OSImageHashingProvider.h"
#import "OSSimilaritySearch.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * OSImageHashingProviderId is a combinable id-type to identify OSImageHashing providers.
 * This type is used in the OSImageHashing API to configure a specific OSImageHashing provider.
 *
 * If two or more providers are combined, their order is defined as follows:
 *      OSImageHashingProviderDHash < OSImageHashingProviderPHash < OSImageHashingProviderAHash
 */
typedef NS_OPTIONS(UInt16, OSImageHashingProviderId) {
    OSImageHashingProviderAHash = 1 << 0,
    OSImageHashingProviderDHash = 1 << 1,
    OSImageHashingProviderPHash = 1 << 2,
    OSImageHashingProviderNone = 0
};

/**
 * OSImageHashingQuality represents the quality used to calculate image hashes. The higher the quality, the more CPU
 * time and memory is consumed for calculating the image fingerprints.
 *
 * Selecting a higher priority typically improves hashing quality and reduces number of false-positives significantly
 * (by chaining different hashing providers to refine and check the calculated result).
 */
typedef NS_ENUM(UInt16, OSImageHashingQuality) {
    OSImageHashingQualityLow,
    OSImageHashingQualityMedium,
    OSImageHashingQualityHigh,
    OSImageHashingQualityNone
};

/**
 * The OSImageHashing class is the primary way to interact with the CocoaImageHashing framework.
 *
 * It provides APIs for:
 *
 * 1. fingerprint/hash calculation
 * 2. a fingerprint metric
 * 3. concurrent array based similarity search
 * 4. concurrent stream based similarity search
 * 5. sequential array sorting based on fingerprint metrics
 */
@interface OSImageHashing : NSObject

/**
 * @brief Factory method for instantiating OSImageHashing objects.
 * @return an initialized (shared) OSImageHashing object.
 */
+ (instancetype)sharedInstance;

#pragma mark - OSImageHashingProvider parametrizations

/**
 * @see -[OSImageHashingProvider hashDistance:to:]
 */
- (OSHashDistanceType)hashDistance:(OSHashType)leftHand
                                to:(OSHashType)rightHand
                    withProviderId:(OSImageHashingProviderId)providerId;

/**
 * @see -[OSImageHashingProvider hashImage:]
 */
- (OSHashType)hashImage:(id<OSImageHashable>)image
         withProviderId:(OSImageHashingProviderId)providerId;

/**
 * @see -[OSImageHashingProvider hashImageSizeInPiexls]
 */
- (CGSize)hashImageSizeInPiexlsWithProvider:(OSImageHashingProviderId)providerId;

/**
 * @see -[OSImageHashingProvider hashDistanceSimilarityThreshold]
 */
- (OSHashDistanceType)hashDistanceSimilarityThresholdWithProvider:(OSImageHashingProviderId)providerId;

/**
 * @see -[OSImageHashingProvider compareImage:to:]
 */
- (BOOL)compareImage:(id<OSImageHashable>)leftHandImage
                  to:(id<OSImageHashable>)rightHandImage
         withQuality:(OSImageHashingQuality)imageHashingQuality;

/**
 * @see -[OSImageHashingProvider compareImage:to:]
 */
- (BOOL)compareImage:(id<OSImageHashable>)leftHandImage
                  to:(id<OSImageHashable>)rightHandImage
      withProviderId:(OSImageHashingProviderId)providerId;

/**
 * @see -[OSImageHashingProvider compareImage:to:withThreshold:]
 */
- (BOOL)compareImage:(id<OSImageHashable>)leftHandImage
                  to:(id<OSImageHashable>)rightHandImage
       withThreshold:(OSHashDistanceType)distanceThreshold
      withProviderId:(OSImageHashingProviderId)providerId;

/**
 * @see -[OSImageHashingProvider imageSimilarityComparatorForBaseImage:]
 */
- (NSComparator)imageSimilarityComparatorForBaseImage:(id<OSImageHashable>)baseImage
                                       withProviderId:(OSImageHashingProviderId)providerId;

#pragma mark - Concurrent, stream based similarity search

/**
 * Given a stream of images, create an NSArray of tuples containing similar images.
 * 
 * Data is provided through the imageStreamHandler parameter. Returning nil inside imageStreamHandler
 * signals that the stream was closed and no more data is available.
 * 
 * This method nils out all data-tuples it receives allowing for swift garbage collection. If there are no further
 * references to the provided data-tuples, this method will execute in (almost) constant space wrt to image-data.
 *
 * A typical use-case for this method call is to stream uniquely identifiable image-data from a storage system 
 * (e.g. hard-drive, network), then look for similarities and in a second step report that information back to the user.
 * Such an ID can for example be the unique file-path of an image on disk or a database-id referencing an image.
 */
- (NSArray<OSTuple<OSImageId *, OSImageId *> *> *)similarImagesWithHashingQuality:(OSImageHashingQuality)imageHashingQuality
                                                            forImageStreamHandler:(OSTuple<OSImageId *, id<OSImageHashable>> * (^)())imageStreamHandler;

/**
 * @see -[OSImageHashing similarImagesWithHashingQuality::]
 */
- (NSArray<OSTuple<OSImageId *, OSImageId *> *> *)similarImagesWithHashingQuality:(OSImageHashingQuality)imageHashingQuality
                                                        withHashDistanceThreshold:(OSHashDistanceType)hashDistanceThreshold
                                                            forImageStreamHandler:(OSTuple<OSImageId *, id<OSImageHashable>> * (^)())imageStreamHandler;

/**
 * @see -[OSImageHashing similarImagesWithHashingQuality::]
 */
- (NSArray<OSTuple<OSImageId *, OSImageId *> *> *)similarImagesWithProvider:(OSImageHashingProviderId)imageHashingProviderId
                                                      forImageStreamHandler:(OSTuple<OSImageId *, id<OSImageHashable>> * (^)())imageStreamHandler;

/**
 * @see -[OSImageHashing similarImagesWithHashingQuality::]
 */
- (NSArray<OSTuple<OSImageId *, OSImageId *> *> *)similarImagesWithProvider:(OSImageHashingProviderId)imageHashingProviderId
                                                  withHashDistanceThreshold:(OSHashDistanceType)hashDistanceThreshold
                                                      forImageStreamHandler:(OSTuple<OSImageId *, id<OSImageHashable>> * (^)())imageStreamHandler;

#pragma mark - Concurrent, array based similarity search

/**
 * Given an NSArray of images, create an NSArray of tuples containing similar images.
 *
 * This method requires all image-data to be present in-memory making it impractical for batch operations or
 * handling large data-sets.
 *
 * A typical use-case for this call is to find similar images for a data-set that is already present in memory or 
 * small enough to disregard the memory consumption.
 */
- (NSArray<OSTuple<OSImageId *, OSImageId *> *> *)similarImagesWithHashingQuality:(OSImageHashingQuality)imageHashingQuality
                                                                        forImages:(NSArray<OSTuple<OSImageId *, id<OSImageHashable>> *> *)images;

/**
 * @see -[OSImageHashing similarImagesWithHashingQuality::];
 */
- (NSArray<OSTuple<OSImageId *, OSImageId *> *> *)similarImagesWithHashingQuality:(OSImageHashingQuality)imageHashingQuality
                                                        withHashDistanceThreshold:(OSHashDistanceType)hashDistanceThreshold
                                                                        forImages:(NSArray<OSTuple<OSImageId *, id<OSImageHashable>> *> *)images;

/**
 * @see -[OSImageHashing similarImagesWithHashingQuality::];
 */
- (NSArray<OSTuple<OSImageId *, OSImageId *> *> *)similarImagesWithProvider:(OSImageHashingProviderId)imageHashingProviderId
                                                                  forImages:(NSArray<OSTuple<OSImageId *, id<OSImageHashable>> *> *)images;

/**
 * @see -[OSImageHashing similarImagesWithHashingQuality::];
 */
- (NSArray<OSTuple<OSImageId *, OSImageId *> *> *)similarImagesWithProvider:(OSImageHashingProviderId)imageHashingProviderId
                                                  withHashDistanceThreshold:(OSHashDistanceType)hashDistanceThreshold
                                                                  forImages:(NSArray<OSTuple<OSImageId *, id<OSImageHashable>> *> *)images;

#pragma mark - Array sorting with image similarity metrics for generic NSArrays

/**
 * Sort a generic NSArray with a sort-order defined by the array's content-images distance to a base image.
 */
- (NSArray<id> *)sortedArrayUsingImageSimilartyComparator:(id<OSImageHashable>)baseImage
                                                 forArray:(NSArray<id> *)array
                                        forImageConverter:(id<OSImageHashable> (^)(id arrayElement))imageConverter;
/*
 * @see -[OSImageHashing sortedArrayUsingImageSimilartyComparator:::];
 */
- (NSArray<id> *)sortedArrayUsingImageSimilartyComparator:(id<OSImageHashable>)baseImage
                                                 forArray:(NSArray<id> *)array
                                forImageHashingProviderId:(OSImageHashingProviderId)imageHashingProviderId
                                        forImageConverter:(id<OSImageHashable> (^)(id arrayElement))imageConverter;

/*
 * @see -[OSImageHashing sortedArrayUsingImageSimilartyComparator:::];
 */
- (NSArray<id> *)sortedArrayUsingImageSimilartyComparator:(id<OSImageHashable>)baseImage
                                                 forArray:(NSArray<id> *)array
                                   forImageHashingQuality:(OSImageHashingQuality)imageHashingQuality
                                        forImageConverter:(id<OSImageHashable> (^)(id arrayElement))imageConverter;

#pragma mark - Array sorting with image similarity metrics for NSData NSArrays

/**
 * Sort an NSArray containing image-data with a sort-order defined by the array's content-images distance to a base image.
 */
- (NSArray<id<OSImageHashable>> *)sortedArrayUsingImageSimilartyComparator:(id<OSImageHashable>)baseImage
                                                                  forArray:(NSArray<id<OSImageHashable>> *)array;

/**
 * @see -[OSImageHashing sortedArrayUsingImageSimilartyComparator::];
 */
- (NSArray<id<OSImageHashable>> *)sortedArrayUsingImageSimilartyComparator:(id<OSImageHashable>)baseImage
                                                                  forArray:(NSArray<id<OSImageHashable>> *)array
                                                 forImageHashingProviderId:(OSImageHashingProviderId)imageHashingProviderId;

/**
 * @see -[OSImageHashing sortedArrayUsingImageSimilartyComparator::];
 */
- (NSArray<id<OSImageHashable>> *)sortedArrayUsingImageSimilartyComparator:(id<OSImageHashable>)baseImage
                                                                  forArray:(NSArray<id<OSImageHashable>> *)array
                                                    forImageHashingQuality:(OSImageHashingQuality)imageHashingQuality;

#pragma mark - Result Conversion

/**
 * @brief A utility conversion method to transform the result of similarImages* methods into an NSDictionary.
 */
- (NSDictionary<OSImageId *, NSSet<OSImageId *> *> *)dictionaryFromSimilarImagesResult:(NSArray<OSTuple<OSImageId *, OSImageId *> *> *)similarImageTuples;

@end

#pragma mark - Primitive Type Functions and Utilities

OSImageHashingProviderId OSImageHashingProviderDefaultProviderId(void);

OSImageHashingProviderId OSImageHashingProviderIdFromString(NSString *name);
NSString *NSStringFromOSImageHashingProviderId(OSImageHashingProviderId providerId);
NSArray<NSNumber *> *NSArrayFromOSImageHashingProviderId(void);
NSArray<NSString *> *NSArrayFromOSImageHashingProviderIdNames();

OSImageHashingQuality OSImageHashingQualityFromString(NSString *name);
NSString *NSStringFromOSImageHashingQuality(OSImageHashingQuality hashingQuality);
NSArray<NSNumber *> *NSArrayFromOSImageHashingQuality(void);
NSArray<NSString *> *NSArrayFromOSImageHashingQualityNames(void);

OSImageHashingProviderId OSImageHashingProviderIdForHashingQuality(OSImageHashingQuality hashingQuality);
id<OSImageHashingProvider> OSImageHashingProviderFromImageHashingProviderId(OSImageHashingProviderId imageHashingProviderId);
NSArray<id<OSImageHashingProvider>> *NSArrayForProvidersFromOSImageHashingProviderId(OSImageHashingProviderId imageHashingProviderId);

NS_ASSUME_NONNULL_END
