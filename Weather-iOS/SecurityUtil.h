//
//  SecurityUtil.h
//  Weather-iOS
//
//  Created by Simon Yang on 8/18/15.
//  Copyright (c) 2015 Simon Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SecurityUtil : NSObject

#pragma mark - base64
+ (NSString*)encodeBase64String:(NSString *)input;
+ (NSString*)decodeBase64String:(NSString *)input;
+ (NSString*)encodeBase64Data:(NSData *)data;
+ (NSString*)decodeBase64Data:(NSData *)data;

#pragma mark - hash_hmac('sha1',$public_key,$private_key,TRUE)
+ (NSString *)hmacSha1:(NSString*)public_key :(NSString*)private_key;
@end
