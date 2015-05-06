//
//  NAChloride
//
//  Created by Gabriel on 1/16/14.
//  Copyright (c) 2015 Gabriel Handford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>

#import "NAChloride.h"

@interface NASecretBoxTest : XCTestCase { }
@end

@implementation NASecretBoxTest

- (void)testEncrypt {
  NAChlorideInit();

  NSData *key = [NARandom randomData:NASecretBoxKeySize error:nil];
  NSData *nonce = [NARandom randomData:NASecretBoxNonceSize error:nil];
  NSData *message = [@"This is a secret message" dataUsingEncoding:NSUTF8StringEncoding];
  
  NASecretBox *secretBox = [[NASecretBox alloc] init];
  NSData *encryptedData = [secretBox encrypt:message nonce:nonce key:key error:nil];
  NSData *decryptedData = [secretBox decrypt:encryptedData nonce:nonce key:key error:nil];
  XCTAssertEqualObjects(message, decryptedData);
}

- (void)testEncryptBadKey {
  NSData *badKey = [NSData data];
  NSData *nonce = [NARandom randomData:NASecretBoxNonceSize error:nil];

  NSError *error = nil;
  NASecretBox *secretBox = [[NASecretBox alloc] init];
  NSData *encryptedData = [secretBox encrypt:[@"This is a secret" dataUsingEncoding:NSUTF8StringEncoding] nonce:nonce key:badKey error:&error];
  XCTAssertNil(encryptedData);
  XCTAssertNotNil(error);
  XCTAssertEqual((NSInteger)101, error.code);
  NSLog(@"Error: %@", error);
}

@end
