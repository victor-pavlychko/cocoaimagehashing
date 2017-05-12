//
//  NSImage+OSImageHashable.m
//  CocoaImageHashing
//
//  Created by Victor Pavlychko on 5/11/17.
//  Copyright © 2017 Andreas Meingast. All rights reserved.
//

#import "CocoaImageHashing+Internal.h"

@implementation NSImage (OSImageHashable)

- (nullable NSData *)os_RGBABitmapDataWithSize:(CGSize)size
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
