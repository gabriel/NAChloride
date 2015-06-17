//
//  NAInterface.h
//  NAChloride
//
//  Created by Gabriel on 6/25/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, NAErrorCode) {
  NAErrorCodeInvalidNonce = 100, // Invalid nonce
  NAErrorCodeInvalidKey = 101, // Invalid key
  NAErrorCodeInvalidData = 102, // Invalid data

  NAErrorCodeVerificationFailed = 205, // Verification failed

  NAErrorCodeScryptFailed = 400,
  NAErrorCodeInvalidSalt = 401,

};

extern const NSUInteger NASecretBoxKeySize;
extern const NSUInteger NASecretBoxNonceSize;
extern const NSUInteger NASecretBoxMACSize;

extern const NSUInteger NAAuthKeySize;
extern const NSUInteger NAAuthSize;

extern const NSUInteger NAOneTimeAuthKeySize;
extern const NSUInteger NAOneTimeAuthSize;

extern const NSUInteger NAScryptSaltSize;

void NAChlorideInit(void);
