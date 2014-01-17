//
//  NASecretBoxTest.m
//  NACL
//
//  Created by Gabriel Handford on 1/16/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import <GHUnit/GHUnit.h>

#import "NACL.h"

@interface NASecretBoxTest : GHTestCase { }
@end

@implementation NASecretBoxTest

- (NSData *)deriveKeyFromPassword:(NSString *)password {
  NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
  NSData *derivedKey = [NAHKDF HKDFForKey:passwordData info:NULL derivedKeyLength:kNACurve25519ScalarSize];
  return derivedKey;
}

- (void)testEncrypt {
  NSData *derivedKey = [self deriveKeyFromPassword:@"thisisspassword"];
  
  NSString *secret = @"This is a secret";
  NSData *secretData = [secret dataUsingEncoding:NSUTF8StringEncoding];
  
  NSData *encryptedData = [NASecretBox encrypt:secretData key:derivedKey error:nil];
  
  NSData *unecryptedData = [NASecretBox decrypt:encryptedData key:derivedKey error:nil];
  
  GHAssertEqualObjects(secretData, unecryptedData, nil);
}

- (void)testDecrypt {
  NSString *encoded = @"8z6FcaDfyfFWL07lyOK/Y/Q3Yd+zMkbwgrNFv7SObBCIv/FFGw37QooecHKvlHQX1HlgZRouqgE=";
  NSData *encryptedData = [[NSData alloc] initWithBase64EncodedString:encoded options:0];
  
  NSData *derivedKey = [self deriveKeyFromPassword:@"thisisspassword"];
  
  NSData *unecryptedData = [NASecretBox decrypt:encryptedData key:derivedKey error:nil];
  
  NSString *decoded = [[NSString alloc] initWithData:unecryptedData encoding:NSUTF8StringEncoding];
  GHAssertEqualStrings(@"This is a secret", decoded, nil);
}

@end
