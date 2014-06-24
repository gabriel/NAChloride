//
//  NAHMAC.h
//  NACL
//
//  Created by Gabriel Handford on 1/16/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

// Digest lengths in bits
typedef NS_ENUM (NSUInteger, NAHMACSHADigestBitLength) {
  NAHMACSHADigestLength160 = 160,
  NAHMACSHADigestLength224 = 224,
  NAHMACSHADigestLength256 = 256,
  NAHMACSHADigestLength384 = 384,
  NAHMACSHADigestLength512 = 512,
};

@interface NAHMAC : NSObject

/*!
 HMAC-SHA.
 @param digestBitLength Length in bits. So 256 produces 32 bytes of data.
 */
+ (NSData *)HMACSHAForKey:(NSData *)key data:(NSData *)data digestBitLength:(NAHMACSHADigestBitLength)digestBitLength;

/*!
 HMAC-SHA3.
 */
+ (NSData *)HMACSHA3ForKey:(NSData *)key data:(NSData *)data digestBitLength:(NAHMACSHADigestBitLength)digestBitLength;

@end
