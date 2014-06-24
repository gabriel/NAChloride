//
//  NACounter.m
//  NAChloride
//
//  Created by Gabriel on 6/20/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "NACounter.h"

@interface NACounter ()
@property NSMutableData *counterData;
@end

#define DEFAULT_LENGTH (16)

@implementation NACounter

- (id)init {
  NSAssert(NO, @"Use initWithData:");
  return nil;
}

- (id)initWithData:(NSData *)data {
  if ((self = [super init])) {
    _counterData = [data mutableCopy];
  }
  return self;
}

- (void)increment {
  for (NSInteger i = [_counterData length] - 1; i >= 0; i--) {
    uint8_t *bytes = [_counterData mutableBytes];
    bytes[i]++;
    if (bytes[i])
      break;
  }
}

- (NSData *)data {
  return _counterData;
}

@end
