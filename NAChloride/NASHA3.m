//
//  NASHA3.m
//  NAChloride
//
//  Created by Gabriel on 6/23/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "NASHA3.h"

#import "KeccakNISTInterface.h"

@implementation NASHA3

+ (NSData *)SHA3ForData:(NSData *)data digestBitLength:(NSUInteger)digestBitLength {
  return [self SHA3ForDatas:@[data] digestBitLength:digestBitLength];
}

+ (NSData *)SHA3ForDatas:(NSArray *)datas digestBitLength:(NSUInteger)digestBitLength {
  NSUInteger digestLength = digestBitLength/8;
  NSMutableData *outData = [NSMutableData dataWithLength:digestLength];
  
  hashState state;
  int result;
  result = Init(&state, (int)digestBitLength); // Bit length
  NSAssert(result == 0, @"Failed to init");
  for (NSData *data in datas) {
    result = Update(&state, (const BitSequence *)[data bytes], [data length] * 8); // Bit length
    NSAssert(result == 0, @"Failed to update");
  }
  result = Final(&state, [outData mutableBytes]);
  NSAssert(result == 0, @"Failed to finalize");
  
  return outData;
}

@end
