//
//  NAAES.m
//  NAChloride
//
//  Created by Gabriel on 6/20/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "NAAES.h"

//#include "crypto_stream_aes256estream.h"
#include <CommonCrypto/CommonCryptor.h>

#import "NACounter.h"
#import "NANSMutableData+Utils.h"

#define AES_256_CTR_NONCE_BYTES (16)
#define AES_256_CTR_KEY_BYTES (32)

@implementation NAAES

+ (NSData *)encrypt:(NSData *)data nonce:(NSData *)nonce key:(NSData *)key algorithm:(NAAESAlgorithm)algorithm error:(NSError **)error {
  NSAssert(algorithm == NAAESAlgorithm256CTR, @"Unsupported algorithm");
  
  if (!nonce || [nonce length] < AES_256_CTR_NONCE_BYTES) {
    if (error) *error = [NSError errorWithDomain:@"NAChloride" code:600 userInfo:@{NSLocalizedDescriptionKey: @"Invalid nonce"}];
    return nil;
  }
  
  if (!key || [key length] != AES_256_CTR_KEY_BYTES) {
    if (error) *error = [NSError errorWithDomain:@"NAChloride" code:601 userInfo:@{NSLocalizedDescriptionKey: @"Invalid key"}];
    return nil;
  }

  // This libsodium version doesn't return what I expected
  //int retval = crypto_stream_aes256estream_xor([outData mutableBytes], [data bytes], [data length], [nonce bytes], [key bytes]);
  
  NSMutableData *outData = [data mutableCopy];
  
  CCCryptorStatus cryptStatus;
  CCCryptorRef cryptor;
  cryptStatus = CCCryptorCreateWithMode(kCCEncrypt, kCCModeCTR, kCCAlgorithmAES128, ccNoPadding, [nonce bytes], [key bytes], [key length], NULL, 0, 0, kCCModeOptionCTR_BE, &cryptor);
  
  if (cryptStatus != kCCSuccess) {
    if (error) *error = [NSError errorWithDomain:@"NAChloride" code:604 userInfo:@{NSLocalizedDescriptionKey: @"Failed AES (1)"}];
    return nil;
  }
  
  size_t bytesEncrypted;
  cryptStatus = CCCryptorUpdate(cryptor, [data bytes],[ data length], [outData mutableBytes], [outData length], &bytesEncrypted);
  
  if (cryptStatus != kCCSuccess) {
    if (error) *error = [NSError errorWithDomain:@"NAChloride" code:605 userInfo:@{NSLocalizedDescriptionKey: @"Failed AES (2)"}];
    return nil;
  }
  
  return outData;
}

+ (NSData *)decrypt:(NSData *)data nonce:(NSData *)nonce key:(NSData *)key algorithm:(NAAESAlgorithm)algorithm error:(NSError **)error {
  NSAssert(algorithm == NAAESAlgorithm256CTR, @"Unsupported algorithm");
  return [self encrypt:data nonce:nonce key:key algorithm:algorithm error:error];
}

@end
