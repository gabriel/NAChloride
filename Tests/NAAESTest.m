//
//  NAAESTest.m
//  NAChloride
//
#import <GHUnit/GHUnit.h>

#import "NAChloride.h"

@interface NAAESTest : GHTestCase
@end

@implementation NAAESTest

- (void)test {
  NSError *error = nil;
  
  NSData *message = [@"this is a secret message" dataUsingEncoding:NSUTF8StringEncoding];
  NSData *nonce = [@"3cfae4e3c05ec84a9cf96c6a50a04b4e" na_dataFromHexString];
  NSData *key = [@"e898c31fac5b06a29ef24789ccad6bfa6d3cfae4e3c05ec84a9cf96c6a50a04b" na_dataFromHexString];
  
  NSData *encrypted = [NAAES encrypt:message nonce:nonce key:key algorithm:NAAESAlgorithm256CTR error:&error];
  GHAssertNil(error, nil);
  GHAssertNotNil(encrypted, nil);
  GHAssertNotEqualObjects(message, encrypted, nil);
  GHAssertEqualStrings(@"06053d6dc46166a0b77fcd58c7819f1241d64b419323b08a", [encrypted na_hexString], nil);
  
  NSData *decrypted = [NAAES decrypt:encrypted nonce:nonce key:key algorithm:NAAESAlgorithm256CTR error:&error];
  GHAssertEqualObjects(message, decrypted, nil);
}

@end
