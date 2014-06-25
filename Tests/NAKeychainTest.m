//
//  NAKeychainTest.m
//  NACL
//
//  Created by Gabriel Handford on 1/21/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import <GHUnit/GHUnit.h>

#import "NAChloride.h"

@interface NAKeychainTest : GHTestCase { }
@end


@implementation NAKeychainTest

- (void)testSymmetricKey {
  [NAKeychain deleteAll];
  
  NSData *keyExisting = [NAKeychain symmetricKeyWithApplicationLabel:@"NAChloride"];
  GHAssertNil(keyExisting, nil);
  
  NSData *key = [NARandom randomData:NASecretBoxKeySize error:nil];
  [NAKeychain addSymmetricKey:key applicationLabel:@"NAChloride" tag:nil label:nil];
  
  NSData *keyOut = [NAKeychain symmetricKeyWithApplicationLabel:@"NAChloride"];
  GHAssertEqualObjects(key, keyOut, nil);
}

@end
