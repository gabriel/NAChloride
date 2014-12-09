//
//  NAUtilsTest.m
//  NAChloride
//
//  Created by Gabriel on 6/23/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GRXCTestCase.h"

#import "NANSData+Utils.h"
#import "NANSString+Utils.h"
#import "NANSMutableData+Utils.h"


@interface NAUtilsTest : GRXCTestCase
@end

@implementation NAUtilsTest

- (void)testXOR {
  NSData *data = [@"0f" na_dataFromHexString];
  NSMutableData *mutableData = [[@"f0" na_dataFromHexString] mutableCopy];
  
  [mutableData na_XORWithData:data index:0];
  GRAssertEqualStrings([mutableData na_hexString], @"ff");
}

- (void)testXORBytes {
  NSData *data = [@"0f0f0f0f" na_dataFromHexString];
  NSMutableData *mutableData = [[@"f0f0f000" na_dataFromHexString] mutableCopy];
  
  [mutableData na_XORWithData:data index:0];
  GRAssertEqualStrings([mutableData na_hexString], @"ffffff0f");
}

- (void)testXORWithIndex {
  NSData *data = [@"0f" na_dataFromHexString];
  NSMutableData *mutableData = [[@"f0f000" na_dataFromHexString] mutableCopy];
  
  [mutableData na_XORWithData:data index:1];
  GRAssertEqualStrings([mutableData na_hexString], @"f0ff00");
}

- (void)testIsEqualConstantTime {
  NSData *data1 = [@"f0f0f000" na_dataFromHexString];
  NSData *data2 = [@"f0f0f000" na_dataFromHexString];
  NSData *data3 = [@"f0f0ffff" na_dataFromHexString];
  GRAssertTrue([data1 na_isEqualConstantTime:data2]);
  GRAssertFalse([data1 na_isEqualConstantTime:data3]);
}

- (void)testSliceNoCopy {
  NSData *data = [@"f0f0ffff" na_dataFromHexString];
  NSData *data1 = nil;
  NSData *data2 = nil;
  [data na_sliceNoCopyAtIndex:2 data:&data1 data:&data2];
  GRAssertEqualStrings([data1 na_hexString], @"f0f0");
  GRAssertEqualStrings([data2 na_hexString], @"ffff");
  
  [data na_sliceNoCopyAtIndex:4 data:&data1 data:&data2];
  GRAssertEqualStrings([data1 na_hexString], @"f0f0ffff");
  GRAssertNil([data2 na_hexString]);
  
  //GRAssertThrows([data na_sliceNoCopyAtIndex:5 data:&data1 data:&data2]);
}

@end
