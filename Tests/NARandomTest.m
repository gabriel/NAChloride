//
//  NARandomTest.m
//  NAChloride
//
//  Created by Gabriel Handford on 4/2/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import <GHUnit/GHUnit.h>

#import "NAChloride.h"

@interface NARandomTest : GHTestCase { }
@end


@implementation NARandomTest

- (void)testRandomBase64 {
  for (NSInteger i = 0; i < 64; i++) {
    NSString *s = [NARandom randomBase64String:i error:nil];
    GHTestLog(@"%@", s);
    GHAssertEquals((NSInteger)[s length], i, nil);
  }
}

@end
