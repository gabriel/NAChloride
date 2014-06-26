//
//  NAHKDFTest.m
//  NAChloride
//
//  Created by Gabriel on 6/26/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import <GHUnit/GHUnit.h>

#import "NAChloride.h"

@interface NAHKDFTest : GHTestCase { }
@end

@implementation NAHKDFTest

- (void)test {
  NSData *key = [@"toomanysecrets" dataUsingEncoding:NSUTF8StringEncoding];
  NSData *salt = [NARandom randomData:32 error:nil];
  
  NSData *derivedKey = [NAHKDF HKDFForKey:key algorithm:NAHKDFAlgorithmSHA256 salt:salt info:nil length:64 error:nil];

  GHAssertEquals([derivedKey length], (NSUInteger)64, nil);
}

@end
