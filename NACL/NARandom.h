//
//  NARandom.h
//
//  Created by Gabriel Handford on 1/16/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

@interface NARandom : NSObject

/*!
 Generate random data.
 The source code of SecRandomCopyBytes() is located at
 http://opensource.apple.com/source/Security/Security-55179.11/sec/Security/SecFramework.c

 @param len Number of random bytes to generate
 */
+ (NSData *)randomData:(size_t)len;

@end
