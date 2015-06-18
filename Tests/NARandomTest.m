//
//  NARandomTest.m
//  NAChloride
//
//  Created by Gabriel on 6/17/15.
//  Copyright (c) 2015 Gabriel Handford. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>

@import NAChloride;

#import "NATestUtils.h"

@interface NARandomTest : XCTestCase
@end

@implementation NARandomTest

// Testing sanity not randomness
- (void)testData {
  NSData *d = [NARandom randomData:1024];
  XCTAssertNotNil(d);
  XCTAssertEqual([d length], 1024);
}

// Test we are already initialized
- (void)testInit {
  XCTAssertEqual(NASodiumInit(), 1); // Already initialized == 1
}

@end
