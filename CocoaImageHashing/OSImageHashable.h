//
//  OSImageHashable.h
//  CocoaImageHashing
//
//  Created by Victor Pavlychko on 5/11/17.
//  Copyright © 2017 Andreas Meingast. All rights reserved.
//

@import Foundation;
@import CoreGraphics;

@protocol OSImageHashable <NSObject>

- (nullable NSData *)os_RGBABitmapDataWithSize:(CGSize)size;

@end
