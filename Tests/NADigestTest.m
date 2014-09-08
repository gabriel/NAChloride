//
//  NADigestTest.m
//  NAChloride
//
//  Created by Gabriel on 7/3/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import <GRUnit/GRUnit.h>

#import "NAChloride.h"

@interface NADigestTest : GRTestCase { }
@end

@implementation NADigestTest

- (void)test {
  NSData *data = [@"abc" dataUsingEncoding:NSUTF8StringEncoding];
  
  NSData *SHA256 = [NADigest digestForData:data algorithm:NADigestAlgorithmSHA2_256];
  NSData *expected256 = [@"ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad" na_dataFromHexString];
  GRAssertEqualObjects(SHA256, expected256);
  
  NSData *SHA3_384 = [NADigest digestForData:data algorithm:NADigestAlgorithmSHA3_384];
  NSData *expected384 = [@"f7df1165f033337be098e7d288ad6a2f74409d7a60b49c36642218de161b1f99f8c681e4afaf31a34db29fb763e3c28e" na_dataFromHexString];
  GRAssertEqualObjects(SHA3_384, expected384);
  
  NSData *SHA3_512 = [NADigest digestForData:data algorithm:NADigestAlgorithmSHA3_512];
  NSData *expected512 = [@"18587dc2ea106b9a1563e32b3312421ca164c7f1f07bc922a9c83d77cea3a1e5d0c69910739025372dc14ac9642629379540c17e2a65b19d77aa511a9d00bb96" na_dataFromHexString];
  GRAssertEqualObjects(SHA3_512, expected512);
}


@end
