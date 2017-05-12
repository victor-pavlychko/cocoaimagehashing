//
//  PHAsset+OSImageHashable.h
//  CocoaImageHashing
//
//  Created by Victor Pavlychko on 5/11/17.
//  Copyright © 2017 Andreas Meingast. All rights reserved.
//

@import Photos;
#import "OSImageHashable.h"

NS_ASSUME_NONNULL_BEGIN

@interface PHAsset (OSImageHashable) <OSImageHashable>

@end

NS_ASSUME_NONNULL_END
