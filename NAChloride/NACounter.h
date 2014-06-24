//
//  NACounter.h
//  NAChloride
//
//  Created by Gabriel on 6/20/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

// Counter for CTR mode
@interface NACounter : NSObject

- (id)initWithData:(NSData *)data;

- (void)increment;

- (NSData *)data;

@end
