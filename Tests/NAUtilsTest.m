//
//  NAChloride
//
//  Created by Gabriel on 1/16/14.
//  Copyright (c) 2015 Gabriel Handford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>

@import NAChloride;

@interface NAUtilsTest : XCTestCase
@end

@implementation NAUtilsTest

- (void)testXOR {
  NSData *data = [@"0f" na_dataFromHexString];
  NSMutableData *mutableData = [[@"f0" na_dataFromHexString] mutableCopy];
  
  [mutableData na_XORWithData:data index:0];
  XCTAssertEqualObjects([mutableData na_hexString], @"ff");
}

- (void)testXORBytes {
  NSData *data = [@"0f0f0f0f" na_dataFromHexString];
  NSMutableData *mutableData = [[@"f0f0f000" na_dataFromHexString] mutableCopy];
  
  [mutableData na_XORWithData:data index:0];
  XCTAssertEqualObjects([mutableData na_hexString], @"ffffff0f");
}

- (void)testXORWithIndex {
  NSData *data = [@"0f" na_dataFromHexString];
  NSMutableData *mutableData = [[@"f0f000" na_dataFromHexString] mutableCopy];
  
  [mutableData na_XORWithData:data index:1];
  XCTAssertEqualObjects([mutableData na_hexString], @"f0ff00");
}

- (void)testIsEqualConstantTime {
  NSData *data1 = [@"f0f0f000" na_dataFromHexString];
  NSData *data2 = [@"f0f0f000" na_dataFromHexString];
  NSData *data3 = [@"f0f0ffff" na_dataFromHexString];
  XCTAssertTrue([data1 na_isEqualConstantTime:data2]);
  XCTAssertFalse([data1 na_isEqualConstantTime:data3]);
}

- (void)testSliceNoCopy {
  NSData *data = [@"f0f0ffff" na_dataFromHexString];
  NSData *data1 = nil;
  NSData *data2 = nil;
  [data na_sliceNoCopyAtIndex:2 data:&data1 data:&data2];
  XCTAssertEqualObjects([data1 na_hexString], @"f0f0");
  XCTAssertEqualObjects([data2 na_hexString], @"ffff");
  
  [data na_sliceNoCopyAtIndex:4 data:&data1 data:&data2];
  XCTAssertEqualObjects([data1 na_hexString], @"f0f0ffff");
  XCTAssertNil([data2 na_hexString]);
  
  //XCTAssertThrows([data na_sliceNoCopyAtIndex:5 data:&data1 data:&data2]);
}

- (void)testBadHex {
  NSData *data = [@"deadbee" na_dataFromHexString];
  XCTAssertNil(data);

  NSData *data2 = [@"deadbeef" na_dataFromHexString];
  XCTAssertNotNil(data2);
}

@end
