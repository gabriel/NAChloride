//
//  NASecureDataTest.m
//  NAChloride
//
//  Created by Gabriel on 6/19/15.
//  Copyright (c) 2015 Gabriel Handford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>

@import NAChloride;

#import "NATestUtils.h"

@interface NASecureDataTest : XCTestCase
@end

@implementation NASecureDataTest

// This test has to be run manually because it will SIGABORT if working as expected
- (void)test {
  NSError *error = nil;
  NABoxKeypair *keypair = [NABoxKeypair generate:&error];
  XCTAssertNil(error);
  XCTAssertNotNil(keypair);

  keypair.secretKey.protection = NASecureDataProtectionNoAccess;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
  sizeof(keypair.secretKey.bytes);
#pragma clang diagnostic pop
  XCTFail(@"Should not get here");
}

@end
