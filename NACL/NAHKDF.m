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

+ (NSData *)HKDFForKey:(NSData *)key info:(NSData *)info derivedKeyLength:(NSUInteger)derivedKeyLength {
  if (!key) {
    [NSException raise:NSInvalidArgumentException format:@"Invalid key"];
    return nil;
  }
  
  const void *infoBytes;
  if (info) {
    infoBytes = [info bytes];
  } else {
    infoBytes = NULL;
  }
  
  NSMutableData *derivedKey = [NSMutableData dataWithLength:derivedKeyLength];
  
  int retVal = hkdf(kCCHmacAlgSHA256,
                    NULL, 0,
                    [key bytes], (int)[key length],
                    infoBytes, (int)[info length],
                    [derivedKey mutableBytes], (int)derivedKeyLength);

  if (retVal != 0) return nil;
  
  return derivedKey;
}

@end
