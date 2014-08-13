//
//  NASecretBoxTest.m
//  NACL
//
//  Created by Gabriel Handford on 1/16/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import <GRUnit/GRUnit.h>

#import "NAChloride.h"

@interface NASecretBoxTest : GRTestCase { }
@end

@implementation NASecretBoxTest

- (void)testEncrypt {
  NSData *key = [NARandom randomData:NASecretBoxKeySize error:nil];
  NSData *message = [@"This is a secret message" dataUsingEncoding:NSUTF8StringEncoding];
  
  NASecretBox *secretBox = [[NASecretBox alloc] init];
  NSData *encryptedData = [secretBox encrypt:message key:key error:nil];
  NSData *decryptedData = [secretBox decrypt:encryptedData key:key error:nil];
  GRAssertEqualObjects(message, decryptedData);
}

- (void)testEncryptError {
  NSData *badKey = [NSData data];
  NSError *error = nil;
  NASecretBox *secretBox = [[NASecretBox alloc] init];
  NSData *encryptedData = [secretBox encrypt:[@"This is a secret" dataUsingEncoding:NSUTF8StringEncoding] key:badKey error:&error];
  GRAssertNil(encryptedData);
  GRAssertNotNil(error);
  GRAssertEquals(101, error.code);
  GRTestLog(@"Error: %@", error);
}

@end
