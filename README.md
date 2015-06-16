NAChloride
===========

This project uses [libsodium](https://github.com/jedisct1/libsodium) for:

* Secret-Key 
  * Authenticated Encryption
  * Authentication
* One-Time Authentication
* Password Hashing: *Scrypt*
* Stream Ciphers: *XSalsa20*

The following use Apple's CommonCrypto framework:

* HMAC: *SHA1*, *SHA2*
* Digest: *SHA2*
* AES (256-CTR)

The following are implemented from included reference C libraries:

* HMAC: *SHA3/Keccak*
* Digest: *SHA3/Keccak*
* TwoFish (CTR)

See [gabriel/TSTripleSec](https://github.com/gabriel/TSTripleSec) for more usage examples of this library.

# Podfile

```ruby
pod "NAChloride"
```

# Init

You should call NAChlorideInit() to initialize on app start. Multiple calls to this are ignored. (This calls `sodium_init()` with `dispatch_once`.)

```objc
NAChlorideInit();
```

# Secret-Key Cryptography

## Authenticated Encryption

Encrypts and authenticates a message using a shared key and nonce.

```objc
NSError *error = nil;
NSData *key = [NARandom randomData:NASecretBoxKeySize error:&error];
NSData *nonce = [NARandom randomData:NASecretBoxNonceSize error:nil];
NSData *message = [@"This is a secret message" dataUsingEncoding:NSUTF8StringEncoding];

NASecretBox *secretBox = [[NASecretBox alloc] init];
NSData *encrypted = [secretBox encrypt:message nonce:nonce key:key error:&error];
// If an error occurred encrypted will be nil and error set

NSData *decrypted = [secretBox decrypt:encrypted nonce:nonce key:key error:&error];
```

## Authentication

```objc
NSError *error = nil;
NSData *key = [NARandom randomData:NASecretBoxKeySize error:&error];
NSData *message = [@"This is a message" dataUsingEncoding:NSUTF8StringEncoding];

NSData *auth = [oneTimeAuth auth:message key:key &error];
BOOL verified = [oneTimeAuth verify:auth data:message key:key error:&error];
```

# Password Hashing

```objc
NSData *key = [@"toomanysecrets" dataUsingEncoding:NSUTF8StringEncoding];
NSData *salt = [NARandom randomData:NAScryptSaltSize error:nil];
NSData *data = [NAScrypt scrypt:key salt:salt error:nil];
```

# One-Time Authentication

Generates a MAC for a given message and shared key using Poly1305 algorithm.
Key may NOT be reused across messages.

```objc
NSError *error = nil;
NSData *key = [NARandom randomData:NASecretBoxKeySize error:&error];
NSData *message = [@"This is a message" dataUsingEncoding:NSUTF8StringEncoding];

NSData *auth = [oneTimeAuth auth:message key:key &error];
BOOL verified = [oneTimeAuth verify:auth data:message key:key error:&error];
```

# Stream Ciphers

## XSalsa20

```objc
// Nonce should be 24 bytes
// Key should be 32 bytes
NAXSalsa20 *XSalsa20 = [[NAXSalsa20 alloc] init];
NSData *encrypted = [XSalsa20 encrypt:message nonce:nonce key:key error:&error];
```

# Advanced

## HMAC (SHA1, SHA2, SHA3)

```objc
NSData *mac1 = [NAHMAC HMACForKey:key data:data algorithm:NAHMACAlgorithmSHA2_512];
NSData *mac2 = [NAHMAC HMACForKey:key data:data algorithm:NAHMACAlgorithmSHA3_512];
```

## AES (256-CTR)

```objc
// Nonce should be 16 bytes
// Key should be 32 bytes
NAAES *AES = [[NAAES alloc] initWithAlgorithm:NAAESAlgorithm256CTR];
NSData *encrypted = [AES encrypt:message nonce:nonce key:key error:&error];
```

## TwoFish (CTR)

```objc
// Nonce should be 16 bytes
// Key should be 32 bytes
NATwoFish *twoFish = [[NATwoFish alloc] init];
NSData *encrypted = [twoFish encrypt:message nonce:nonce key:key error:&error];
```

## Digest (SHA2, SHA3)

```objc
NSData *digest1 = [NADigest digestForData:data algorithm:NADigestAlgorithmSHA2_256];
NSData *digest2 = [NADigest digestForData:data algorithm:NADigestAlgorithmSHA3_512];

// Directly use SHA3
NSData *sha = [NASHA3 SHA3ForData:data digestBitLength:512];
```

# Keychain Utils

```objc
NSData *key = [NARandom randomData:32 error:&error];
[NAKeychain addSymmetricKey:key applicationLabel:@"NAChloride" tag:nil label:nil];
NSData *keyOut = [NAKeychain symmetricKeyWithApplicationLabel:@"NAChloride"];
```

# NSData Utils
```objc
NSData *data = [@"deadbeef" na_dataFromHexString];
[data na_hexString]; // @"deadbeef";
```
