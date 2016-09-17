//
//  NAAuthTest.m
//  NAChloride
//
//  Created by Gabriel on 6/16/15.
//  Copyright (c) 2015 Gabriel Handford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>

@import NAChloride;

#import "NATestUtils.h"

@interface NAAuthTest : XCTestCase
@end

@implementation NAAuthTest

- (void)test {
  NAAuth *auth = [[NAAuth alloc] init];

  NSData *key = [NARandom randomData:NAAuthKeySize];
  NSData *message = [@"This is a message" dataUsingEncoding:NSUTF8StringEncoding];

  NSData *authData = [auth auth:message key:key error:nil];

  BOOL verified = [auth verify:authData data:message key:key error:nil];
  XCTAssertTrue(verified);

  NSMutableData *altered = [authData mutableCopy];
  [altered replaceBytesInRange:NSMakeRange(0, 1) withBytes:[[@"AB" dataFromHexString] bytes]];

  NSError *error = nil;
  BOOL verified2 = [auth verify:altered data:message key:key error:&error];
  XCTAssertFalse(verified2);
  XCTAssertEqual(error.code, NAErrorCodeVerificationFailed);
}

@end
