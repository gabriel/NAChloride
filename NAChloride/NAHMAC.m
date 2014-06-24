//
//  NAHMAC.m
//  NACL
//
//  Created by Gabriel Handford on 1/16/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "NAHMAC.h"

#include <CommonCrypto/CommonHMAC.h>
#import "NANSData+Utils.h"
#import "NANSString+Utils.h"
#import "NASHA3.h"

@implementation NAHMAC

+ (NSData *)HMACSHAForKey:(NSData *)key data:(NSData *)data digestBitLength:(NAHMACSHADigestBitLength)digestBitLength {
  NSParameterAssert(key);
  
  CCHmacAlgorithm algorithm;
  NSUInteger dataLength;
  switch (digestBitLength) {
    case NAHMACSHADigestLength160: algorithm = kCCHmacAlgSHA1; dataLength = CC_SHA1_DIGEST_LENGTH; break;
    case NAHMACSHADigestLength224: algorithm = kCCHmacAlgSHA224; dataLength = CC_SHA224_DIGEST_LENGTH; break;
    case NAHMACSHADigestLength256: algorithm = kCCHmacAlgSHA256; dataLength = CC_SHA256_DIGEST_LENGTH; break;
    case NAHMACSHADigestLength384: algorithm = kCCHmacAlgSHA384; dataLength = CC_SHA384_DIGEST_LENGTH; break;
    case NAHMACSHADigestLength512: algorithm = kCCHmacAlgSHA512; dataLength = CC_SHA512_DIGEST_LENGTH; break;
  }
  
  CCHmacContext ctx;
  CCHmacInit(&ctx, algorithm, [key bytes], [key length]);
  
  CCHmacUpdate(&ctx, [data bytes], [data length]);
  
  NSMutableData *macOut = [NSMutableData dataWithLength:dataLength];
  CCHmacFinal(&ctx, [macOut mutableBytes]);
  return macOut;
}

+ (NSData *)HMACSHA3ForKey:(NSData *)key data:(NSData *)data digestBitLength:(NAHMACSHADigestBitLength)digestBitLength {
  NSUInteger blockLength = 72;
  NSUInteger keyLength = [key length];
  
  //
  // Used this as a reference:
  // http://www.opensource.apple.com/source/CommonCrypto/CommonCrypto-55010/Source/API/CommonHMAC.c
  //
  
  uint8_t *keyP;
  
  if (keyLength > blockLength) {
    key = [NASHA3 SHA3ForData:key digestBitLength:digestBitLength];
    keyLength = [key length];
  }
  
  NSMutableData *keyIn = [NSMutableData dataWithLength:blockLength];
  uint8_t *k_ipad = [keyIn mutableBytes];
  NSMutableData *keyOut = [NSMutableData dataWithLength:blockLength];
  uint8_t *k_opad = [keyOut mutableBytes];
  
  keyP = (uint8_t *)[key bytes];
  /* Copy the key into k_ipad and k_opad while doing the XOR. */
  for (uint32_t byte = 0; byte < keyLength; byte++) {
    k_ipad[byte] = keyP[byte] ^ 0x36;
    k_opad[byte] = keyP[byte] ^ 0x5c;
  }
  /* Fill the remainder of k_ipad and k_opad with 0 XORed with the appropriate value. */
  if (keyLength < blockLength) {
    memset(k_ipad + keyLength, 0x36, blockLength - keyLength);
    memset(k_opad + keyLength, 0x5c, blockLength - keyLength);
  }
  
  NSData *macOut = [NASHA3 SHA3ForDatas:@[keyIn, data] digestBitLength:digestBitLength];
  
  /* Perform outer digest */
  return [NASHA3 SHA3ForDatas:@[keyOut, macOut] digestBitLength:digestBitLength];
}

@end
