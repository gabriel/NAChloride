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

@end
