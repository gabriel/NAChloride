//
//  NAHKDF.h
//
//  Created by Gabriel Handford on 1/16/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NAHKDF : NSObject

+ (NSData *)HKDFForKey:(NSData *)key info:(NSData *)info derivedKeyLength:(NSUInteger)derivedKeyLength;

@end
