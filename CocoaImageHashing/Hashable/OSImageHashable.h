//
//  OSImageHashable.h
//  CocoaImageHashing
//
//  Created by Victor Pavlychko on 5/11/17.
//  Copyright © 2017 Andreas Meingast. All rights reserved.
//

@import Foundation;
@import CoreGraphics;

NS_ASSUME_NONNULL_BEGIN

@protocol OSImageHashable <NSObject>

- (nullable NSData *)os_RGBABitmapDataWithSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
