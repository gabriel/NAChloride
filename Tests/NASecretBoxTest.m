//
//  NASecretBoxTest.m
//  NACL
//
//  Created by Gabriel Handford on 1/16/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import <GHUnit/GHUnit.h>

#import "NAChloride.h"

@interface NASecretBoxTest : GHTestCase { }
@end

@implementation NASecretBoxTest

- (void)testEncrypt {
  NSData *key = [NARandom randomData:NASecretBoxKeySize error:nil];
  NSData *message = [@"This is a secret message" dataUsingEncoding:NSUTF8StringEncoding];
  
  NASecretBox *secretBox = [[NASecretBox alloc] init];
  NSData *encryptedData = [secretBox encrypt:message key:key error:nil];
  NSData *decryptedData = [secretBox decrypt:encryptedData key:key error:nil];
  GHAssertEqualObjects(message, decryptedData, nil);
}

- (void)testDecrypt {
  NSString *encoded = @"8z6FcaDfyfFWL07lyOK/Y/Q3Yd+zMkbwgrNFv7SObBCIv/FFGw37QooecHKvlHQX1HlgZRouqgE=";
  NSData *encrypted = [[NSData alloc] initWithBase64EncodedString:encoded options:0];
  
  NSData *passwordData = [@"thisisspassword" dataUsingEncoding:NSUTF8StringEncoding];
  NSData *derivedKey = [NAHKDF HKDFForKey:passwordData info:NULL derivedKeyLength:NASecretBoxKeySize];
  
  NASecretBox *secretBox = [[NASecretBox alloc] init];
  NSData *decrypted = [secretBox decrypt:encrypted key:derivedKey error:nil];
  
  NSString *decoded = [[NSString alloc] initWithData:decrypted encoding:NSUTF8StringEncoding];
  GHAssertEqualStrings(@"This is a secret", decoded, nil);
}

- (void)testEncryptError {
  NSData *badKey = [NSData data];
  NSError *error = nil;
  NASecretBox *secretBox = [[NASecretBox alloc] init];
  NSData *encryptedData = [secretBox encrypt:[@"This is a secret" dataUsingEncoding:NSUTF8StringEncoding] key:badKey error:&error];
  GHAssertNil(encryptedData, nil);
  GHAssertNotNil(error, nil);
  GHAssertEquals(101, error.code, nil);
  GHTestLog(@"Error: %@", error);
}

@end
