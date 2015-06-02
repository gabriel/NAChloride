//
//  NAChloride
//
//  Created by Gabriel on 1/16/14.
//  Copyright (c) 2015 Gabriel Handford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>

@import NAChloride;

@interface NAAESTest : XCTestCase
@end

@implementation NAAESTest

- (void)test {
  NSError *error = nil;
  
  NSData *message = [@"this is a secret message" dataUsingEncoding:NSUTF8StringEncoding];
  NSData *nonce = [@"3cfae4e3c05ec84a9cf96c6a50a04b4e" na_dataFromHexString];
  NSData *key = [@"e898c31fac5b06a29ef24789ccad6bfa6d3cfae4e3c05ec84a9cf96c6a50a04b" na_dataFromHexString];
  
  NAAES *AES = [[NAAES alloc] initWithAlgorithm:NAAESAlgorithm256CTR];
  NSData *encrypted = [AES encrypt:message nonce:nonce key:key error:&error];
  XCTAssertNil(error);
  XCTAssertNotNil(encrypted);
  XCTAssertNotEqualObjects(message, encrypted);
  XCTAssertEqualObjects(@"06053d6dc46166a0b77fcd58c7819f1241d64b419323b08a", [encrypted na_hexString]);
  
  NSData *decrypted = [AES decrypt:encrypted nonce:nonce key:key error:&error];
  XCTAssertEqualObjects(message, decrypted);
}

@end
