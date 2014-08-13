//
//  NAScryptTest.m
//  NAChloride
//
//  Created by Gabriel on 6/19/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import <GRUnit/GRUnit.h>

#import "NAChloride.h"
#import "NANSString+Utils.h"

@interface NAScryptTest : GRTestCase { }
@end


@implementation NAScryptTest

- (void)test {
  NSData *password = [@"toomanysecrets" dataUsingEncoding:NSUTF8StringEncoding];
  NSData *salt = [@"3cfae4e3c05ec84a9cf96c6a50a04b4e" na_dataFromHexString];
  NSData *encrypted = [NAScrypt scrypt:password salt:salt N:32768U r:8 p:1 length:64 error:nil];
  NSString *expected = @"c4bbb8371a26fcedcf85ccf60ebfec3a009121fc534f67e0618f5996dd1b2ba7d051abb4ac01613f2c9460688f80927c44f115293ace072b565b5e00981b5393";
  GRAssertEqualStrings(expected, [encrypted na_hexString]);
}

@end
