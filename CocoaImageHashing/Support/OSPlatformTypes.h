//
//  OSPlatformTypes.h
//  CocoaImageHashing
//
//  Created by Andreas Meingast on 14/10/15.
//  Copyright © 2015 Andreas Meingast. All rights reserved.
//

@import Foundation;
@import CoreGraphics;

#if (TARGET_OS_IPHONE || TARGET_OS_SIMULATOR)
    @import UIKit;
    #define OSImageType UIImage
#else
    @import AppKit;
    #define OSImageType NSImage
#endif
