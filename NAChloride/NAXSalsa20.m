//
//  NAXSalsa20.m
//  NAChloride
//
//  Created by Gabriel on 6/20/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "NAXSalsa20.h"

#include "crypto_stream_xsalsa20.h"

@implementation NAXSalsa20

+ (NSData *)encrypt:(NSData *)data nonce:(NSData *)nonce key:(NSData *)key error:(NSError * __autoreleasing *)error {
  if (!nonce || [nonce length] < crypto_stream_xsalsa20_noncebytes()) {
    if (error) *error = [NSError errorWithDomain:@"NAChloride" code:500 userInfo:@{NSLocalizedDescriptionKey: @"Invalid nonce"}];
    return nil;
  }
  
  if (!key || [key length] != crypto_stream_xsalsa20_keybytes()) {
    if (error) *error = [NSError errorWithDomain:@"NAChloride" code:501 userInfo:@{NSLocalizedDescriptionKey: @"Invalid key"}];
    return nil;
  }
  
  NSMutableData *outData = [NSMutableData dataWithLength:[data length]];
  
  int retval = crypto_stream_xsalsa20_xor([outData mutableBytes], [data bytes], [data length], [nonce bytes], [key bytes]);
  
  if (retval != 0) {
    if (error) *error = [NSError errorWithDomain:@"NAChloride" code:502 userInfo:@{NSLocalizedDescriptionKey: @"Failed XSalsa20"}];
    return nil;
  }

  return outData;
}

+ (NSData *)decrypt:(NSData *)data nonce:(NSData *)nonce key:(NSData *)key error:(NSError * __autoreleasing *)error {
  return [self encrypt:data nonce:nonce key:key error:error];
}

@end
