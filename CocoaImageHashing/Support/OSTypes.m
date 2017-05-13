//
//  OSTypes.m
//  CocoaImageHashing
//
//  Created by Andreas Meingast on 15/10/15.
//  Copyright © 2015 Andreas Meingast. All rights reserved.
//

#import "CocoaImageHashing+Internal.h"

#pragma mark - Error Values

const OSHashType OSHashTypeError = -1;

#pragma mark - Primitive Type Functions and Utilities

inline OSImageHashingProviderId OSImageHashingProviderIdFromString(NSString *name)
{
    NSCAssert(name, @"Image hashing provider name must not be null");
    if ([name isEqualToString:@"aHash"]) {
        return OSImageHashingProviderAHash;
    } else if ([name isEqualToString:@"dHash"]) {
        return OSImageHashingProviderDHash;
    } else if ([name isEqualToString:@"pHash"]) {
        return OSImageHashingProviderPHash;
    } else {
        return OSImageHashingProviderNone;
    }
}

inline NSString *NSStringFromOSImageHashingProviderId(OSImageHashingProviderId providerId)
{
    switch (providerId) {
        case OSImageHashingProviderAHash:
            return @"aHash";
        case OSImageHashingProviderDHash:
            return @"dHash";
        case OSImageHashingProviderPHash:
            return @"pHash";
        case OSImageHashingProviderNone:
            return @"None";
    }
    return nil;
}

inline NSArray<NSNumber *> *NSArrayFromOSImageHashingProviderId()
{
    return @[@(OSImageHashingProviderAHash), @(OSImageHashingProviderDHash), @(OSImageHashingProviderPHash)];
}

inline NSArray<NSString *> *NSArrayFromOSImageHashingProviderIdNames()
{
    NSMutableArray<NSString *> *result = [NSMutableArray new];
    for (NSNumber *providerNumber in NSArrayFromOSImageHashingProviderId()) {
        OSImageHashingProviderId category = (OSImageHashingProviderId)[providerNumber integerValue];
        NSString *providerName = NSStringFromOSImageHashingProviderId(category);
        [result addObject:providerName];
    }
    return result;
}

inline id<OSImageHashingProvider> OSImageHashingProviderFromImageHashingProviderId(OSImageHashingProviderId imageHashingProviderId)
{
    NSArray<id<OSImageHashingProvider>> *providers = NSArrayForProvidersFromOSImageHashingProviderId(imageHashingProviderId);
    id<OSImageHashingProvider> provider = [providers firstObject];
    return provider;
}

inline NSArray<id<OSImageHashingProvider>> *NSArrayForProvidersFromOSImageHashingProviderId(OSImageHashingProviderId imageHashingProviderId)
{
    NSMutableArray<id<OSImageHashingProvider>> *providers = [NSMutableArray new];
    if ((imageHashingProviderId & OSImageHashingProviderDHash)) {
        [providers addObject:[OSDHash sharedInstance]];
    }
    if ((imageHashingProviderId & OSImageHashingProviderPHash)) {
        [providers addObject:[OSPHash sharedInstance]];
    }
    if ((imageHashingProviderId & OSImageHashingProviderAHash)) {
        [providers addObject:[OSAHash sharedInstance]];
    }
    return providers;
}
