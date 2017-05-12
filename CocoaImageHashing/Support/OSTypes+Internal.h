//
//  OSTypes+Internal.h
//  CocoaImageHashing
//

#import "OSTypes.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Utility Macros

#define OS_ALIGN(x, multiple) ({ __typeof__(x) m = (multiple) - 1; ((x) + m) & ~m; })

#pragma mark - Primitive Type Functions and Utilities

OS_INLINE OSHashDistanceType OSHammingDistance(OSHashType leftHand, OSHashType rightHand)
{
    return (OSHashDistanceType)__builtin_popcountll((UInt64)leftHand ^ (UInt64)rightHand);
}

OS_INLINE OS_ALWAYS_INLINE NSUInteger OSBytesPerRowForSize(CGSize size)
{
    return ((NSInteger)size.width == 8) ? 32 : OS_ALIGN(4 * (NSUInteger)size.width, 64);
}

OS_INLINE OS_ALWAYS_INLINE NSUInteger OSBytesForSize(CGSize size)
{
    return OSBytesPerRowForSize(size) * (NSUInteger)size.height;
}

#pragma mark - Non-null Check Helpers

/**
 * A workaround class to defeat CLANGs warnings for some GNU-extensions for C for null-checking.
 */
@interface OSNonNullHolder <__covariant Type>

- (Type)el;

@end

#define OS_CAST_NONNULL(V)                  \
    ({                                      \
        OSNonNullHolder<__typeof(V)> *type; \
        (__typeof(type.el)) V;              \
    })

NS_ASSUME_NONNULL_END
