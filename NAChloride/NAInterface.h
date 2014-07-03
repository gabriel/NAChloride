//
//  NAInterface.h
//  NAChloride
//
//  Created by Gabriel on 6/25/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

extern const NSUInteger NASecretBoxKeySize;
extern const NSUInteger NASecretBoxNonceSize;

@protocol NACryptoBox
- (NSData *)encrypt:(NSData *)data key:(NSData *)key error:(NSError * __autoreleasing *)error;
- (NSData *)decrypt:(NSData *)data key:(NSData *)key error:(NSError * __autoreleasing *)error;
@end

@protocol NACryptoStream
- (NSData *)encrypt:(NSData *)data nonce:(NSData *)nonce key:(NSData *)key error:(NSError * __autoreleasing *)error;
- (NSData *)decrypt:(NSData *)data nonce:(NSData *)nonce key:(NSData *)key error:(NSError * __autoreleasing *)error;
@end

@protocol NAHMAC
- (NSData *)HMACForKey:(NSData *)key data:(NSData *)data;
@end


@protocol NADigest
- (NSData *)digestForData:(NSData *)data;
@end

