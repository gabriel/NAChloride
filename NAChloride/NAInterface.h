//
//  NAInterface.h
//  NAChloride
//
//  Created by Gabriel on 6/25/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, NAErrorCode) {
  NAErrorCodeInvalidNonce = 100, // Invalid nonce (encrypt)
  NAErrorCodeInvalidKey = 101, // Invalid key (encrypt)
  NAErrorCodeInvalidData = 102, // Invalid data (encrypt)

  NAErrorCodeVerificationFailed = 205, // Verification failed (decrypt)

  NAErrorCodeScryptFailed = 400,
  NAErrorCodeInvalidSalt = 401,

};

extern const NSUInteger NASecretBoxKeySize;
extern const NSUInteger NASecretBoxNonceSize;
extern const NSUInteger NAScryptSaltSize;

@protocol NACryptoBox
- (NSData *)encrypt:(NSData *)data nonce:(NSData *)nonce key:(NSData *)key error:(NSError * __autoreleasing *)error;
- (NSData *)decrypt:(NSData *)data nonce:(NSData *)nonce key:(NSData *)key error:(NSError * __autoreleasing *)error;
@end

@protocol NACryptoStream
- (NSData *)encrypt:(NSData *)data nonce:(NSData *)nonce key:(NSData *)key error:(NSError * __autoreleasing *)error;
- (NSData *)decrypt:(NSData *)data nonce:(NSData *)nonce key:(NSData *)key error:(NSError * __autoreleasing *)error;
@end

@protocol NAHMAC
- (NSData *)HMACForKey:(NSData *)key data:(NSData *)data;
@end


@protocol NADigest
- (NSData *)digestForData:(NSData *)data;
@end

void NAChlorideInit(void);

#define NAWeakObject(o) __typeof__(o) __weak
#define NAWeakSelf NAWeakObject(self)