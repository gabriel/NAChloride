//
//  NAChloride
//
//  Created by Gabriel on 1/16/14.
//  Copyright (c) 2015 Gabriel Handford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>

@import NAChloride;

#import "NATestUtils.h"

@interface NAXSalsa20Test : XCTestCase
@end

@implementation NAXSalsa20Test

- (void)test {
  NSData *message = [@"this is a secret message" dataUsingEncoding:NSUTF8StringEncoding];
  NSData *key = [@"c4bbb8371a26fcedcf85ccf60ebfec3a009121fc534f67e0618f5996dd1b2ba7" dataFromHexString];

  NSData *nonce = [@"e898c31fac5b06a29ef24789ccad6bfa6d4fe96a31817be5" dataFromHexString];
  NSError *error = nil;
  NAXSalsa20 *XSalsa20 = [[NAXSalsa20 alloc] init];
  NSData *encrypted = [XSalsa20 xor:message nonce:nonce key:key error:&error];
  XCTAssertNil(error);
  XCTAssertNotNil(encrypted);
  XCTAssertEqualObjects([encrypted hexString], @"1e4e6cc57cf62aefea4a3ec9d7ccb707a4f7869a49b64036");
  
  NSData *decrypted = [XSalsa20 xor:encrypted nonce:nonce key:key error:&error];
  XCTAssertEqualObjects(message, decrypted);
}

- (void)testDecrypt {
  NAXSalsa20 *XSalsa20 = [[NAXSalsa20 alloc] init];
  
  NSData *encrypted1 = [@"002d4513843fc240c401e541" dataFromHexString];
  NSData *key1 = [@"this is 32-byte key for xsalsa20" dataUsingEncoding:NSUTF8StringEncoding];
  NSData *nonce1 = [@"24-byte nonce for xsalsa" dataUsingEncoding:NSUTF8StringEncoding];
  NSData *decrypted1 = [XSalsa20 xor:encrypted1 nonce:nonce1 key:key1 error:nil];
  NSData *expected1 = [@"Hello world!" dataUsingEncoding:NSUTF8StringEncoding];
  XCTAssertEqualObjects(decrypted1, expected1);
  
  NSData *encrypted2 = [@"4848297feb1fb52fb66d81609bd547fabcbe7026edc8b5e5e449d088bfa69c088f5d8da1d791267c2c195a7f8cae9c4b4050d08ce6d3a151ec265f3a58e47648" dataFromHexString];
  NSData *key2 = [@"this is 32-byte key for xsalsa20" dataUsingEncoding:NSUTF8StringEncoding];
  NSData *nonce2 = [@"24-byte nonce for xsalsa" dataUsingEncoding:NSUTF8StringEncoding];
  NSData *decrypted2 = [XSalsa20 xor:encrypted2 nonce:nonce2 key:key2 error:nil];
  NSData *expected2 = [NSMutableData dataWithLength:64];
  XCTAssertEqualObjects(decrypted2, expected2);
}

@end
