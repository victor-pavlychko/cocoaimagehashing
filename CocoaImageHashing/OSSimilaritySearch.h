//
//  OSSimilaritySearch.h
//  CocoaImageHashing
//
//  Created by Andreas Meingast on 16/10/15.
//  Copyright © 2015 Andreas Meingast. All rights reserved.
//

#import "OSTypes+Internal.h"

@interface OSSimilaritySearch : NSObject

NS_ASSUME_NONNULL_BEGIN

+ (instancetype)sharedInstance;

#pragma mark - Array & Stream Based Similarity Search

- (void)similarImagesWithProvider:(id<OSImageHashingProvider>)imageHashingProvider
        withHashDistanceThreshold:(OSHashDistanceType)hashDistanceThreshold
            forImageStreamHandler:(OSTuple<OSImageId *, id<OSImageHashable>> * (^)())imageStreamHandler
                 forResultHandler:(void (^)(OSImageId * __unsafe_unretained leftHandImageId, OSImageId * __unsafe_unretained rightHandImageId))resultHandler;

- (NSArray<OSTuple<OSImageId *, OSImageId *> *> *)similarImagesWithProvider:(id<OSImageHashingProvider>)imageHashingProvider
                                                  withHashDistanceThreshold:(OSHashDistanceType)hashDistanceThreshold
                                                      forImageStreamHandler:(OSTuple<OSImageId *, id<OSImageHashable>> * (^)())imageStreamHandler;

- (NSArray<OSTuple<OSImageId *, OSImageId *> *> *)similarImagesWithProvider:(id<OSImageHashingProvider>)imageHashingProvider
                                                  withHashDistanceThreshold:(OSHashDistanceType)hashDistanceThreshold
                                                                  forImages:(NSArray<OSTuple<OSImageId *, id<OSImageHashable>> *> *)imageTuples;

#pragma mark - Result Conversion

- (NSDictionary<OSImageId *, NSSet<OSImageId *> *> *)dictionaryFromSimilarImagesResult:(NSArray<OSTuple<OSImageId *, OSImageId *> *> *)similarImageTuples;

NS_ASSUME_NONNULL_END

@end
