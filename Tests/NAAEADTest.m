//
//  NAAEADTest.m
//  NAChloride
//
//  Created by Gabriel on 6/18/15.
//  Copyright (c) 2015 Gabriel Handford. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>

@import NAChloride;

#import "NATestUtils.h"

@interface NAAEADTest : XCTestCase
@end

@implementation NAAEADTest

- (void)testEncrypt {
  NSData *key = [NARandom randomData:NAAEADKeySize];
  NSData *nonce = [NARandom randomData:NAAEADNonceSize];
  NSData *message = [@"This is a secret message" dataUsingEncoding:NSUTF8StringEncoding];
  NSData *additionalData = [@"123456" dataFromHexString];

  NAAEAD *AEAD = [[NAAEAD alloc] init];
  NSError *error = nil;
  NSData *encryptedData = [AEAD encrypt:message nonce:nonce key:key additionalData:additionalData error:&error];
  XCTAssertNil(error);
  NSData *decryptedData = [AEAD decrypt:encryptedData nonce:nonce key:key additionalData:additionalData error:&error];
  XCTAssertNil(error);
  XCTAssertEqualObjects(message, decryptedData);
}

@end