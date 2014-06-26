//
//  NAHKDF.h
//
//  Created by Gabriel Handford on 1/16/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

typedef NS_ENUM (NSUInteger, NAHKDFAlgorithm) {
  NAHKDFAlgorithmSHA224 = 1,
  NAHKDFAlgorithmSHA256,
  NAHKDFAlgorithmSHA384,
  NAHKDFAlgorithmSHA512
};

@interface NAHKDF : NSObject

/*!
 Generate keying material using HKDF.
 
 @param info The optional context and application specific information.
 @param algorithm Algorithm to use
 @param length The number of bytes to output
 @result [NSData] Data of length
 */
+ (NSData *)HKDFForKey:(NSData *)key algorithm:(NAHKDFAlgorithm)algorithm salt:(NSData *)salt info:(NSData *)info length:(NSUInteger)length error:(NSError * __autoreleasing *)error;

@end
