//
//  NASecretBox.h
//  NACL
//
//  Created by Gabriel Handford on 1/16/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "NAInterface.h"

/*!
 Secret-key authenticated encryption.
 */
@interface NASecretBox : NSObject <NACryptoBox>

- (NSData *)encrypt:(NSData *)data key:(NSData *)key error:(NSError * __autoreleasing *)error;

- (NSData *)encrypt:(NSData *)data nonce:(NSData *)nonce key:(NSData *)key authenticated:(BOOL)useAuth error:(NSError * __autoreleasing *)error;

- (NSData *)decrypt:(NSData *)data key:(NSData *)key error:(NSError * __autoreleasing *)error;

- (NSData *)decrypt:(NSData *)data nonce:(NSData *)nonce key:(NSData *)key authenticated:(BOOL)useAuth error:(NSError * __autoreleasing *)error;

@end
