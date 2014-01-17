//
//  NACLDefines.m
//  NACL
//
//  Created by Gabriel Handford on 1/16/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "NACLDefines.h"

#include "crypto_scalarmult_curve25519.h"

const NSUInteger kNACurve25519ScalarSize = crypto_scalarmult_curve25519_SCALARBYTES;
const NSUInteger kNACurve25519PublicKeySize = crypto_scalarmult_curve25519_BYTES;
