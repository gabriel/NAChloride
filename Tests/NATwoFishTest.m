//
//  NATwoFishTest.m
//
#import <GRUnit/GRUnit.h>

#import "NAChloride.h"
#import "NATwoFish.h"

@interface NATwoFishTest : GRTestCase
@end

@implementation NATwoFishTest

- (void)test {
  NSError *error = nil;
  
  NSData *message = [@"this is a secret message!" dataUsingEncoding:NSUTF8StringEncoding];
  NSData *nonce = [@"3cfae4e3c05ec84a9cf96c6a50a04b4e" na_dataFromHexString];
  NSData *key = [@"e898c31fac5b06a29ef24789ccad6bfa6d3cfae4e3c05ec84a9cf96c6a50a04b" na_dataFromHexString];
  
  NATwoFish *twoFish = [[NATwoFish alloc] init];
  NSData *encrypted = [twoFish encrypt:message nonce:nonce key:key error:&error];
  GRAssertNil(error);
  GRAssertNotNil(encrypted);
  GRAssertNotEqualObjects(message, encrypted);
  GRAssertEqualStrings(@"b8e8743028a8ddd74831f902326b2c5f338b3dd0037134e60f", [encrypted na_hexString]);
  
  NSData *decrypted = [twoFish decrypt:encrypted nonce:nonce key:key error:&error];
  GRAssertEqualObjects(message, decrypted);
}

@end
