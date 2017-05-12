//
//  OSImageHashing.m
//  CocoaImageHashing
//
//  Created by Andreas Meingast on 10/10/15.
//  Copyright © 2015 Andreas Meingast. All rights reserved.
//

#import "CocoaImageHashing+Internal.h"

@implementation OSImageHashing

+ (instancetype)sharedInstance
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      instance = [self new];
    });
    return instance;
}

#pragma mark - OSImageHashingProvider parametrizations

- (OSHashDistanceType)hashDistance:(OSHashType)leftHand
                                to:(OSHashType)rightHand
                    withProviderId:(OSImageHashingProviderId)providerId
{
    id<OSImageHashingProvider> provider = OSImageHashingProviderFromImageHashingProviderId(providerId);
    OSHashDistanceType result = [provider hashDistance:leftHand
                                                    to:rightHand];
    return result;
}

- (OSHashType)hashImage:(id<OSImageHashable>)image
         withProviderId:(OSImageHashingProviderId)providerId
{
    id<OSImageHashingProvider> provider = OSImageHashingProviderFromImageHashingProviderId(providerId);
    OSHashType result = [provider hashImage:image];
    return result;
}

- (CGSize)hashImageSizeInPiexlsWithProvider:(OSImageHashingProviderId)providerId
{
    id<OSImageHashingProvider> provider = OSImageHashingProviderFromImageHashingProviderId(providerId);
    CGSize result = provider.hashImageSizeInPiexls;
    return result;
}

- (OSHashDistanceType)hashDistanceSimilarityThresholdWithProvider:(OSImageHashingProviderId)providerId
{
    id<OSImageHashingProvider> provider = OSImageHashingProviderFromImageHashingProviderId(providerId);
    OSHashDistanceType result = [provider hashDistanceSimilarityThreshold];
    return result;
}

- (BOOL)compareImage:(id<OSImageHashable>)leftHandImage
                  to:(id<OSImageHashable>)rightHandImage
         withQuality:(OSImageHashingQuality)imageHashingQuality
{
    OSImageHashingProviderId hashingProvider = OSImageHashingProviderIdForHashingQuality(imageHashingQuality);
    BOOL result = [self compareImage:leftHandImage
                                  to:rightHandImage
                      withProviderId:hashingProvider];
    return result;
}

- (BOOL)compareImage:(id<OSImageHashable>)leftHandImage
                  to:(id<OSImageHashable>)rightHandImage
      withProviderId:(OSImageHashingProviderId)providerId
{
    id<OSImageHashingProvider> firstProdiver = OSImageHashingProviderFromImageHashingProviderId(providerId);
    OSHashDistanceType distanceThreshold = [firstProdiver hashDistanceSimilarityThreshold];
    BOOL result = [self compareImage:leftHandImage
                                  to:rightHandImage
                       withThreshold:distanceThreshold
                      withProviderId:providerId];
    return result;
}

- (BOOL)compareImage:(id<OSImageHashable>)leftHandImage
                  to:(id<OSImageHashable>)rightHandImage
       withThreshold:(OSHashDistanceType)distanceThreshold
      withProviderId:(OSImageHashingProviderId)providerId
{
    NSArray<id<OSImageHashingProvider>> *hashingProviders = NSArrayForProvidersFromOSImageHashingProviderId(providerId);
    for (id<OSImageHashingProvider> hashingProvider in hashingProviders) {
        BOOL result = [hashingProvider compareImage:leftHandImage
                                                 to:rightHandImage
                                      withThreshold:distanceThreshold];
        if (!result) {
            return NO;
        }
    }
    return YES;
}

- (NSComparator)imageSimilarityComparatorForBaseImage:(id<OSImageHashable>)baseImage
                                       withProviderId:(OSImageHashingProviderId)providerId
{
    id<OSImageHashingProvider> provider = OSImageHashingProviderFromImageHashingProviderId(providerId);
    NSComparator result = [provider imageSimilarityComparatorForBaseImage:baseImage];
    return result;
}

