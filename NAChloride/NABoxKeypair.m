//
//  NABoxKeypair.m
//  NAChloride
//
//  Created by Gabriel on 6/18/15.
//  Copyright (c) 2015 Gabriel Handford. All rights reserved.
//

#import "NABoxKeypair.h"

#import "NAInterface.h"

#import <libsodium/sodium.h>

@interface NABoxKeypair ()
@property NSData *publicKey;
@property NSData *secretKey;
@end

@implementation NABoxKeypair

- (instancetype)initWithPublicKey:(NSData *)publicKey secretKey:(NSData *)secretKey error:(NSError **)error {
  if ((self = [super init])) {

    if (!publicKey || [publicKey length] != NABoxPublicKeySize) {
      if (error) *error = NAError(NAErrorCodeInvalidKey, @"Invalid public key");
      return nil;
    }

    if (!secretKey || [secretKey length] != NABoxPublicKeySize) {
      if (error) *error = NAError(NAErrorCodeInvalidKey, @"Invalid secret key");
      return nil;
    }

    _publicKey = publicKey;
    _secretKey = secretKey;
  }
  return self;
}

+ (instancetype)generate:(NSError **)error {
  NSMutableData *publicKey = [NSMutableData dataWithLength:NABoxPublicKeySize];
  NSMutableData *secretKey = [NSMutableData dataWithLength:NABoxPublicKeySize];
  int retval = crypto_box_keypair([publicKey mutableBytes], [secretKey mutableBytes]);
  if (retval != 0) {
    if (error) *error = NAError(NAErrorCodeFailure, @"Keypair generate failed");
    return nil;
  }

  return [[NABoxKeypair alloc] initWithPublicKey:publicKey secretKey:secretKey error:error];
}

@end