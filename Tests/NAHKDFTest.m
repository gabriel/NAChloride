//
//  NAChloride
//
//  Created by Gabriel on 1/16/14.
//  Copyright (c) 2015 Gabriel Handford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>

#import "NAChloride.h"

@interface NAHKDFTest : XCTestCase { }
@end

@implementation NAHKDFTest

- (void)test {
  NSData *key = [@"toomanysecrets" dataUsingEncoding:NSUTF8StringEncoding];
  NSData *salt = [NARandom randomData:32 error:nil];
  
  NSData *derivedKey = [NAHKDF HKDFForKey:key algorithm:NAHKDFAlgorithmSHA256 salt:salt info:nil length:64 error:nil];

  XCTAssertEqual([derivedKey length], (NSUInteger)64);
}

@end