#pragma mark - Concurrent, stream based similarity search

- (NSArray<OSTuple<OSImageId *, OSImageId *> *> *)similarImagesWithHashingQuality:(OSImageHashingQuality)imageHashingQuality
                                                            forImageStreamHandler:(OSTuple<OSImageId *, id<OSImageHashable>> * (^)())imageStreamHandler
{
    OSImageHashingProviderId providerId = OSImageHashingProviderIdForHashingQuality(imageHashingQuality);
    id<OSImageHashingProvider> firstProvider = OSImageHashingProviderFromImageHashingProviderId(providerId);
    OSHashDistanceType hashDistanceTreshold = [firstProvider hashDistanceSimilarityThreshold];
    NSArray<OSTuple<OSImageId *, OSImageId *> *> *result = [self similarImagesWithHashingQuality:imageHashingQuality
                                                                       withHashDistanceThreshold:hashDistanceTreshold
                                                                           forImageStreamHandler:imageStreamHandler];
    return result;
}

- (NSArray<OSTuple<OSImageId *, OSImageId *> *> *)similarImagesWithHashingQuality:(OSImageHashingQuality)imageHashingQuality
                                                        withHashDistanceThreshold:(OSHashDistanceType)hashDistanceThreshold
                                                            forImageStreamHandler:(OSTuple<OSImageId *, id<OSImageHashable>> * (^)())imageStreamHandler
{
    OSImageHashingProviderId hashingProvider = OSImageHashingProviderIdForHashingQuality(imageHashingQuality);
    NSArray<OSTuple<NSString *, NSString *> *> *result = [self similarImagesWithProvider:hashingProvider
                                                               withHashDistanceThreshold:hashDistanceThreshold
                                                                   forImageStreamHandler:imageStreamHandler];
    return result;
}

- (NSArray<OSTuple<OSImageId *, OSImageId *> *> *)similarImagesWithProvider:(OSImageHashingProviderId)imageHashingProviderId
                                                      forImageStreamHandler:(OSTuple<OSImageId *, id<OSImageHashable>> * (^)())imageStreamHandler
{
    id<OSImageHashingProvider> firstProvider = OSImageHashingProviderFromImageHashingProviderId(imageHashingProviderId);
    OSHashDistanceType hashDistanceTreshold = [firstProvider hashDistanceSimilarityThreshold];
    NSArray<OSTuple<OSImageId *, OSImageId *> *> *result = [self similarImagesWithProvider:imageHashingProviderId
                                                                 withHashDistanceThreshold:hashDistanceTreshold
                                                                     forImageStreamHandler:imageStreamHandler];
    return result;
}

- (NSArray<OSTuple<OSImageId *, OSImageId *> *> *)similarImagesWithProvider:(OSImageHashingProviderId)imageHashingProviderId
                                                  withHashDistanceThreshold:(OSHashDistanceType)hashDistanceThreshold
                                                      forImageStreamHandler:(OSTuple<OSImageId *, id<OSImageHashable>> * (^)())imageStreamHandler
{
    id<OSImageHashingProvider> imageHashingProvider = OSImageHashingProviderFromImageHashingProviderId(imageHashingProviderId);
    NSArray<OSTuple<OSImageId *, OSImageId *> *> *result = [[OSSimilaritySearch sharedInstance] similarImagesWithProvider:imageHashingProvider
                                                                                                withHashDistanceThreshold:hashDistanceThreshold
                                                                                                    forImageStreamHandler:imageStreamHandler];
    return result;
}

#pragma mark - Concurrent, array based similarity search

