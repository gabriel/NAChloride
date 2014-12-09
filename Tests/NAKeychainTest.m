//
//  NAKeychainTest.m
//  NACL
//
//  Created by Gabriel Handford on 1/21/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GRXCTestCase.h"

#import "NAChloride.h"

@interface NAKeychainTest : GRXCTestCase { }
@end


@implementation NAKeychainTest

- (void)testSymmetricKey {
  [NAKeychain deleteAll];
  
  NSData *keyExisting = [NAKeychain symmetricKeyWithApplicationLabel:@"NAChloride"];
  GRAssertNil(keyExisting);
  
  NSData *key = [NARandom randomData:NASecretBoxKeySize error:nil];
  [NAKeychain addSymmetricKey:key applicationLabel:@"NAChloride" tag:nil label:nil];
  
  NSData *keyOut = [NAKeychain symmetricKeyWithApplicationLabel:@"NAChloride"];
  GRAssertEqualObjects(key, keyOut);
}

@end
