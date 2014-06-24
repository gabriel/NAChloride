//
//  NANSMutableData+Utils.m
//  NAChloride
//
//  Created by Gabriel on 6/20/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "NANSMutableData+Utils.h"

@implementation NSMutableData (NAUtils)

- (void)na_XORWithData:(NSData *)data index:(NSInteger)index {
  uint8_t *dataPtr = (uint8_t *)self.mutableBytes;
  const uint8_t *data2Ptr = (uint8_t *)data.bytes;
  
  NSAssert(index < self.length, @"Invalid index");
  
  for (int i = 0; i < data.length && (i + index) < self.length; i++) {
    dataPtr[i + index] = dataPtr[i + index] ^ data2Ptr[i];
  }
}

@end
