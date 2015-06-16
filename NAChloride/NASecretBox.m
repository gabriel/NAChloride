//
//  NASecretBox.m
//  NACL
//
//  Created by Gabriel Handford on 1/16/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "NASecretBox.h"

#import <libsodium/sodium.h>

@implementation NASecretBox

- (NSData *)decrypt:(NSData *)encryptedData nonce:(NSData *)nonce key:(NSData *)key error:(NSError * __autoreleasing *)error {
  NSMutableData *outData = [NSMutableData dataWithLength:[encryptedData length]];

  int retval = crypto_secretbox_open_easy([outData mutableBytes],
                                          [encryptedData bytes], [encryptedData length],
                                          [nonce bytes], [key bytes]);
  if (retval == -1) {
    if (error) *error = [NSError errorWithDomain:@"NAChloride" code:NAErrorCodeVerificationFailed userInfo:@{NSLocalizedDescriptionKey: @"Verification failed"}];
    return nil;
  }
    
  // Remove MACBYTES from outdata
  return [NSData dataWithBytes:[outData bytes] length:([outData length] - NASecretBoxMACSize)];
}

- (NSData *)encrypt:(NSData *)data nonce:(NSData *)nonce key:(NSData *)key error:(NSError * __autoreleasing *)error {
  if (!nonce || [nonce length] != NASecretBoxNonceSize) {
    if (error) *error = [NSError errorWithDomain:@"NAChloride" code:NAErrorCodeInvalidNonce userInfo:@{NSLocalizedDescriptionKey: @"Invalid nonce"}];
    return nil;
  }
    
  if (!data) {
    if (error) *error = [NSError errorWithDomain:@"NAChloride" code:NAErrorCodeInvalidData userInfo:@{NSLocalizedDescriptionKey: @"Invalid data"}];
    return nil;
  }
    
  if (!key || [key length] != NASecretBoxKeySize) {
    if (error) *error = [NSError errorWithDomain:@"NAChloride" code:NAErrorCodeInvalidKey userInfo:@{NSLocalizedDescriptionKey: @"Invalid key"}];
    return nil;
  }
    
  // Add space for authentication tag of size MACBYTES
  NSMutableData *outData = [NSMutableData dataWithLength:[data length] + NASecretBoxMACSize];
    
  int retval = crypto_secretbox_easy([outData mutableBytes],
                                     [data bytes], [data length],
                                     [nonce bytes],
                                     [key bytes]);
    
  if (retval != 0) return nil;
    
  return outData;
}

@end
