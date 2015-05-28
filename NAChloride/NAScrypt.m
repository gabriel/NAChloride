//
//  NAScrypt.m
//  NAChloride
//
//  Created by Gabriel on 6/19/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "NAScrypt.h"

#import <libsodium/sodium.h>

@implementation NAScrypt

+ (NSData *)scrypt:(NSData *)password salt:(NSData *)salt N:(uint64_t)N r:(uint32_t)r p:(uint32_t)p length:(size_t)length error:(NSError * __autoreleasing *)error {

  NSMutableData *outData = [NSMutableData dataWithLength:length];
  
  int retval = crypto_pwhash_scryptsalsa208sha256_ll((uint8_t *)password.bytes, password.length, (uint8_t *)salt.bytes, salt.length, N, r, p, [outData mutableBytes], outData.length);
  
  if (retval != 0) {
    if (error) *error = [NSError errorWithDomain:@"NAChloride" code:400 userInfo:@{NSLocalizedDescriptionKey: @"Failed scrypt"}];
    return nil;
  }
  
  NSAssert([outData length] == length, @"Mismatched output length");
  
  return outData;
}

+ (void)scrypt:(NSData *)password salt:(NSData *)salt N:(uint64_t)N r:(uint32_t)r p:(uint32_t)p length:(size_t)length queue:(dispatch_queue_t)queue completion:(void (^)(NSData *data))completion failure:(void (^)(NSError *error))failure {
  
  dispatch_async(queue, ^{

    NSError *error = nil;
    NSData *data = [NAScrypt scrypt:password salt:salt N:N r:r p:p length:length error:&error];
    
    if (error || !data) {
      dispatch_async(dispatch_get_main_queue(), ^{
        failure(error);
      });
      return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
      completion(data);
    });
  });

}

@end
