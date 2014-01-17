//
//  NAHMAC.m
//  NACL
//
//  Created by Gabriel Handford on 1/16/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "NAHMAC.h"

#include <CommonCrypto/CommonHMAC.h>

@implementation NAHMAC

+ (NSData *)HMACSHA256ForData:(NSData *)data key:(NSData *)key {
  if (!key) {
    [NSException raise:NSInvalidArgumentException format:@"Invalid key"];
    return nil;
  }
  
  CCHmacContext ctx;
  CCHmacInit(&ctx, kCCHmacAlgSHA256, [key bytes], [key length]);
  
  CCHmacUpdate(&ctx, [data bytes], [data length]);
  
  NSMutableData *macOut = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH];
  CCHmacFinal(&ctx, [macOut mutableBytes]);
  return macOut;
}

@end
