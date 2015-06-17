//
//  NAOneTimeAuthTest.m
//  NAChloride
//
//  Created by Gabriel on 6/16/15.
//  Copyright (c) 2015 Gabriel Handford. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>

@import NAChloride;

#import "NATestUtils.h"

@interface NAOneTimeAuthTest : XCTestCase
@end

@implementation NAOneTimeAuthTest

- (void)test {
  NAOneTimeAuth *oneTimeAuth = [[NAOneTimeAuth alloc] init];

  NSData *key = [NARandom randomData:NAOneTimeAuthKeySize];
  NSData *message = [@"This is a message" dataUsingEncoding:NSUTF8StringEncoding];

  NSData *auth = [oneTimeAuth auth:message key:key error:nil];

  BOOL verified = [oneTimeAuth verify:auth data:message key:key error:nil];
  XCTAssertTrue(verified);

  NSMutableData *altered = [auth mutableCopy];
  [altered replaceBytesInRange:NSMakeRange(0, 1) withBytes:[[@"AB" dataFromHexString] bytes]];

  NSError *error = nil;
  BOOL verified2 = [oneTimeAuth verify:altered data:message key:key error:&error];
  XCTAssertFalse(verified2);
  XCTAssertEqual(error.code, NAErrorCodeVerificationFailed);
}

@end
