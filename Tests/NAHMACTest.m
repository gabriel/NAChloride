//
//  NAHMACTest.m
//  NAChloride
//
//  Created by Gabriel on 6/19/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import <GHUnit/GHUnit.h>

#import "NAChloride.h"

@interface NAHMACTest : GHTestCase { }
@end


@implementation NAHMACTest

- (void)test {
  NSData *data = [@"This is a secret message!" dataUsingEncoding:NSUTF8StringEncoding];
  NSData *key = [@"toomanysecrets" dataUsingEncoding:NSUTF8StringEncoding];
  NSData *HMACSHA256 = [NAHMAC HMACSHAForKey:key data:data digestBitLength:256];
  GHAssertEqualStrings([HMACSHA256 na_hexString], @"086b7d69baf11a3159790fd1cf99db00439c4b8315b1fdf2440ec7cd70d606b6", nil);
  
  NSData *HMACSHA512 = [NAHMAC HMACSHAForKey:key data:data digestBitLength:512];
  GHAssertEqualStrings([HMACSHA512 na_hexString], @"ebe69ea46cae9297237dcdbcf3b85a7a11ca44c175d3339e175755081fdd538c532109a93a534d7aafea53fe5d5eea05fbdf4c99e4de088b48531a3a9b317b44", nil);
}

- (void)testHMACSHA3 {
  NSData *data = [@"This is a secret message!" dataUsingEncoding:NSUTF8StringEncoding];
  NSData *key = [@"toomanysecretstoomanysecretstoomanysecretstoomanysecretstoomanysecretstoomanysecretstoomanysecretstoomanysecrets" dataUsingEncoding:NSUTF8StringEncoding];
  
  NSData *mac1 = [NAHMAC HMACSHA3ForKey:key data:data digestBitLength:512];
  GHAssertEqualStrings([mac1 na_hexString], @"8e7f09b3a416a8db4b04427d2497172be8904ff12585ad1f6988b8f7e84b8e945e63d3a19fd89cfa00080b860b26c920a0f90a0ca2a678edcf4145679f412441", nil);
  
  NSData *keyShort = [@"toomanysecrets" dataUsingEncoding:NSUTF8StringEncoding];
  
  NSData *mac2 = [NAHMAC HMACSHA3ForKey:keyShort data:data digestBitLength:512];
  GHAssertEqualStrings([mac2 na_hexString], @"cc247aa29a4600965f6849a95d6bee96a0f01bc55d354d9acdae572c778d73985f9675a49809854c15a37913cae8e75dad9e5496cbc80e7b1cf16a8c76205778", nil);
}

@end
