//
//  NAHMAC.h
//  NACL
//
//  Created by Gabriel Handford on 1/16/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NAHMAC : NSObject

+ (NSData *)HMACSHA256ForData:(NSData *)data key:(NSData *)key;

@end
