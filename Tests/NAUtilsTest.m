//
//  NAUtilsTest.m
//
#import <GHUnit/GHUnit.h>

#import "NANSData+Utils.h"
#import "NANSString+Utils.h"
#import "NANSMutableData+Utils.h"


@interface NAUtilsTest : GHTestCase
@end

@implementation NAUtilsTest

- (void)testXOR {
  NSData *data = [@"0f" na_dataFromHexString];
  NSMutableData *mutableData = [[@"f0" na_dataFromHexString] mutableCopy];
  
  [mutableData na_XORWithData:data index:0];
  GHAssertEqualStrings([mutableData na_hexString], @"ff", nil);
}

- (void)testXORBytes {
  NSData *data = [@"0f0f0f0f" na_dataFromHexString];
  NSMutableData *mutableData = [[@"f0f0f000" na_dataFromHexString] mutableCopy];
  
  [mutableData na_XORWithData:data index:0];
  GHAssertEqualStrings([mutableData na_hexString], @"ffffff0f", nil);
}

- (void)testXORWithIndex {
  NSData *data = [@"0f" na_dataFromHexString];
  NSMutableData *mutableData = [[@"f0f000" na_dataFromHexString] mutableCopy];
  
  [mutableData na_XORWithData:data index:1];
  GHAssertEqualStrings([mutableData na_hexString], @"f0ff00", nil);
}

- (void)testIsEqualConstantTime {
  NSData *data1 = [@"f0f0f000" na_dataFromHexString];
  NSData *data2 = [@"f0f0f000" na_dataFromHexString];
  NSData *data3 = [@"f0f0ffff" na_dataFromHexString];
  GHAssertTrue([data1 na_isEqualConstantTime:data2], nil);
  GHAssertFalse([data1 na_isEqualConstantTime:data3], nil);
}

- (void)testSliceNoCopy {
  NSData *data = [@"f0f0ffff" na_dataFromHexString];
  NSData *data1 = nil;
  NSData *data2 = nil;
  [data na_sliceNoCopyAtIndex:2 data:&data1 data:&data2];
  GHAssertEqualStrings([data1 na_hexString], @"f0f0", nil);
  GHAssertEqualStrings([data2 na_hexString], @"ffff", nil);
  
  [data na_sliceNoCopyAtIndex:4 data:&data1 data:&data2];
  GHAssertEqualStrings([data1 na_hexString], @"f0f0ffff", nil);
  GHAssertNil([data2 na_hexString], nil);
  
  //GHAssertThrows([data na_sliceNoCopyAtIndex:5 data:&data1 data:&data2], nil);
}

@end
