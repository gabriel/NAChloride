//
//  NASecretBox.m
//  NACL
//
//  Created by Gabriel Handford on 1/16/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "NASecretBox.h"
#import "NARandom.h"

#include "crypto_secretbox.h"


@implementation NASecretBox



- (NSData *)decrypt:(NSData *)data nonce:(NSData *)nonce key:(NSData *)key authenticated:(BOOL)useAuth error:(NSError * __autoreleasing *)error {
    
  NSData *encryptedData = nil;
  if (useAuth) {
      encryptedData = [self decryptAuthenticated:data nonce:nonce key:key error:error];
  }else{
      encryptedData = [self decrypt:data nonce:nonce key:key error:error];
  }
    
  return encryptedData;
}

- (NSData *)decrypt:(NSData *)data key:(NSData *)key error:(NSError * __autoreleasing *)error {
  if (!data || [data length] < crypto_secretbox_noncebytes()) {
    if (error) *error = [NSError errorWithDomain:@"NAChloride" code:200 userInfo:@{NSLocalizedDescriptionKey: @"Invalid data"}];
    return nil;
  }
  
  if (!key || [key length] != crypto_secretbox_keybytes()) {
    if (error) *error = [NSError errorWithDomain:@"NAChloride" code:201 userInfo:@{NSLocalizedDescriptionKey: @"Invalid key"}];
    return nil;
  }
  
  // Split it into nonce and encrypted data
  NSData *nonce = [NSData dataWithBytes:[data bytes] length:crypto_secretbox_noncebytes()];
  NSData *encryptedData = [NSData dataWithBytes:([data bytes] + crypto_secretbox_noncebytes()) length:[data length] - crypto_secretbox_noncebytes()];
  
  return [self decrypt:encryptedData nonce:nonce key:key error:error];
}

- (NSData *)decrypt:(NSData *)encryptedData nonce:(NSData *)nonce key:(NSData *)key error:(NSError * __autoreleasing *)error {
  // First BOXZEROBYTES must be 0
  NSMutableData *encryptedPaddedData = [NSMutableData dataWithLength:crypto_secretbox_boxzerobytes()];
  [encryptedPaddedData appendData:encryptedData];
  NSMutableData *outData = [NSMutableData dataWithLength:[encryptedPaddedData length]];
  
  int retval = crypto_secretbox_open([outData mutableBytes],
                                     [encryptedPaddedData bytes], [encryptedPaddedData length],
                                     [nonce bytes], [key bytes]);
  if (retval != 0) {
    if (error) *error = [NSError errorWithDomain:@"NAChloride" code:202 userInfo:@{NSLocalizedDescriptionKey: @"Unable to decrypt"}];
    return nil;
  }
  
  // Remove ZEROBYTES from out data
  return [NSData dataWithBytes:([outData bytes] + crypto_secretbox_zerobytes())
                        length:([outData length] - crypto_secretbox_zerobytes())];
}

- (NSData *)decryptAuthenticated:(NSData *)encryptedData nonce:(NSData *)nonce key:(NSData *)key error:(NSError * __autoreleasing *)error {
  NSMutableData *outData = [NSMutableData dataWithLength:[encryptedData length]];
    
  int retval = crypto_secretbox_open_easy([outData mutableBytes],
                                          [encryptedData bytes], [encryptedData length],
                                          [nonce bytes], [key bytes]);
  if (retval == -1) {
      if (error) *error = [NSError errorWithDomain:@"NAChloride" code:205 userInfo:@{NSLocalizedDescriptionKey: @"Verification during decryption failed"}];
      return nil;
  }
    
    // Remove MACBYTES from outdata
  return [NSData dataWithBytes:[outData bytes]
                        length:([outData length] - crypto_secretbox_macbytes())];
}


- (NSData *)encrypt:(NSData *)data nonce:(NSData *)nonce key:(NSData *)key authenticated:(BOOL)useAuth error:(NSError * __autoreleasing *)error {
    
  NSData *encryptedData = nil;
  if (useAuth) {
    encryptedData = [self encryptAuthenticated:data nonce:nonce key:key error:error];
  }else{
    encryptedData = [self encrypt:data nonce:nonce key:key error:error];
  }
    
  return encryptedData;
}


- (NSData *)encrypt:(NSData *)data key:(NSData *)key error:(NSError * __autoreleasing *)error {
  NSData *nonce = [NARandom randomData:crypto_secretbox_noncebytes() error:error];
  if (!nonce) return nil;

  NSData *encryptedData = [self encrypt:data nonce:nonce key:key error:error];
  if (!encryptedData) return nil;
  
  NSMutableData *combined = [NSMutableData dataWithData:nonce];
  [combined appendData:encryptedData];
  return combined;
}

- (NSData *)encrypt:(NSData *)data nonce:(NSData *)nonce key:(NSData *)key error:(NSError * __autoreleasing *)error {
  if (!nonce || [nonce length] != crypto_secretbox_noncebytes()) {
    if (error) *error = [NSError errorWithDomain:@"NAChloride" code:100 userInfo:@{NSLocalizedDescriptionKey: @"Invalid nonce"}];
    return nil;
  }
  
  if (!data) {
    if (error) *error = [NSError errorWithDomain:@"NAChloride" code:102 userInfo:@{NSLocalizedDescriptionKey: @"Invalid data"}];
    return nil;
  }
  
  if (!key || [key length] != crypto_secretbox_keybytes()) {
    if (error) *error = [NSError errorWithDomain:@"NAChloride" code:101 userInfo:@{NSLocalizedDescriptionKey: @"Invalid key"}];
    return nil;
  }
  
  // Pad the datas by ZEROBYTES
  NSMutableData *paddedData = [NSMutableData dataWithLength:crypto_secretbox_zerobytes()];
  [paddedData appendData:data];
  
  NSMutableData *outData = [NSMutableData dataWithLength:[paddedData length]];
  
  int retval = crypto_secretbox([outData mutableBytes],
                                [paddedData bytes], [paddedData length],
                                [nonce bytes],
                                [key bytes]);
  
  if (retval != 0) return nil;
  
  // Remove BOXZEROBYTES from out data
  return [NSData dataWithBytes:([outData bytes] + crypto_secretbox_boxzerobytes())
                        length:([outData length] - crypto_secretbox_boxzerobytes())];
}

- (NSData *)encryptAuthenticated:(NSData *)data nonce:(NSData *)nonce key:(NSData *)key error:(NSError * __autoreleasing *)error {
  if (!nonce || [nonce length] != crypto_secretbox_noncebytes()) {
      if (error) *error = [NSError errorWithDomain:@"NAChloride" code:103 userInfo:@{NSLocalizedDescriptionKey: @"Invalid nonce"}];
      return nil;
  }
    
  if (!data) {
      if (error) *error = [NSError errorWithDomain:@"NAChloride" code:104 userInfo:@{NSLocalizedDescriptionKey: @"Invalid data"}];
      return nil;
  }
    
  if (!key || [key length] != crypto_secretbox_keybytes()) {
      if (error) *error = [NSError errorWithDomain:@"NAChloride" code:103 userInfo:@{NSLocalizedDescriptionKey: @"Invalid key"}];
      return nil;
  }
    
  // Add space for authentication tag of size MACBYTES
  NSMutableData *outData = [NSMutableData dataWithLength:[data length] + crypto_secretbox_macbytes()];
    
  int retval = crypto_secretbox_easy([outData mutableBytes],
                                     [data bytes], [data length],
                                     [nonce bytes],
                                     [key bytes]);
    
  if (retval != 0) return nil;
    
  return outData;
}


@end
