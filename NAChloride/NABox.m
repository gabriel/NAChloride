//
//  NABox.m
//  NAChloride
//
//  Created by Gabriel on 6/18/15.
//  Copyright (c) 2015 Gabriel Handford. All rights reserved.
//

#import "NABox.h"

#import "NAInterface.h"

#import <libsodium/sodium.h>

@implementation NABox

+ (void)initialize { NAChlorideInit(); }

- (NSData *)encrypt:(NSData *)data nonce:(NSData *)nonce keypair:(NABoxKeypair *)keypair error:(NSError **)error {
  if (!nonce || [nonce length] != NABoxNonceSize) {
    if (error) *error = NAError(NAErrorCodeInvalidNonce, @"Invalid nonce");
    return nil;
  }

  if (!data) {
    if (error) *error = NAError(NAErrorCodeInvalidData, @"Invalid data");
    return nil;
  }

  if (!keypair) {
    if (error) *error = NAError(NAErrorCodeInvalidKey, @"Invalid keypair");
    return nil;
  }

  NSMutableData *outData = [NSMutableData dataWithLength:[data length] + NABoxMACSize];

  int retval = crypto_box_easy([outData mutableBytes],
                               [data bytes], [data length],
                               [nonce bytes],
                               [keypair.publicKey bytes],
                               [keypair.secretKey bytes]);

  if (retval != 0) {
    if (error) *error = NAError(NAErrorCodeFailure, @"Encrypt (box) failed");
    return nil;
  }

  return outData;
}

- (NSData *)decrypt:(NSData *)data nonce:(NSData *)nonce keypair:(NABoxKeypair *)keypair error:(NSError **)error {
  if (!nonce || [nonce length] != NABoxNonceSize) {
    if (error) *error = NAError(NAErrorCodeInvalidNonce, @"Invalid nonce");
    return nil;
  }

  if (!data) {
    if (error) *error = NAError(NAErrorCodeInvalidData, @"Invalid data");
    return nil;
  }

  NSMutableData *outData = [NSMutableData dataWithLength:[data length]];

  int retval = crypto_box_open_easy([outData mutableBytes],
                                    [data bytes], [data length],
                                    [nonce bytes],
                                    [keypair.publicKey bytes],
                                    [keypair.secretKey bytes]);

  if (retval != 0) {
    if (error) *error = NAError(NAErrorCodeVerificationFailed, @"Verification failed");
    return nil;
  }

  return [NSData dataWithBytes:[outData bytes] length:([outData length] - NABoxMACSize)];
}

@end
