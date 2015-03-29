//
//  NASecretBoxTest.m
//  NACL
//
//  Created by Gabriel Handford on 1/16/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GRXCTestCase.h"

#import "NAChloride.h"

@interface NASecretBoxTest : GRXCTestCase { }
@end

@implementation NASecretBoxTest

- (void)testEncrypt {
  NAChlorideInit();

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
  GRAssertEquals((NSInteger)101, error.code);
  GRTestLog(@"Error: %@", error);
}

- (void)testEncryptAuthenticated {
    NAChlorideInit();
    
    NSData *key = [NARandom randomData:NASecretBoxKeySize error:nil];
    NSData *nonce = [NARandom randomData:NASecretBoxNonceSize error:nil];
    NSData *message = [@"This is a secret message" dataUsingEncoding:NSUTF8StringEncoding];
    
    NASecretBox *secretBox = [[NASecretBox alloc] init];
    NSData *encryptedData = [secretBox encrypt:message nonce:nonce key:key authenticated:YES error:nil];
    NSData *decryptedData = [secretBox decrypt:encryptedData nonce:nonce key:key authenticated:YES error:nil];
    GRAssertEqualObjects(message, decryptedData);
}

- (void)testEncryptAuthenticatedError {
    NSData *badKey = [NSData data];
    NSError *error = nil;
    NASecretBox *secretBox = [[NASecretBox alloc] init];
    NSData *nonce = [NARandom randomData:NASecretBoxNonceSize error:nil];
    NSData *encryptedData = [secretBox encrypt:[@"This is a secret" dataUsingEncoding:NSUTF8StringEncoding] nonce:nonce key:badKey authenticated:YES error:&error];
    GRAssertNil(encryptedData);
    GRAssertNotNil(error);
    GRAssertEquals((NSInteger)103, error.code);
    GRTestLog(@"Error: %@", error);
}


@end
