//
//  OSTuple.m
//  CocoaImageHashing
//
//  Created by Victor Pavlychko on 5/12/17.
//  Copyright © 2017 Andreas Meingast. All rights reserved.
//

#import "CocoaImageHashing+Internal.h"

@implementation OSTuple

@synthesize first = _first;
@synthesize second = _second;

+ (nonnull instancetype)tupleWithFirst:(nullable id)first
                             andSecond:(nullable id)second
{
    id this = [self alloc];
    return [this initWithFirst:first
                     andSecond:second];
}

- (nonnull instancetype)initWithFirst:(nullable id)first
                            andSecond:(nullable id)second
{
    self = [super init];
    if (self) {
        _first = first;
        _second = second;
    }
    return self;
}

- (NSString *)description
{
    NSString *result = [NSString stringWithFormat:@"<%@: %p, first: %@, second: %@>",
                        NSStringFromClass([self class]), (__bridge void *)self, _first, _second];
    return result;
}

@end

@implementation OSHashResultTuple

@synthesize first = _first;
@synthesize hashResult = _hashResult;

@end
