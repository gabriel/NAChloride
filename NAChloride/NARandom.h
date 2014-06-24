//
//  NARandom.h
//
//  Created by Gabriel Handford on 1/16/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

@interface NARandom : NSObject

/*!
 Generate random data.
 The source code of SecRandomCopyBytes() is located at
 http://opensource.apple.com/source/Security/Security-55179.11/sec/Security/SecFramework.c

 @param len Number of random bytes to generate
 */
+ (NSData *)randomData:(size_t)numBytes;

/*!
 Generate random hex string.
 @param numBytes Number of bytes for hex string.
 */
+ (NSString *)randomHexString:(size_t)numBytes;

/*!
 Generate random base64 string.
 */
+ (NSString *)randomBase64String:(size_t)length;

/*!
 A reminder to use UUID if what you want is a UUID.
 */
+ (NSUUID *)UUID;

@end
