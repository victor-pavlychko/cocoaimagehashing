//
//  OSCategories.m
//  CocoaImageHashing
//
//  Created by Andreas Meingast on 11/10/15.
//  Copyright © 2015 Andreas Meingast. All rights reserved.
//

#import "CocoaImageHashing+Internal.h"

@import Darwin.libkern.OSAtomic;

#pragma mark - NSArray Category

@implementation NSArray (CocoaImageHashing)

- (NSArray<OSTuple<id, id> *> *)os_arrayWithPairCombinations
{
    NSMutableArray<OSTuple<id, id> *> *pairs = [NSMutableArray new];
    OSSpinLock volatile __block lock = OS_SPINLOCK_INIT;
    [self os_enumeratePairCombinationsUsingBlock:^(id __unsafe_unretained leftHand, id __unsafe_unretained rightHand) {
      OSTuple<id, id> *tuple = [OSTuple tupleWithFirst:leftHand
                                             andSecond:rightHand];
      OSSpinLockLock(&lock);
      [pairs addObject:tuple];
      OSSpinLockUnlock(&lock);
    }];
    return pairs;
}

- (void)os_enumeratePairCombinationsUsingBlock:(void (^)(id __unsafe_unretained leftHand, id __unsafe_unretained rightHand))block
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

#pragma mark - NSString Category

@implementation NSString (CocoaImageHashing)

- (unsigned long long)os_fileSizeOfElementInBundle:(NSBundle *)bundle
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
