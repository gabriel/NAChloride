//
//  NANSString+Utils.m
//  NAChloride
//
//  Created by Gabriel on 6/19/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "NANSString+Utils.h"

@implementation NSString (NAUtils)

- (NSData *)na_dataFromHexString {
  if ((self.length % 2) != 0) {
    return nil;
  }

  const char *chars = [self UTF8String];
  NSMutableData *data = [NSMutableData dataWithCapacity:self.length / 2];
  char byteChars[3] = {0, 0, 0};
  unsigned long wholeByte;
  
  for (int i = 0; i < self.length; i += 2) {
    byteChars[0] = chars[i];
    byteChars[1] = chars[i + 1];
    wholeByte = strtoul(byteChars, NULL, 16);
    [data appendBytes:&wholeByte length:1];
  }
  
  return data;
}

@end
