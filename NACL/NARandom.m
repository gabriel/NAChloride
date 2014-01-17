//
//  NARandom.m
//
//  Created by Gabriel Handford on 1/16/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "NARandom.h"

#include <Security/SecRandom.h>

@implementation NARandom

+ (NSData *)randomData:(size_t)len {
  NSMutableData *data = [NSMutableData dataWithLength:len];
  int ret = SecRandomCopyBytes(kSecRandomDefault, len, [data mutableBytes]);
  if (ret == -1)
    return nil;
  return data;
}

@end
