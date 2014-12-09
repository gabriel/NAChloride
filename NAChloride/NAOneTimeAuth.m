//
//  NAOneTimeAuth.m
//  NAChloride
//
//  Created by Gabriel on 9/24/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "NAOneTimeAuth.h"

#import "NARandom.h"
#import "NAInterface.h"
#import "crypto_onetimeauth.h"

@implementation NAOneTimeAuth

- (NSData *)oneTimeAuth:(NSData *)data key:(NSData *)key {
  NAChlorideInit();
  
  // Check crypto_onetimeauth_KEYBYTES

  NSMutableData *outData = [NSMutableData dataWithLength:crypto_onetimeauth_BYTES];
  
  crypto_onetimeauth([outData mutableBytes], [data bytes], [data length], [key bytes]);
  return outData;
}

@end
