//
//  NAKeychain.h
//  NACL
//
//  Created by Gabriel Handford on 1/21/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NAKeychain : NSObject

+ (BOOL)addSymmetricKey:(NSData *)symmetricKey applicationLabel:(NSString *)applicationLabel tag:(NSData *)tag label:(NSString *)label;

+ (NSData *)symmetricKeyWithApplicationLabel:(NSString *)applicationLabel;

+ (void)deleteAll;

@end
