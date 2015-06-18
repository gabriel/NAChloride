//
//  NAXSalsa20.h
//  NAChloride
//
//  Created by Gabriel on 6/20/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "NAInterface.h"

@interface NAXSalsa20 : NSObject

- (NSData *)xor:(NSData *)data nonce:(NSData *)nonce key:(NSData *)key error:(NSError **)error;

@end
