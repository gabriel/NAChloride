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

- (void)testDefault {
  NSData *password = [@"toomanysecrets" dataUsingEncoding:NSUTF8StringEncoding];
  NSData *salt = [NARandom randomData:NAScryptSaltSize];
  NSError *error = nil;
  NSData *key = [NAScrypt scrypt:password salt:salt error:&error];
  XCTAssertNil(error);
  XCTAssertNotNil(key);
}

- (void)testCustom {
  NSData *password = [@"toomanysecrets" dataUsingEncoding:NSUTF8StringEncoding];
  NSData *salt = [@"3cfae4e3c05ec84a9cf96c6a50a04b4e" dataFromHexString];
  NSData *encrypted = [NAScrypt scrypt:password salt:salt N:32768U r:8 p:1 length:64 error:nil];
  NSString *expected = @"c4bbb8371a26fcedcf85ccf60ebfec3a009121fc534f67e0618f5996dd1b2ba7d051abb4ac01613f2c9460688f80927c44f115293ace072b565b5e00981b5393";
  XCTAssertEqualObjects(expected, [encrypted hexString]);
}

- (void)testDispatch {
  XCTestExpectation *expectation = [self expectationWithDescription:@"Dispatch"];

  NSData *password = [@"toomanysecrets" dataUsingEncoding:NSUTF8StringEncoding];
  NSData *salt = [@"2d56358229f29aa1c15521249f7076fa21f17265983bb9430991806ed8c1d817" dataFromHexString];
  XCTAssertEqual([salt length], NAScryptSaltSize);

  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
  NADispatch(queue, ^id(NSError **error) {
    return [NAScrypt scrypt:password salt:salt error:error];
  }, ^(NSError *error, NSData *key) {
    XCTAssertNil(error);
    XCTAssertNotNil(key);
    [expectation fulfill];
  });

  [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
    if (error) XCTFail();
  }];
}


@end
