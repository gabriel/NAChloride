//
//  NANSMutableData+Utils.h
//  NAChloride
//
//  Created by Gabriel on 6/20/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableData (NAUtils)

- (void)na_XORWithData:(NSData *)data index:(NSInteger)index;

@end
