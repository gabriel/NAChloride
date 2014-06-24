//
//  NAAES.h
//  NAChloride
//
//  Created by Gabriel on 6/20/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

@interface NAAES : NSObject

// AES-256 in CTR mode
+ (NSData *)encrypt:(NSData *)data nonce:(NSData *)nonce key:(NSData *)key error:(NSError **)error;

// Because the CTR XOR, this just calls encrypt
+ (NSData *)decrypt:(NSData *)data nonce:(NSData *)nonce key:(NSData *)key error:(NSError **)error;

@end
