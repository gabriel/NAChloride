//
//  NANSData+Utils.h
//  NACL
//
//  Created by Gabriel Handford on 1/16/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

@interface NSData (NAUtils)

- (NSString *)na_hexString;

+ (NSData *)na_dataWithDatas:(NSArray *)datas;

@end
