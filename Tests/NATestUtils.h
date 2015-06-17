//
//  NATestUtils.h
//  NAChloride
//
//  Created by Gabriel on 6/16/15.
//  Copyright (c) 2015 Gabriel Handford. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NAUtils)

- (NSData *)dataFromHexString;

@end

@interface NSData (NAUtils)

- (NSString *)hexString;

@end
