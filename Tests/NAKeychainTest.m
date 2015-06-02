//
//  NAChloride
//
//  Created by Gabriel on 1/16/14.
//  Copyright (c) 2015 Gabriel Handford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>

@import NAChloride;

@interface NAKeychainTest : XCTestCase
@end

@implementation NAKeychainTest

- (void)_testSymmetricKey {
  NSData *keyExisting = [NAKeychain symmetricKeyWithApplicationLabel:@"NAChloride"];
  XCTAssertNil(keyExisting);
  
  NSData *key = [NARandom randomData:NASecretBoxKeySize error:nil];
  XCTAssertTrue([NAKeychain addSymmetricKey:key applicationLabel:@"NAChloride" tag:nil label:nil]);
  
  NSData *keyOut = [NAKeychain symmetricKeyWithApplicationLabel:@"NAChloride"];
  XCTAssertEqualObjects(key, keyOut);
}

@end
