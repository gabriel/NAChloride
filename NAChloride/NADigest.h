//
//  NADigest.h
//  NAChloride
//
//  Created by Gabriel on 7/3/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "NAInterface.h"

typedef NS_ENUM (NSUInteger, NADigestAlgorithm) {
  NADigestAlgorithmSHA1 = 1,
  NADigestAlgorithmSHA224,
  NADigestAlgorithmSHA256,
  NADigestAlgorithmSHA384,
  NADigestAlgorithmSHA512,
  
  // SHA3
  NADigestAlgorithmSHA3_256,
  NADigestAlgorithmSHA3_384,
  NADigestAlgorithmSHA3_512,
};

@interface NADigest : NSObject <NADigest>

@property NADigestAlgorithm algorithm;

- (id)initWithAlgorithm:(NADigestAlgorithm)algorithm;

- (NSData *)digestForData:(NSData *)data;

+ (NSData *)digestForData:(NSData *)data algorithm:(NADigestAlgorithm)algorithm;

@end
