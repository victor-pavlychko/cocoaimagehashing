//
//  UIImage+OSImageHashable.m
//  CocoaImageHashing
//
//  Created by Victor Pavlychko on 5/11/17.
//  Copyright © 2017 Andreas Meingast. All rights reserved.
//

#import "CocoaImageHashing+Internal.h"

@implementation UIImage (OSImageHashable)

- (nullable NSData *)os_RGBABitmapDataWithSize:(CGSize)size
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
