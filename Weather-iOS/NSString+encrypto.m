//
//  NSString+encrypto.m
//  Weather-iOS
//
//  Created by Simon Yang on 8/18/15.
//  Copyright (c) 2015 Simon Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSString+encrypto.h"

@implementation NSString(encrypto)

- (NSString *)URLEncodedString
{
    NSString *encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self, nil, (CFStringRef) @"!$&'()*+,-./:;=?@_~%#[]", kCFStringEncodingUTF8);
    
    return encodedString;
}
@end