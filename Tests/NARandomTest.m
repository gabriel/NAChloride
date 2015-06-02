//
//  NAChloride
//
//  Created by Gabriel on 1/16/14.
//  Copyright (c) 2015 Gabriel Handford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>

@import NAChloride;

@interface NARandomTest : XCTestCase
@end

@implementation NARandomTest

- (void)testRandomBase64 {
  for (NSInteger i = 0; i < 64; i++) {
    NSString *s = [NARandom randomBase64String:i error:nil];
    NSLog(@"%@", s);
    XCTAssertEqual((NSInteger)[s length], i);
  }
}

@end
