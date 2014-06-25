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

+ (NSData *)HMACForKey:(NSData *)key data:(NSData *)data algorithm:(NAHMACAlgorithm)algorithm {
  NSParameterAssert(key);
  
  switch (algorithm) {
    case NAHMACAlgorithmSHA1:
    case NAHMACAlgorithmSHA224:
    case NAHMACAlgorithmSHA256:
    case NAHMACAlgorithmSHA384:
    case NAHMACAlgorithmSHA512:
      return [self _HMACSHAForKey:key data:data algorithm:algorithm];
      
    case NAHMACAlgorithmSHA3_256:
    case NAHMACAlgorithmSHA3_384:
    case NAHMACAlgorithmSHA3_512:
      return [self _HMACSHA3ForKey:key data:data algorithm:algorithm];
  }
}

+ (NSData *)_HMACSHAForKey:(NSData *)key data:(NSData *)data algorithm:(NAHMACAlgorithm)algorithm {
  NSParameterAssert(key);
  
  CCHmacAlgorithm ccAlgorithm;
  NSUInteger dataLength;
  switch (algorithm) {
    case NAHMACAlgorithmSHA1: ccAlgorithm = kCCHmacAlgSHA1; dataLength = CC_SHA1_DIGEST_LENGTH; break;
    case NAHMACAlgorithmSHA224: ccAlgorithm = kCCHmacAlgSHA224; dataLength = CC_SHA224_DIGEST_LENGTH; break;
    case NAHMACAlgorithmSHA256: ccAlgorithm = kCCHmacAlgSHA256; dataLength = CC_SHA256_DIGEST_LENGTH; break;
    case NAHMACAlgorithmSHA384: ccAlgorithm = kCCHmacAlgSHA384; dataLength = CC_SHA384_DIGEST_LENGTH; break;
    case NAHMACAlgorithmSHA512: ccAlgorithm = kCCHmacAlgSHA512; dataLength = CC_SHA512_DIGEST_LENGTH; break;
    default:
      NSAssert(NO, @"Unsupported algorithm");
      return nil;
  }
  
  CCHmacContext ctx;
  CCHmacInit(&ctx, algorithm, [key bytes], [key length]);
  
  CCHmacUpdate(&ctx, [data bytes], [data length]);
  
  NSMutableData *macOut = [NSMutableData dataWithLength:dataLength];
  CCHmacFinal(&ctx, [macOut mutableBytes]);
  return macOut;
}

+ (NSData *)_HMACSHA3ForKey:(NSData *)key data:(NSData *)data algorithm:(NAHMACAlgorithm)algorithm {
  NSUInteger blockLength = 72;
  NSUInteger keyLength = [key length];
  
  NSUInteger digestBitLength;
  switch (algorithm) {
    case NAHMACAlgorithmSHA3_256: digestBitLength = 256; break;
    case NAHMACAlgorithmSHA3_384: digestBitLength = 384; break;
    case NAHMACAlgorithmSHA3_512: digestBitLength = 512; break;
      
    default:
      NSAssert(NO, @"Unsupported algorithm");
      return nil;
  }
  
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
