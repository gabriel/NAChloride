//
//  NARandom.m
//  NAChloride
//
//  Created by Gabriel on 6/16/15.
//  Copyright (c) 2015 Gabriel Handford. All rights reserved.
//

#import "NARandom.h"

#import "NAInterface.h"

#import <libsodium/sodium.h>

@implementation NARandom

+ (void)initialize { NAChlorideInit(); }

+ (NSData *)randomData:(size_t)numBytes {
  NSMutableData *outData = [NSMutableData dataWithLength:numBytes];
  randombytes_buf([outData mutableBytes], numBytes);
  return outData;
}

@end
