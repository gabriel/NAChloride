//
//  NAKeychain.m
//  NACL
//
//  Created by Gabriel Handford on 1/21/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "NAKeychain.h"

@implementation NAKeychain

+ (BOOL)addKey:(NSData *)key attributes:(NSDictionary *)attributes {
  if (!key || attributes[(__bridge id)(kSecAttrKeyClass)] == nil || attributes[(__bridge id)(kSecAttrApplicationLabel)] == nil) {
    return NO;
  }
  
  NSMutableDictionary *allAttributes = [NSMutableDictionary dictionaryWithDictionary:attributes];
  allAttributes[(__bridge __strong id)(kSecClass)] = (__bridge id)(kSecClassKey);
  allAttributes[(__bridge __strong id)(kSecValueData)] = key;
  if (allAttributes[(__bridge id)(kSecAttrIsPermanent)] == nil) {
    allAttributes[(__bridge __strong id)(kSecAttrIsPermanent)] = @(YES);
  }
  
  OSStatus status = SecItemAdd((__bridge CFDictionaryRef)(allAttributes), NULL);
  if (status != errSecSuccess) {
    return NO;
  }
  return YES;
}

+ (BOOL)addSymmetricKey:(NSData *)symmetricKey applicationLabel:(NSString *)applicationLabel tag:(NSData *)tag label:(NSString *)label {
  
  if (!symmetricKey || !applicationLabel) {
    return NO;
  }
  
  NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
  attributes[(__bridge __strong id)kSecAttrKeyClass] = (__bridge id)kSecAttrKeyClassSymmetric;
  attributes[(__bridge __strong id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleWhenUnlockedThisDeviceOnly;
  attributes[(__bridge __strong id)kSecAttrApplicationLabel] = applicationLabel;
  if (tag) {
    attributes[(__bridge __strong id)kSecAttrApplicationTag] = tag;
  }
  if (label) {
    attributes[(__bridge __strong id)kSecAttrLabel] = label;
  }
  
  return [self addKey:symmetricKey attributes:attributes];
}

+ (NSData *)keyWithApplicationLabel:(NSString *)applicationLabel attributes:(NSDictionary *)attributes {
  if (!applicationLabel || !attributes[(__bridge id)(kSecAttrKeyClass)]) {
    return nil;
  }

  NSMutableDictionary *allAttributes = [NSMutableDictionary dictionaryWithDictionary:attributes];
  allAttributes[(__bridge __strong id)(kSecClass)] = (__bridge id)(kSecClassKey);
  allAttributes[(__bridge __strong id)kSecAttrApplicationLabel] = applicationLabel;
  if (allAttributes[(__bridge id)(kSecAttrIsPermanent)] == nil) {
    allAttributes[(__bridge __strong id)(kSecAttrIsPermanent)] = @(YES);
  }
  allAttributes[(__bridge __strong id)(kSecReturnData)] = @(YES);
  
  CFTypeRef keyData = nil;
  OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)allAttributes, &keyData);
  if (status != errSecSuccess) {
    return nil;
  }
  
  return (__bridge_transfer NSData *)keyData;
}

+ (NSData *)symmetricKeyWithApplicationLabel:(NSString *)applicationLabel {
  NSDictionary *attributes = @{(__bridge __strong id)kSecAttrKeyClass: (__bridge id)kSecAttrKeyClassSymmetric};
  return [self keyWithApplicationLabel:applicationLabel attributes:attributes];
}

+ (NSDictionary *)keyAttributesWithApplicationLabel:(NSString *)applicationLabel queryAttributes:(NSDictionary *)queryAttributes {
  if (!applicationLabel || !queryAttributes || !queryAttributes[(__bridge id)(kSecAttrKeyClass)]) {
    return nil;
  }
  
  NSMutableDictionary *allAttributes = [NSMutableDictionary dictionaryWithDictionary:queryAttributes];
  allAttributes[(__bridge __strong id)(kSecClass)] = (__bridge id)(kSecClassKey);
  allAttributes[(__bridge __strong id)(kSecAttrApplicationLabel)] = applicationLabel;
  allAttributes[(__bridge __strong id)(kSecReturnData)] = @YES;
  allAttributes[(__bridge __strong id)(kSecReturnAttributes)] = @YES;
  
  CFTypeRef resultData = nil;
  OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)allAttributes, &resultData);
  if (status != errSecSuccess) {
    return nil;
  }
  
  return (__bridge_transfer NSDictionary *)resultData;
}

+ (NSDictionary *)symmetricKeyAttributesWithApplicationLabel:(NSString *)applicationLabel {
  NSDictionary *queryAttributes = @{(__bridge __strong id)(kSecAttrKeyClass): (__bridge id)(kSecAttrKeyClassSymmetric)};
  return [self keyAttributesWithApplicationLabel:applicationLabel queryAttributes:queryAttributes];
}

+ (void)deleteAll {
  for (id secclass in @[(__bridge id)kSecClassGenericPassword,
                        (__bridge id)kSecClassInternetPassword,
                        (__bridge id)kSecClassCertificate,
                        (__bridge id)kSecClassKey,
                        (__bridge id)kSecClassIdentity]) {
    NSMutableDictionary *query = [NSMutableDictionary dictionaryWithObjectsAndKeys:secclass, (__bridge id)kSecClass, nil];
    SecItemDelete((__bridge CFDictionaryRef)query);
  }
}

@end
