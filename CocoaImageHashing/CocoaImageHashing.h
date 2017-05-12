//
//  CocoaImageHashing.h
//  CocoaImageHashing
//
//  Created by Andreas Meingast on 10/10/15.
//  Copyright © 2015 Andreas Meingast. All rights reserved.
//

#import <CocoaImageHashing/OSPlatformTypes.h>

#import <CocoaImageHashing/OSImageHashable.h>
#import <CocoaImageHashing/NSData+OSImageHashable.h>
#if (TARGET_OS_IPHONE || TARGET_OS_SIMULATOR)
    #import <CocoaImageHashing/UIImage+OSImageHashable.h>
    #import <CocoaImageHashing/PHAsset+OSImageHashable.h>
#else
    #import <CocoaImageHashing/NSImage+OSImageHashable.h>
#endif

#import <CocoaImageHashing/OSTypes.h>
#import <CocoaImageHashing/OSTuple.h>
#import <CocoaImageHashing/OSImageHashingProvider.h>
#import <CocoaImageHashing/OSSimilaritySearch.h>
#import <CocoaImageHashing/OSImageHashing.h>

#import <CocoaImageHashing/OSAbstractHash.h>
#import <CocoaImageHashing/OSAHash.h>
#import <CocoaImageHashing/OSDHash.h>
#import <CocoaImageHashing/OSPHash.h>

FOUNDATION_EXPORT double CocoaImageHashingVersionNumber;
FOUNDATION_EXPORT const unsigned char CocoaImageHashingVersionString[];
