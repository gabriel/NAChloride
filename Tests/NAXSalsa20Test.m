//
//  NAXSalsa20Test.m
//
#import <GHUnit/GHUnit.h>

#import "NAChloride.h"

@interface NAXSalsa20Test : GHTestCase
@end

@implementation NAXSalsa20Test

- (void)test {
  NSData *message = [@"this is a secret message" dataUsingEncoding:NSUTF8StringEncoding];
  NSData *key = [@"c4bbb8371a26fcedcf85ccf60ebfec3a009121fc534f67e0618f5996dd1b2ba7" na_dataFromHexString];

  NSData *nonce = [@"e898c31fac5b06a29ef24789ccad6bfa6d4fe96a31817be5" na_dataFromHexString];
  NSError *error = nil;
  NSData *encrypted = [NAXSalsa20 encrypt:message nonce:nonce key:key error:&error];
  GHAssertNil(error, nil);
  GHAssertNotNil(encrypted, nil);
  
  GHAssertEqualStrings([encrypted na_hexString], @"1e4e6cc57cf62aefea4a3ec9d7ccb707a4f7869a49b64036", nil);
}

- (void)testDecrypt {
  NSData *encrypted1 = [@"002d4513843fc240c401e541" na_dataFromHexString];
  NSData *key1 = [@"this is 32-byte key for xsalsa20" dataUsingEncoding:NSUTF8StringEncoding];
  NSData *nonce1 = [@"24-byte nonce for xsalsa" dataUsingEncoding:NSUTF8StringEncoding];
  NSData *decrypted1 = [NAXSalsa20 decrypt:encrypted1 nonce:nonce1 key:key1 error:nil];
  NSData *expected1 = [@"Hello world!" dataUsingEncoding:NSUTF8StringEncoding];
  GHAssertEqualObjects(decrypted1, expected1, nil);
  
  NSData *encrypted2 = [@"4848297feb1fb52fb66d81609bd547fabcbe7026edc8b5e5e449d088bfa69c088f5d8da1d791267c2c195a7f8cae9c4b4050d08ce6d3a151ec265f3a58e47648" na_dataFromHexString];
  NSData *key2 = [@"this is 32-byte key for xsalsa20" dataUsingEncoding:NSUTF8StringEncoding];
  NSData *nonce2 = [@"24-byte nonce for xsalsa" dataUsingEncoding:NSUTF8StringEncoding];
  NSData *decrypted2 = [NAXSalsa20 decrypt:encrypted2 nonce:nonce2 key:key2 error:nil];
  NSData *expected2 = [NSMutableData dataWithLength:64];
  GHAssertEqualObjects(decrypted2, expected2, nil);
}

@end
