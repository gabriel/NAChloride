//
//  NATwoFish.m
//  NAChloride
//
//  Created by Gabriel on 6/20/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "NATwoFish.h"

#import "NACounter.h"
#import "NANSMutableData+Utils.h"
#import "NANSData+Utils.h"

#include "twofish.h"

@implementation NATwoFish

static dispatch_once_t twoFishInit;

+ (NSData *)encrypt:(NSData *)data nonce:(NSData *)nonce key:(NSData *)key error:(NSError * __autoreleasing *)error {
  if (!nonce || [nonce length] < 16) {
    if (error) *error = [NSError errorWithDomain:@"NAChloride" code:700 userInfo:@{NSLocalizedDescriptionKey: @"Invalid nonce"}];
    return nil;
  }
  
  if (!key || [key length] != 32) {
    if (error) *error = [NSError errorWithDomain:@"NAChloride" code:701 userInfo:@{NSLocalizedDescriptionKey: @"Invalid key"}];
    return nil;
  }
  
  dispatch_once(&twoFishInit, ^{ Twofish_initialise(); });
  
  Twofish_key xkey;
  Twofish_prepare_key((uint8_t *)[key bytes], [key length], &xkey);
  
  NACounter *counter = [[NACounter alloc] initWithData:nonce];
  
  NSInteger blockLength = [nonce length];
  
  NSMutableData *outData = [data mutableCopy];
  
  NSMutableData *blockOutData = [NSMutableData dataWithLength:blockLength];
  
  for (NSInteger index = 0; index < [data length]; index += blockLength) {
    Twofish_encrypt(&xkey, (uint8_t *)[counter.data bytes], [blockOutData mutableBytes]);
    [outData na_XORWithData:blockOutData index:index];
    [counter increment];
  }
  
  return outData;
}

+ (NSData *)decrypt:(NSData *)data nonce:(NSData *)nonce key:(NSData *)key error:(NSError * __autoreleasing *)error {
  return [self encrypt:data nonce:nonce key:key error:error];
}

@end
