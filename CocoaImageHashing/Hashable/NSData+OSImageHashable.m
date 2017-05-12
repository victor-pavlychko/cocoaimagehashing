//
//  NSData+OSImageHashable.m
//  CocoaImageHashing
//
//  Created by Victor Pavlychko on 5/11/17.
//  Copyright © 2017 Andreas Meingast. All rights reserved.
//

#import "CocoaImageHashing+Internal.h"

@implementation NSData (OSImageHashable)

- (nullable NSData *)os_RGBABitmapDataWithSize:(CGSize)size
{
    OSImageType *baseImage = [[OSImageType alloc] initWithData:self];
    if (!baseImage) {
        return nil;
    }
    
    return [baseImage os_RGBABitmapDataWithSize:size];
}

@end
