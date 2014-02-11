NACL
====

Objective-C library for [libsodium](https://github.com/jedisct1/libsodium). Also includes some helpers for doing crypto on iOS.

# Install

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries in your projects.

## Podfile

```ruby
platform :ios, '7.0'
pod "NAChloride"
```

# Usage

## Derive key from password
```objc
NSString *password = @"password";
NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
NSData *derivedKey = [NAHKDF HKDFForKey:passwordData info:NULL derivedKeyLength:kNACurve25519ScalarSize];
```

## Encrypt
```objc
// The secret to encrypt
NSString *secret = @"This is a secret";
NSData *secretData = [secret dataUsingEncoding:NSUTF8StringEncoding];

// Encrypt
NSError *error = nil;
NSData *encryptedData = [NASecretBox encrypt:secretData key:derivedKey error:&error];
// If an error occurred encryptedData will be nil and error set.
NSString *encoded = [encryptedData base64EncodedStringWithOptions:0];
```

## Decrypt
```objc
NSString *encoded = @"8z6FcaDfyfFWL07lyOK/Y/Q3Yd+zMkbwgrNFv7SObBCIv/FFGw37QooecHKvlHQX1HlgZRouqgE=";
NSData *encryptedData = [[NSData alloc] initWithBase64EncodedString:encoded options:0];

// Decrypt
NSData *unecryptedData = [NASecretBox decrypt:encryptedData key:derivedKey error:nil];
NSString *decoded = [[NSString alloc] initWithData:unecryptedData encoding:NSUTF8StringEncoding];

// Decoded should be "This is a secret"
```

## Other open source projects used by NAChloride

* [hkdf](https://github.com/seb-m/CryptoPill)
