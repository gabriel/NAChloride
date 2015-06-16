//
//  NAAuth.m
//  NAChloride
//
//  Created by Gabriel on 6/16/15.
//  Copyright (c) 2015 Gabriel Handford. All rights reserved.
//

#import "NAAuth.h"

#import "NAInterface.h"

#import <libsodium/sodium.h>

@implementation NAAuth

- (NSData *)auth:(NSData *)data key:(NSData *)key error:(NSError **)error {
  NAChlorideInit();

  if (!key || [key length] != NAAuthKeySize) {
    if (error) *error = [NSError errorWithDomain:@"NAChloride" code:NAErrorCodeInvalidKey userInfo:@{NSLocalizedDescriptionKey: @"Invalid key"}];
    return nil;
  }

  NSMutableData *outData = [NSMutableData dataWithLength:NAAuthSize];

  crypto_auth([outData mutableBytes], [data bytes], [data length], [key bytes]);
  return outData;
}

- (BOOL)verify:(NSData *)auth data:(NSData *)data key:(NSData *)key error:(NSError **)error {
  NAChlorideInit();

  if (!key || [key length] != NAAuthKeySize) {
    if (error) *error = [NSError errorWithDomain:@"NAChloride" code:NAErrorCodeInvalidKey userInfo:@{NSLocalizedDescriptionKey: @"Invalid key"}];
    return NO;
  }

  if (!auth || [auth length] != NAAuthSize) {
    if (error) *error = [NSError errorWithDomain:@"NAChloride" code:NAErrorCodeInvalidData userInfo:@{NSLocalizedDescriptionKey: @"Invalid data"}];
    return NO;
  }

  if (crypto_auth_verify([auth bytes], [data bytes], [data length], [key bytes]) != 0) {
    if (error) *error = [NSError errorWithDomain:@"NAChloride" code:NAErrorCodeVerificationFailed userInfo:@{NSLocalizedDescriptionKey: @"Verification failed"}];
    return NO; // Message forged!
  }
  return YES;
}

@end

