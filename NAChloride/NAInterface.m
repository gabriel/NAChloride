//
//  NAInterface.m
//  NACL
//
//  Created by Gabriel Handford on 1/16/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "NAInterface.h"

#import <libsodium/sodium.h>

const NSUInteger NASecretBoxKeySize = crypto_secretbox_KEYBYTES;
const NSUInteger NASecretBoxNonceSize = crypto_secretbox_NONCEBYTES;
const NSUInteger NASecretBoxMACSize = crypto_secretbox_MACBYTES;

const NSUInteger NAAuthKeySize = crypto_auth_KEYBYTES;
const NSUInteger NAAuthSize = crypto_auth_BYTES;

const NSUInteger NAOneTimeAuthKeySize = crypto_onetimeauth_KEYBYTES;
const NSUInteger NAOneTimeAuthSize = crypto_onetimeauth_BYTES;

const NSUInteger NAScryptSaltSize = crypto_pwhash_scryptsalsa208sha256_SALTBYTES;

const NSUInteger NAXSalsaKeySize = crypto_stream_xsalsa20_KEYBYTES;
const NSUInteger NAXSalsaNonceSize = crypto_stream_xsalsa20_NONCEBYTES;

void NAChlorideInit(void) {
  static dispatch_once_t sodiumInit;
  dispatch_once(&sodiumInit, ^{ NASodiumInit(); });
}

int NASodiumInit(void) {
  return sodium_init();
}

void NADispatch(dispatch_queue_t queue, NAWork work, NACompletion completion) {
  dispatch_async(queue, ^{

    NSError *error = nil;
    id output = work(&error);

    dispatch_async(dispatch_get_main_queue(), ^{
      completion(error, output);
    });
  });
}