- (NSArray<OSTuple<OSImageId *, OSImageId *> *> *)similarImagesWithHashingQuality:(OSImageHashingQuality)imageHashingQuality
                                                                        forImages:(NSArray<OSTuple<OSImageId *, id<OSImageHashable>> *> *)images
{
    OSImageHashingProviderId providerId = OSImageHashingProviderIdForHashingQuality(imageHashingQuality);
    id<OSImageHashingProvider> firstProvider = OSImageHashingProviderFromImageHashingProviderId(providerId);
    OSHashDistanceType hashDistanceTreshold = [firstProvider hashDistanceSimilarityThreshold];
    NSArray<OSTuple<OSImageId *, OSImageId *> *> *result = [self similarImagesWithHashingQuality:imageHashingQuality
                                                                       withHashDistanceThreshold:hashDistanceTreshold
                                                                                       forImages:images];
    return result;
}

- (NSArray<OSTuple<OSImageId *, OSImageId *> *> *)similarImagesWithHashingQuality:(OSImageHashingQuality)imageHashingQuality
                                                        withHashDistanceThreshold:(OSHashDistanceType)hashDistanceThreshold
                                                                        forImages:(NSArray<OSTuple<OSImageId *, id<OSImageHashable>> *> *)images
{
    OSImageHashingProviderId providerId = OSImageHashingProviderIdForHashingQuality(imageHashingQuality);
    NSArray<OSTuple<OSImageId *, OSImageId *> *> *result = [self similarImagesWithProvider:providerId
                                                                 withHashDistanceThreshold:hashDistanceThreshold
                                                                                 forImages:images];
    return result;
}

- (NSArray<OSTuple<OSImageId *, OSImageId *> *> *)similarImagesWithProvider:(OSImageHashingProviderId)imageHashingProviderId
                                                                  forImages:(NSArray<OSTuple<OSImageId *, id<OSImageHashable>> *> *)images
{
    id<OSImageHashingProvider> imageHashingProvider = OSImageHashingProviderFromImageHashingProviderId(imageHashingProviderId);
    OSHashDistanceType hashDistanceTreshold = [imageHashingProvider hashDistanceSimilarityThreshold];
    NSArray<OSTuple<OSImageId *, OSImageId *> *> *result = [self similarImagesWithProvider:imageHashingProviderId
                                                                 withHashDistanceThreshold:hashDistanceTreshold
                                                                                 forImages:images];
    return result;
}

- (NSArray<OSTuple<OSImageId *, OSImageId *> *> *)similarImagesWithProvider:(OSImageHashingProviderId)imageHashingProviderId
                                                  withHashDistanceThreshold:(OSHashDistanceType)hashDistanceThreshold
                                                                  forImages:(NSArray<OSTuple<OSImageId *, id<OSImageHashable>> *> *)images
{
    id<OSImageHashingProvider> imageHashingProvider = OSImageHashingProviderFromImageHashingProviderId(imageHashingProviderId);
    NSArray<OSTuple<OSImageId *, OSImageId *> *> *result = [[OSSimilaritySearch sharedInstance] similarImagesWithProvider:imageHashingProvider
                                                                                                withHashDistanceThreshold:hashDistanceThreshold
                                                                                                                forImages:images];
    return result;
}

#pragma mark - Array sorting with image similarity metrics for generic NSArrays

- (NSArray<id> *)sortedArrayUsingImageSimilartyComparator:(id<OSImageHashable>)baseImage
                                                 forArray:(NSArray<id> *)array
                                        forImageConverter:(id<OSImageHashable> (^)(id arrayElement))imageConverter
{
    OSImageHashingProviderId imageHashingProviderId = OSImageHashingProviderDefaultProviderId();
    return [self sortedArrayUsingImageSimilartyComparator:baseImage
                                                 forArray:array
                                forImageHashingProviderId:imageHashingProviderId
                                        forImageConverter:imageConverter];
}

