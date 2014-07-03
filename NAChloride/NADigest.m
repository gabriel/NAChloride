//
//  NADigest.m
//  NAChloride
//
//  Created by Gabriel on 7/3/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "NADigest.h"
#import "NASHA3.h"

#import <CommonCrypto/CommonDigest.h>

@implementation NADigest

- (id)initWithAlgorithm:(NADigestAlgorithm)algorithm {
  if ((self = [super init])) {
    _algorithm = algorithm;
  }
  return self;
}

- (NSData *)digestForData:(NSData *)data {
  return [NADigest digestForData:data algorithm:_algorithm];
}

+ (NSData *)digestForData:(NSData *)data algorithm:(NADigestAlgorithm)algorithm {
  switch (algorithm) {
    case NADigestAlgorithmSHA1:
    case NADigestAlgorithmSHA224:
    case NADigestAlgorithmSHA256:
    case NADigestAlgorithmSHA384:
    case NADigestAlgorithmSHA512:
      return [self _SHAForData:data algorithm:algorithm];
      
    case NADigestAlgorithmSHA3_256:
      return [NASHA3 SHA3ForData:data digestBitLength:256];
    case NADigestAlgorithmSHA3_384:
      return [NASHA3 SHA3ForData:data digestBitLength:384];
    case NADigestAlgorithmSHA3_512:
      return [NASHA3 SHA3ForData:data digestBitLength:512];
  }
}

+ (NSData *)_SHAForData:(NSData *)data algorithm:(NADigestAlgorithm)algorithm {
  switch (algorithm) {
    case NADigestAlgorithmSHA1: {
      uint8_t digest[CC_SHA1_DIGEST_LENGTH];
      CC_SHA1(data.bytes, data.length, digest);
      return [[NSData alloc] initWithBytes:digest length:sizeof(digest)];
    }
      
    case NADigestAlgorithmSHA224: {
      uint8_t digest[CC_SHA224_DIGEST_LENGTH];
      CC_SHA224(data.bytes, data.length, digest);
      return [[NSData alloc] initWithBytes:digest length:sizeof(digest)];
    }

    case NADigestAlgorithmSHA256: {
      uint8_t digest[CC_SHA256_DIGEST_LENGTH];
      CC_SHA256(data.bytes, data.length, digest);
      return [[NSData alloc] initWithBytes:digest length:sizeof(digest)];
    }
      
    case NADigestAlgorithmSHA384: {
      uint8_t digest[CC_SHA384_DIGEST_LENGTH];
      CC_SHA384(data.bytes, data.length, digest);
      return [[NSData alloc] initWithBytes:digest length:sizeof(digest)];
    }
      
    case NADigestAlgorithmSHA512: {
      uint8_t digest[CC_SHA512_DIGEST_LENGTH];
      CC_SHA512(data.bytes, data.length, digest);
      return [[NSData alloc] initWithBytes:digest length:sizeof(digest)];
    }
      
    default: {
      NSAssert(NO, @"Unsupported algorithm");
      return nil;
    }
  }
}

@end
