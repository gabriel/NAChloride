//
//  NADigest.h
//  NAChloride
//
//  Created by Gabriel on 7/3/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "NAInterface.h"

typedef NS_ENUM (NSUInteger, NADigestAlgorithm) {
  //NADigestAlgorithmSHA1 = 1, // SHA1 might not be secure enough
  NADigestAlgorithmSHA2_224 = 2,
  NADigestAlgorithmSHA2_256,
  NADigestAlgorithmSHA2_384,
  NADigestAlgorithmSHA2_512,
  
  // SHA3
  NADigestAlgorithmSHA3_256,
  NADigestAlgorithmSHA3_384,
  NADigestAlgorithmSHA3_512,
};

@interface NADigest : NSObject <NADigest>

@property NADigestAlgorithm algorithm;

- (instancetype)initWithAlgorithm:(NADigestAlgorithm)algorithm;

- (NSData *)digestForData:(NSData *)data;

+ (NSData *)digestForData:(NSData *)data algorithm:(NADigestAlgorithm)algorithm;

@end
