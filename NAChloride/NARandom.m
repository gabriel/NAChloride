//
//  NARandom.m
//
//  Created by Gabriel Handford on 1/16/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "NARandom.h"
#import "NANSData+Utils.h"

#include <Security/SecRandom.h>

@implementation NARandom

+ (NSData *)randomData:(size_t)numBytes error:(NSError * __autoreleasing *)error {
  NSMutableData *data = [NSMutableData dataWithLength:numBytes];
  int ret = SecRandomCopyBytes(kSecRandomDefault, numBytes, [data mutableBytes]);
  if (ret == -1) {
    if (error) *error = [NSError errorWithDomain:@"NAChloride" code:50 userInfo:@{NSLocalizedDescriptionKey: @"Unable to generate random data"}];
    return nil;
  }
  return data;
}

+ (NSString *)randomBase64String:(size_t)length error:(NSError * __autoreleasing *)error {
  size_t numBytes = (size_t)ceil((length * 8.0) / 6.0);
  NSData *data = [self randomData:numBytes error:error];
  if (!data) return nil;
  
  NSString *base64String = [data base64EncodedStringWithOptions:0];
  if ([base64String length] > length) base64String = [base64String substringToIndex:length];
  return base64String;
}

@end
