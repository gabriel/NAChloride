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

+ (NSData *)na_dataWithDatas:(NSArray *)datas {
  NSInteger length = 0;
  for (NSData *data in datas) {
    length += data.length;
  }
  NSMutableData *combined = [NSMutableData dataWithCapacity:length];
  for (NSData *data in datas) {
    [combined appendData:data];
  }
  return combined;
}

- (BOOL)na_isEqualConstantTime:(NSData *)data {
  if ([self length] != [data length]) return NO;
  
  const uint8_t *dataPtr = (uint8_t *)self.bytes;
  const uint8_t *data2Ptr = (uint8_t *)data.bytes;
  
  uint8_t result = 0;
  for (int i = 0; i < self.length; i++) {
    result = result ^ (dataPtr[i] ^ data2Ptr[i]);
  }
  return (result == 0);
}

- (void)na_sliceNoCopyAtIndex:(NSUInteger)index data:(NSData **)data1 data:(NSData **)data2 {
  if (index > [self length]) {
    [NSException raise:NSRangeException format:@"Index is out of bounds"];
    return;
  }
  
  if (index > 0) {
    *data1 = [NSData dataWithBytesNoCopy:(uint8_t *)[self bytes] length:index freeWhenDone:NO];
  } else {
    *data1 = [NSData data];
  }
  
  if ([self length] > index) {
    *data2 = [NSData dataWithBytesNoCopy:((uint8_t *)[self bytes] + index) length:([self length] - index) freeWhenDone:NO];
  } else {
    *data2 = [NSData data];
  }
}

+ (NSData *)na_dataNoCopy:(NSData *)data offset:(NSUInteger)offset length:(NSUInteger)length {
  return [NSData dataWithBytesNoCopy:((uint8_t *)[data bytes] + offset) length:length freeWhenDone:NO];
}

@end
