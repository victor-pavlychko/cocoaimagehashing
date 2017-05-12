//
//  OSTuple.h
//  CocoaImageHashing
//
//  Created by Victor Pavlychko on 5/12/17.
//  Copyright © 2017 Andreas Meingast. All rights reserved.
//

#import "OSImageHashingProvider.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * A fast, lockless, generic  2-tuple implementation.
 */
@interface OSTuple<A, B> : NSObject

@property (strong, nonatomic, nullable) A first;
@property (strong, nonatomic, nullable) B second;

/**
 * A factory method to instantiate a OSTuple with two given parameters.
 */
+ (nonnull instancetype)tupleWithFirst:(nullable A)first
                             andSecond:(nullable B)second;

/**
 * A factory method to instantiate a OSTuple with two given parameters.
 */
- (nonnull instancetype)initWithFirst:(nullable A)first
                            andSecond:(nullable B)second;

@end

/**
 * A fast, lockless, specific 2-tuple implementation storing a generic first-value and a OSHAshType second-value.
 */
@interface OSHashResultTuple<A> : NSObject

@property (strong, nonatomic, nullable) A first;
@property (nonatomic) OSHashType hashResult;

@end

NS_ASSUME_NONNULL_END
