//
//  OSCategories.m
//  CocoaImageHashing
//
//  Created by Andreas Meingast on 11/10/15.
//  Copyright © 2015 Andreas Meingast. All rights reserved.
//

#import "OSCategories.h"
#import "OSTypes+Internal.h"

@import Darwin.libkern.OSAtomic;

#pragma mark - NSArray Category

@implementation NSArray (CocoaImageHashing)

- (NSArray<OSTuple<id, id> *> *)arrayWithPairCombinations
{
    NSMutableArray<OSTuple<id, id> *> *pairs = [NSMutableArray new];
    OSSpinLock volatile __block lock = OS_SPINLOCK_INIT;
    [self enumeratePairCombinationsUsingBlock:^(id __unsafe_unretained leftHand, id __unsafe_unretained rightHand) {
      OSTuple<id, id> *tuple = [OSTuple tupleWithFirst:leftHand
                                             andSecond:rightHand];
      OSSpinLockLock(&lock);
      [pairs addObject:tuple];
      OSSpinLockUnlock(&lock);
    }];
    return pairs;
}

- (void)enumeratePairCombinationsUsingBlock:(void (^)(id __unsafe_unretained leftHand, id __unsafe_unretained rightHand))block
{
    NSUInteger count = [self count];
    if (!count) {
        return;
    }
    id __unsafe_unretained *objects = (id __unsafe_unretained *)malloc(sizeof(id) * count);
    if (!objects) {
        return;
    }
    [self getObjects:objects range:NSMakeRange(0, count)];
    dispatch_apply(count - 1, dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^(size_t i) {
        id __unsafe_unretained left = objects[i];
        for (NSUInteger j = i + 1; j < count; j++) {
            id __unsafe_unretained right = objects[j];
            block(left, right);
        }
    });
    free(objects);
}

@end

#pragma mark - NSData Category

OS_INLINE OS_ALWAYS_INLINE NSUInteger OSBytesPerRowForSize(CGSize size)
{
    return ((NSInteger)size.width == 8) ? 32 : OS_ALIGN(4 * (NSUInteger)size.width, 64);
}

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

@implementation NSData (CocoaImageHashing)

- (nullable NSData *)RGBABitmapDataWithSize:(CGSize)size
{
    UIImage *baseImage = [UIImage imageWithData:self];
    if (!baseImage) {
        return nil;
    }
    
    return [baseImage RGBABitmapDataWithSize:size];
}

@end

#else

OS_INLINE OS_ALWAYS_INLINE NSUInteger OSBytesForSize(CGSize size)
{
    return OSBytesPerRowForSize(size) * (NSUInteger)size.height;
}

@implementation NSData (CocoaImageHashing)

- (nullable NSData *)RGBABitmapDataWithSize:(CGSize)size
{
    NSImage *baseImage = [[NSImage alloc] initWithData:self];
    if (!baseImage) {
        return nil;
    }
    
    return [baseImage RGBABitmapDataWithSize:size];
}

@end

#endif

#pragma mark - NSImage Category

#if !(TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

@implementation NSImage (CocoaImageHashing)

- (nullable NSData *)RGBABitmapDataWithSize:(CGSize)size
{
    NSBitmapImageRep *imageRep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL
                                                                         pixelsWide:(NSInteger)size.width
                                                                         pixelsHigh:(NSInteger)size.height
                                                                      bitsPerSample:8
                                                                    samplesPerPixel:4
                                                                           hasAlpha:YES
                                                                           isPlanar:NO
                                                                     colorSpaceName:NSCalibratedRGBColorSpace
                                                                        bytesPerRow:(NSInteger)OSBytesPerRowForSize(size)
                                                                       bitsPerPixel:0];
    if (!imageRep) {
        return nil;
    }

    [NSGraphicsContext saveGraphicsState];
    NSGraphicsContext *context = [NSGraphicsContext graphicsContextWithBitmapImageRep:imageRep];
    context.imageInterpolation = NSImageInterpolationHigh;
    [NSGraphicsContext setCurrentContext:context];
    [self drawInRect:NSMakeRect(0, 0, size.width, size.height)];
    [context flushGraphics];
    [NSGraphicsContext restoreGraphicsState];
    [imageRep setSize:size];

    unsigned char *pixels = [imageRep bitmapData];
    NSData *result = [NSData dataWithBytes:pixels length:OSBytesForSize(size)];
    return result;
}

@end

#endif

#pragma mark - UIImage Category

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

@implementation UIImage (CocoaImageHashing)

- (nullable NSData *)RGBABitmapDataWithSize:(CGSize)size
{
    CGImageRef imageRef = [self CGImage];
    if (!imageRef) {
        return nil;
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSUInteger bytesPerRow = OSBytesPerRowForSize(size);
    NSUInteger bitsPerComponent = 8;
    NSMutableData *data = [NSMutableData dataWithLength:(NSUInteger)size.height * bytesPerRow];
    CGContextRef context = CGBitmapContextCreate([data mutableBytes], (size_t)size.width, (size_t)size.height, bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    CGContextDrawImage(context, rect, imageRef);
    CGContextRelease(context);
    return data;
}

@end

#endif

#pragma mark - NSString Category

@implementation NSString (CocoaImageHashing)

- (unsigned long long)fileSizeOfElementInBundle:(NSBundle *)bundle
{
    NSString *path = [bundle pathForResource:[self stringByDeletingPathExtension]
                                      ofType:[self pathExtension]];
    NSDictionary<NSString *, id> *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path
                                                                                                error:nil];
    NSNumber *fileSizeNumber = attributes[@"NSFileSize"];
    unsigned long long result = [fileSizeNumber unsignedLongLongValue];
    return result;
}

@end
