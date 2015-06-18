//
//  NABoxKeypair.h
//  NAChloride
//
//  Created by Gabriel on 6/18/15.
//  Copyright (c) 2015 Gabriel Handford. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NABoxKeypair : NSObject

@property (readonly) NSData *publicKey;
@property (readonly) NSData *secretKey;

- (instancetype)initWithPublicKey:(NSData *)publicKey secretKey:(NSData *)secretKey error:(NSError **)error;

+ (instancetype)generate:(NSError **)error;

@end