//
//  NAAES.h
//  NAChloride
//
//  Created by Gabriel on 6/20/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

typedef NS_ENUM (NSUInteger, NAAESAlgorithm) {
  NAAESAlgorithm256CTR = 1,
};

@interface NAAES : NSObject

+ (NSData *)encrypt:(NSData *)data nonce:(NSData *)nonce key:(NSData *)key algorithm:(NAAESAlgorithm)algorithm error:(NSError **)error;

+ (NSData *)decrypt:(NSData *)data nonce:(NSData *)nonce key:(NSData *)key algorithm:(NAAESAlgorithm)algorithm error:(NSError **)error;

@end
