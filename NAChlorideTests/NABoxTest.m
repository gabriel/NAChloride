//
//  NABoxTest.m
//  NAChloride
//
//  Created by Gabriel on 6/18/15.
//  Copyright (c) 2015 Gabriel Handford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>

@import NAChloride;

#import "NATestUtils.h"

@interface NABoxTest : XCTestCase
@end

@implementation NABoxTest

- (void)test {
  NSError *error = nil;
  NABoxKeypair *keypair = [NABoxKeypair generate:&error];
  XCTAssertNil(error);
  XCTAssertNotNil(keypair);

  NSData *nonce = [NARandom randomData:NABoxNonceSize];
  NSData *message = [@"This is a secret message" dataUsingEncoding:NSUTF8StringEncoding];

  NABox *box = [[NABox alloc] init];
  NSData *encryptedData = [box encrypt:message nonce:nonce keypair:keypair error:&error];
  XCTAssertNil(error);
  XCTAssertNotNil(encryptedData);
  NSData *decryptedData = [box decrypt:encryptedData nonce:nonce keypair:keypair error:&error];
  XCTAssertNil(error);
  XCTAssertNotNil(decryptedData);
  XCTAssertEqualObjects(message, decryptedData);
}

@end
