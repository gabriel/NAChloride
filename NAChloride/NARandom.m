//
//  NARandom.m
//
//  Created by Gabriel Handford on 1/16/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "NARandom.h"
#import "NANSData+Utils.h"

#include <Security/SecRandom.h>

@implementation NARandom

+ (NSData *)randomData:(size_t)numBytes {
  NSMutableData *data = [NSMutableData dataWithLength:numBytes];
  int ret = SecRandomCopyBytes(kSecRandomDefault, numBytes, [data mutableBytes]);
  if (ret == -1)
    return nil;
  return data;
}

+ (NSString *)randomHexString:(size_t)numBytes {
  NSData *data = [self randomData:numBytes];
  return [data na_hexString];
}

@end
