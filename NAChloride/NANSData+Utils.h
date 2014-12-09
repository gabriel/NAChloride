//
//  NANSData+Utils.h
//  NACL
//
//  Created by Gabriel Handford on 1/16/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (NAUtils)

- (NSString *)na_hexString;

+ (NSData *)na_dataWithDatas:(NSArray *)datas;

- (BOOL)na_isEqualConstantTime:(NSData *)data;

- (void)na_sliceNoCopyAtIndex:(NSUInteger)index data:(NSData **)data1 data:(NSData **)data2;

+ (NSData *)na_dataNoCopy:(NSData *)data offset:(NSUInteger)offset length:(NSUInteger)length;

@end
