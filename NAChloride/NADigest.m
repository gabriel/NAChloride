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

- (instancetype)initWithAlgorithm:(NADigestAlgorithm)algorithm {
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
    case NADigestAlgorithmSHA2_224:
    case NADigestAlgorithmSHA2_256:
    case NADigestAlgorithmSHA2_384:
    case NADigestAlgorithmSHA2_512:
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
    case NADigestAlgorithmSHA2_224: {
      uint8_t digest[CC_SHA224_DIGEST_LENGTH];
      CC_SHA224(data.bytes, (CC_LONG)data.length, digest);
      return [[NSData alloc] initWithBytes:digest length:sizeof(digest)];
    }

    case NADigestAlgorithmSHA2_256: {
      uint8_t digest[CC_SHA256_DIGEST_LENGTH];
      CC_SHA256(data.bytes, (CC_LONG)data.length, digest);
      return [[NSData alloc] initWithBytes:digest length:sizeof(digest)];
    }
      
    case NADigestAlgorithmSHA2_384: {
      uint8_t digest[CC_SHA384_DIGEST_LENGTH];
      CC_SHA384(data.bytes, (CC_LONG)data.length, digest);
      return [[NSData alloc] initWithBytes:digest length:sizeof(digest)];
    }
      
    case NADigestAlgorithmSHA2_512: {
      uint8_t digest[CC_SHA512_DIGEST_LENGTH];
      CC_SHA512(data.bytes, (CC_LONG)data.length, digest);
      return [[NSData alloc] initWithBytes:digest length:sizeof(digest)];
    }
      
    default: {
      NSAssert(NO, @"Unsupported algorithm");
      return nil;
    }
  }
}

@end
