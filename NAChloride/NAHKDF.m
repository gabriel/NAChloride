//
//  NAHKDF.m
//
//  Created by Gabriel Handford on 1/16/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "NAHKDF.h"

#include <CommonCrypto/CommonHMAC.h>

#import "hkdf.h"

@implementation NAHKDF

+ (NSData *)HKDFForKey:(NSData *)key algorithm:(NAHKDFAlgorithm)algorithm salt:(NSData *)salt info:(NSData *)info length:(NSUInteger)length error:(NSError * __autoreleasing *)error {
  if (!key) {
    if (error) *error = [NSError errorWithDomain:@"NAChloride" code:900 userInfo:@{NSLocalizedDescriptionKey: @"Invalid key"}];
    return nil;
  }
  
  CCHmacAlgorithm ccAlgorithm;
  switch (algorithm) {
    case NAHKDFAlgorithmSHA224: ccAlgorithm = kCCHmacAlgSHA224; break;
    case NAHKDFAlgorithmSHA256: ccAlgorithm = kCCHmacAlgSHA256; break;
    case NAHKDFAlgorithmSHA384: ccAlgorithm = kCCHmacAlgSHA384; break;
    case NAHKDFAlgorithmSHA512: ccAlgorithm = kCCHmacAlgSHA512; break;
  }
  
  NSMutableData *outData = [NSMutableData dataWithLength:length];
  
  int retval = hkdf(ccAlgorithm,
                    [salt bytes], (int)[salt length],
                    [key bytes], (int)[key length],
                    [info bytes], (int)[info length],
                    [outData mutableBytes], (int)length);

  if (retval != 0) {
    if (error) *error = [NSError errorWithDomain:@"NAChloride" code:901 userInfo:@{NSLocalizedDescriptionKey: @"Failed hkdf"}];
    return nil;
  }
  
  return outData;
}

@end
