//
//  NAInterface.h
//  NAChloride
//
//  Created by Gabriel on 6/25/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, NAErrorCode) {
  NAErrorCodeFailure = 1, // Generic failure

  NAErrorCodeInvalidNonce = 100,
  NAErrorCodeInvalidKey = 101,
  NAErrorCodeInvalidData = 102,
  NAErrorCodeInvalidSalt = 103,

  NAErrorCodeVerificationFailed = 205, // Verification failed
};

extern const NSUInteger NASecretBoxKeySize;
extern const NSUInteger NASecretBoxNonceSize;
extern const NSUInteger NASecretBoxMACSize;

extern const NSUInteger NAAuthKeySize;
extern const NSUInteger NAAuthSize;

extern const NSUInteger NAOneTimeAuthKeySize;
extern const NSUInteger NAOneTimeAuthSize;

extern const NSUInteger NAScryptSaltSize;

extern const NSUInteger NAXSalsaKeySize;
extern const NSUInteger NAXSalsaNonceSize;


void NAChlorideInit(void);


typedef id (^NAWork)(NSError **error);
typedef void (^NACompletion)(NSError *error, id output);
void NADispatch(dispatch_queue_t queue, NAWork work, NACompletion completion);

#define NAError(CODE, DESC) [NSError errorWithDomain:@"NAChloride" code:CODE userInfo:@{NSLocalizedDescriptionKey: DESC}];

