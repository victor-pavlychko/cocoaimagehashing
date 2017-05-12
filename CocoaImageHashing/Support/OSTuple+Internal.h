//
//  OSTuple+Internal.h
//  CocoaImageHashing
//
//  Created by Victor Pavlychko on 5/12/17.
//  Copyright © 2017 Andreas Meingast. All rights reserved.
//

#import "OSTuple.h"

NS_ASSUME_NONNULL_BEGIN

@interface OSTuple<A, B> ()
{
@public
    A __strong _Nullable _first;
    B __strong _Nullable _second;
}

@end

@interface OSHashResultTuple <A> () {
@public
    A __strong _Nullable _first;
    OSHashType _hashResult;
}

@end

NS_ASSUME_NONNULL_END
