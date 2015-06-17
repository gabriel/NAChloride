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

@interface NAScryptTest : XCTestCase
@end

@implementation NAScryptTest

- (void)testScrypt {
  NSData *password = [@"toomanysecrets" dataUsingEncoding:NSUTF8StringEncoding];
  NSData *salt = [@"3cfae4e3c05ec84a9cf96c6a50a04b4e" dataFromHexString];
  NSData *encrypted = [NAScrypt scrypt:password salt:salt N:32768U r:8 p:1 length:64 error:nil];
  NSString *expected = @"c4bbb8371a26fcedcf85ccf60ebfec3a009121fc534f67e0618f5996dd1b2ba7d051abb4ac01613f2c9460688f80927c44f115293ace072b565b5e00981b5393";
  XCTAssertEqualObjects(expected, [encrypted hexString]);
}

- (void)testDefault {
  NSData *password = [@"toomanysecrets" dataUsingEncoding:NSUTF8StringEncoding];
  NSData *salt = [NARandom randomData:NAScryptSaltSize];
  NSData *key = [NAScrypt scrypt:password salt:salt error:nil];
  XCTAssertNotNil(key);
}

@end
