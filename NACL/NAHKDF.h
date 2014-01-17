//
//  NAHKDF.h
//
//  Created by Gabriel Handford on 1/16/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

@interface NAHKDF : NSObject

+ (NSData *)HKDFForKey:(NSData *)key info:(NSData *)info derivedKeyLength:(NSUInteger)derivedKeyLength;

@end
