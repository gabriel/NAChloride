NAChloride
===========

* SecretBox (via [libsodium](https://github.com/jedisct1/libsodium))
* Scrypt
* XSalsa20
* AES (256-CTR)
* TwoFish (CTR)
* HMAC (SHA1, SHA256, SHA512, SHA3)
* SHA3 (Keccak)
* HKDF (RFC 5849)
* Keychain Utils


# Install

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries in your projects.

## Podfile

```ruby
platform :ios, '7.0'
pod "NAChloride"
```

# SecretBox (libsodium)

Secret-key authenticated encryption.

## Encrypt
```objc
NSData *key = [NARandom randomData:NASecretBoxKeySize error:&error];
NSData *message = [@"This is a secret message" dataUsingEncoding:NSUTF8StringEncoding];

NSData *encryptedData = [NASecretBox encrypt:message key:key error:&error];
// If an error occurred encryptedData will be nil and error set
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

(via libsodium)

```objc
NSData *key = [@"toomanysecrets" dataUsingEncoding:NSUTF8StringEncoding];
NSData *salt = [NARandom randomData:48 error:&error]; // Random 48 bytes
NSData *data = [NAScrypt scrypt:key salt:salt N:32768U r:8 p:1 length:64 error:nil];
```

# XSalsa20

(via libsodium)

```objc
// Nonce should be 24 bytes
// Key should be 32 bytes
NSData *encrypted = [NAXSalsa20 encrypt:message nonce:nonce key:key error:nil];
```

# AES (256-CTR)

```objc
// Nonce should be 16 bytes
// Key should be 32 bytes
NSData *encrypted = [NAAES encrypt:message nonce:nonce key:key algorithm:NAAESAlgorithm256CTR error:nil];
```

# TwoFish (CTR)

```objc
// Nonce should be 16 bytes
// Key should be 32 bytes
NSData *encrypted = [NATwoFish encrypt:message nonce:nonce key:key error:nil];
```

# HMAC (SHA1, SHA256, SHA512, SHA3)

```objc
NSData *mac1 = [NAHMAC HMACForKey:key data:data algorithm:NAHMACAlgorithmSHA512];
NSData *mac2 = [NAHMAC HMACForKey:key data:data algorithm:NAHMACAlgorithmSHA3_512];
```

# SHA3 (Keccak)

```objc
NSData *sha = [NASHA3 SHA3ForData:data digestBitLength:512];
```

# HKDF (RFC 5849)

```objc
NSData *key = [@"toomanysecrets" dataUsingEncoding:NSUTF8StringEncoding];
NSData *derivedKey = [NAHKDF HKDFForKey:key info:NULL derivedKeyLength:kNACurve25519ScalarSize];
```

# Keychain Utils

```objc
NSData *key = [NARandom randomData:32 error:&error];
[NAKeychain addSymmetricKey:key applicationLabel:@"NAChloride" tag:nil label:nil];
NSData *keyOut = [NAKeychain symmetricKeyWithApplicationLabel:@"NAChloride"];
```
