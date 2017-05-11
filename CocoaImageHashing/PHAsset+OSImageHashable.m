//
//  PHAsset+OSImageHashable.m
//  CocoaImageHashing
//
//  Created by Victor Pavlychko on 5/11/17.
//  Copyright © 2017 Andreas Meingast. All rights reserved.
//

#import "PHAsset+OSImageHashable.h"
#import "UIImage+OSImageHashable.h"
#import "OSTypes+Internal.h"

@implementation PHAsset (OSImageHashable)

- (NSData *)os_RGBABitmapDataWithSize:(CGSize)size
{
    __block NSData *result = nil;
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.version = PHImageRequestOptionsVersionCurrent;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    options.networkAccessAllowed = YES;
    options.synchronous = YES;

    CGSize assetSize = CGSizeMake(self.pixelWidth, self.pixelHeight);
    CGSize targetSize = size;
    if (assetSize.width / assetSize.height > targetSize.width / targetSize.height) {
        targetSize.width = targetSize.height * assetSize.width / assetSize.height;
    } else {
        targetSize.height = targetSize.width * assetSize.height / assetSize.width;
    }
    
    [[PHImageManager defaultManager] requestImageForAsset:self targetSize:targetSize contentMode:PHImageContentModeDefault options:options
                                            resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable OS_UNUSED info) {
                                                result = [image os_RGBABitmapDataWithSize:size];
                                            }];
    
    return result;
}

@end
