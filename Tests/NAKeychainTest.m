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
  
  NSData *keyExisting = [NAKeychain symmetricKeyWithApplicationLabel:@"NACL"];
  GHAssertNil(keyExisting, nil);
  
  NSData *key = [NARandom randomData:kNACurve25519ScalarSize];
  [NAKeychain addSymmetricKey:key applicationLabel:@"NACL" tag:nil label:nil];
  
  NSData *keyOut = [NAKeychain symmetricKeyWithApplicationLabel:@"NACL"];
  GHAssertEqualObjects(key, keyOut, nil);
}

@end