- (NSArray<id> *)sortedArrayUsingImageSimilartyComparator:(id<OSImageHashable>)baseImage
                                                 forArray:(NSArray<id> *)array
                                forImageHashingProviderId:(OSImageHashingProviderId)imageHashingProviderId
                                        forImageConverter:(id<OSImageHashable> (^)(id arrayElement))imageConverter
{
    NSAssert(baseImage, @"Base image must not be null");
    NSAssert(array, @"Array must not be null");
    NSAssert(imageConverter, @"Image converter must not be null");
    NSComparator comparator = [self imageSimilarityComparatorForBaseImage:baseImage
                                                           withProviderId:imageHashingProviderId];
    NSArray<id> *result = [array sortedArrayUsingComparator:^NSComparisonResult(id leftHandElement, id rightHandElement) {
        id<OSImageHashable> leftHandImage = imageConverter(leftHandElement);
        id<OSImageHashable> rightHandImage = imageConverter(rightHandElement);
        NSComparisonResult comparisonResult = comparator(leftHandImage, rightHandImage);
        return comparisonResult;
    }];
    return result;
}

- (NSArray<id> *)sortedArrayUsingImageSimilartyComparator:(id<OSImageHashable>)baseImage
                                                 forArray:(NSArray<id> *)array
                                   forImageHashingQuality:(OSImageHashingQuality)imageHashingQuality
                                        forImageConverter:(id<OSImageHashable> (^)(id arrayElement))imageConverter
{
    OSImageHashingProviderId imageHashingProviderId = OSImageHashingProviderIdForHashingQuality(imageHashingQuality);
    return [self sortedArrayUsingImageSimilartyComparator:baseImage
                                                 forArray:array
                                forImageHashingProviderId:imageHashingProviderId
                                        forImageConverter:imageConverter];
}

#pragma mark - Array sorting with image similarity metrics for NSData NSArrays

- (NSArray<id<OSImageHashable>> *)sortedArrayUsingImageSimilartyComparator:(id<OSImageHashable>)baseImage
                                                                  forArray:(NSArray<id<OSImageHashable>> *)array
{
    NSArray<id<OSImageHashable>> *result = [self sortedArrayUsingImageSimilartyComparator:baseImage
                                                                                 forArray:array
                                                                        forImageConverter:^id<OSImageHashable>(id<OSImageHashable>arrayElement) {
                                                                            return arrayElement;
                                                                        }];
    return result;
}

- (NSArray<id<OSImageHashable>> *)sortedArrayUsingImageSimilartyComparator:(id<OSImageHashable>)baseImage
                                                                  forArray:(NSArray<id<OSImageHashable>> *)array
                                                 forImageHashingProviderId:(OSImageHashingProviderId)imageHashingProviderId
{
    NSArray<id<OSImageHashable>> *result = [self sortedArrayUsingImageSimilartyComparator:baseImage
                                                                                 forArray:array
                                                                forImageHashingProviderId:imageHashingProviderId
                                                                        forImageConverter:^id<OSImageHashable>(id<OSImageHashable> arrayElement) {
                                                                            return arrayElement;
                                                                        }];
    return result;
}

- (NSArray<id<OSImageHashable>> *)sortedArrayUsingImageSimilartyComparator:(id<OSImageHashable>)baseImage
                                                                  forArray:(NSArray<id<OSImageHashable>> *)array
                                                    forImageHashingQuality:(OSImageHashingQuality)imageHashingQuality
{
    NSArray<id<OSImageHashable>> *result = [self sortedArrayUsingImageSimilartyComparator:baseImage
                                                                      forArray:array
                                                        forImageHashingQuality:imageHashingQuality
                                                             forImageConverter:^id<OSImageHashable>(id<OSImageHashable>arrayElement) {
                                                                 return arrayElement;
                                                             }];
    return result;
}

#pragma mark - Result Conversion

- (NSDictionary<OSImageId *, NSSet<OSImageId *> *> *)dictionaryFromSimilarImagesResult:(NSArray<OSTuple<OSImageId *, OSImageId *> *> *)similarImageTuples
{
    NSDictionary<OSImageId *, NSSet<OSImageId *> *> *result = [[OSSimilaritySearch sharedInstance] dictionaryFromSimilarImagesResult:similarImageTuples];
    return result;
}

@end
