//
//  NAXSalsa20.m
//  NAChloride
//
//  Created by Gabriel on 6/20/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "NAXSalsa20.h"

#import <libsodium/sodium.h>

@implementation NAXSalsa20

- (NSData *)xor:(NSData *)data nonce:(NSData *)nonce key:(NSData *)key error:(NSError **)error {
  if (!nonce || [nonce length] < NAXSalsaNonceSize) {
    if (error) *error = NAError(NAErrorCodeInvalidNonce, @"Invalid XSalsa20 nonce");
    return nil;
  }
  
  if (!key || [key length] != NAXSalsaKeySize) {
    if (error) *error = NAError(NAErrorCodeInvalidKey, @"Invalid XSalsa20 key");
    return nil;
  }
  
  NSMutableData *outData = [NSMutableData dataWithLength:[data length]];
  
  int retval = crypto_stream_xsalsa20_xor([outData mutableBytes], [data bytes], [data length], [nonce bytes], [key bytes]);
  if (retval != 0) {
    if (error) *error = NAError(NAErrorCodeFailure, @"XSalsa20 failed");
    return nil;
  }

  return outData;
}

@end
