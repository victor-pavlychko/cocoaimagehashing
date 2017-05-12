//
//  OSCategories.h
//  CocoaImageHashing
//
//  Created by Andreas Meingast on 11/10/15.
//  Copyright © 2015 Andreas Meingast. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@class OSTuple<A, B>;

#pragma mark - NSArray Category

@interface NSArray (CocoaImageHashing)

- (NSArray<OSTuple<id, id> *> *)os_arrayWithPairCombinations;

- (void)os_enumeratePairCombinationsUsingBlock:(void (^)(id __unsafe_unretained leftHand, id __unsafe_unretained rightHand))block;

@end

#pragma mark - NSString Category

@interface NSString (CocoaImageHashing)

- (unsigned long long)os_fileSizeOfElementInBundle:(NSBundle *)bundle;

@end

NS_ASSUME_NONNULL_END
