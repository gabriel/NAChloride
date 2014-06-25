//
//  NACLDefines.m
//  NACL
//
//  Created by Gabriel Handford on 1/16/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "NADefines.h"

#include "crypto_scalarmult_curve25519.h"

const NSUInteger NASecretBoxKeySize = crypto_scalarmult_curve25519_SCALARBYTES;
//const NSUInteger NASecretBoxKeySize = crypto_scalarmult_curve25519_BYTES;
