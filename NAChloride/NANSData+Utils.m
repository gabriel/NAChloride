//
//  NANSData+Utils.m
//  NACL
//
//  Created by Gabriel Handford on 1/16/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "NANSData+Utils.h"

@implementation NSData (NAUtils)

- (NSString *)na_hexString {
  if ([self length] == 0) return nil;
  NSMutableString *hexString = [NSMutableString stringWithCapacity:[self length] * 2];
  for (NSUInteger i = 0; i < [self length]; ++i) {
    [hexString appendFormat:@"%02X", *((uint8_t *)[self bytes] + i)];
  }
  return [hexString lowercaseString];
}

@end
