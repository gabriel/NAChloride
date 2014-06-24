NAChloride
===========

Objective-C library for [libsodium](https://github.com/jedisct1/libsodium). 

THIS CODE HAS _NOT_ BEEN AUDITED.

# Install

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries in your projects.

## Podfile

```ruby
platform :ios, '7.0'
pod "NAChloride"
```

# SecretBox

## Encrypt
```objc
NSData *secretKey = [NARandom randomData:kNACurve25519ScalarSize];
// The secret to encrypt
NSString *secret = @"This is a secret";
NSData *secretData = [secret dataUsingEncoding:NSUTF8StringEncoding];

// Encrypt
NSError *error = nil;
NSData *encryptedData = [NASecretBox encrypt:secretData key:secretKey error:&error];
// If an error occurred encryptedData will be nil and error set.
NSString *encoded = [encryptedData base64EncodedStringWithOptions:0];
```

## Decrypt
```objc
NSString *encoded = @"8z6FcaDfyfFWL07lyOK/Y/Q3Yd+zMkbwgrNFv7SObBCIv/FFGw37QooecHKvlHQX1HlgZRouqgE=";
NSData *encryptedData = [[NSData alloc] initWithBase64EncodedString:encoded options:0];

// Decrypt
NSData *unecryptedData = [NASecretBox decrypt:encryptedData key:secretKey error:nil];
NSString *decoded = [[NSString alloc] initWithData:unecryptedData encoding:NSUTF8StringEncoding];

// Decoded should be "This is a secret"
```

# Scrypt

```objc
NSData *key = [@"toomanysecrets" dataUsingEncoding:NSUTF8StringEncoding];
NSData *salt = [NARandom randomData:48]; // Random 48 bytes
NSData *data = [NAScrypt scrypt:key salt:salt N:32768U r:8 p:1 length:64 error:nil];
```

# XSalsa20

```objc
// Nonce should be 24 bytes
// Key should be 32 bytes
NSData *encrypted = [NAXSalsa20 encrypt:message nonce:nonce key:key error:nil];
```

# Other (part of iOS/OSX)

These are not part of libsodium.

## HMAC-SHA (224, 256, 384, 512)

```objc
NSData *HMACSHA512 = [NAHMAC HMACSHAForKey:key data:password digestLength:512];
```

## AES-256-CTR

```objc
// Nonce should be 16 bytes
// Key should be 32 bytes
NSData *encrypted = [NAAES encrypt:message nonce:nonce key:key error:nil];
```

## Save Key in Keychain

```objc
NSData *key = [NARandom randomData:kNACurve25519ScalarSize];
[NAKeychain addSymmetricKey:key applicationLabel:@"NAChloride" tag:nil label:nil];
NSData *keyOut = [NAKeychain symmetricKeyWithApplicationLabel:@"NAChloride"];
```

# Other (wraps included C implementations)

## TwoFish-CTR

See NAChloride/TwoFish

```objc
// Nonce should be 16 bytes
// Key should be 32 bytes
NSData *encrypted = [NATwoFish encrypt:message nonce:nonce key:key error:nil];
```

## HMAC-SHA3 (256, 384, 512)

See NAChloride/keccak

```objc
NSData *HMACSHA3 = [NAHMAC HMACSHA3ForKey:key data:password digestLength:512];
```

## HKDF (RFC 5849)

See NAChloride/HKDF

```objc
NSData *key = [@"toomanysecrets" dataUsingEncoding:NSUTF8StringEncoding];
NSData *derivedKey = [NAHKDF HKDFForKey:key info:NULL derivedKeyLength:kNACurve25519ScalarSize];
```
