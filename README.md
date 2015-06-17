NAChloride
===========

This project wraps [libsodium](https://github.com/jedisct1/libsodium) for:

* Secret-Key 
  * Authenticated Encryption
  * Authentication
* One-Time Authentication
* Password Hashing: *Scrypt*
* Stream Ciphers: *XSalsa20*

More wrappers are coming soon.

If you are looking for other non-libsodium related crypto (that used to be here), see [NACrypto](https://github.com/gabriel/NACrypto).

# Podfile

```ruby
pod "NAChloride"
```

# Init

You should call `NAChlorideInit()` to initialize on app start. Multiple calls to this are ignored. (This calls `sodium_init()` with `dispatch_once`.)

```objc
NAChlorideInit();
```

# Generating Random Data

```objc
NSData *data = [NARandom randomData:32]; // 32 bytes of random data
```

# Secret-Key Cryptography

## Authenticated Encryption

Encrypts and authenticates a message using a shared key and nonce.

```objc
NSData *key = [NARandom randomData:NASecretBoxKeySize];
NSData *nonce = [NARandom randomData:NASecretBoxNonceSize];
NSData *message = [@"This is a secret message" dataUsingEncoding:NSUTF8StringEncoding];

NASecretBox *secretBox = [[NASecretBox alloc] init];
NSError *error = nil;
NSData *encrypted = [secretBox encrypt:message nonce:nonce key:key error:&error];
// If an error occurred encrypted will be nil and error set

NSData *decrypted = [secretBox decrypt:encrypted nonce:nonce key:key error:&error];
```

## Authentication

```objc
NSData *key = [NARandom randomData:NASecretBoxKeySize];
NSData *message = [@"This is a message" dataUsingEncoding:NSUTF8StringEncoding];

NSError *error = nil;
NSData *auth = [oneTimeAuth auth:message key:key &error];
BOOL verified = [oneTimeAuth verify:auth data:message key:key error:&error];
```

# Password Hashing

```objc
NSData *key = [@"toomanysecrets" dataUsingEncoding:NSUTF8StringEncoding];
NSData *salt = [NARandom randomData:NAScryptSaltSize];
NSError *error = nil;
NSData *data = [NAScrypt scrypt:key salt:salt error:&error];
```

# Advanced

## One-Time Authentication

Generates a MAC for a given message and shared key using Poly1305 algorithm.
Key may NOT be reused across messages.

```objc
NSData *key = [NARandom randomData:NASecretBoxKeySize];
NSData *message = [@"This is a message" dataUsingEncoding:NSUTF8StringEncoding];

NSError *error = nil;
NSData *auth = [oneTimeAuth auth:message key:key error:&error];
BOOL verified = [oneTimeAuth verify:auth data:message key:key error:&error];
```

## Stream Ciphers

### XSalsa20

```objc
// Nonce should be 24 bytes
// Key should be 32 bytes
NAXSalsa20 *XSalsa20 = [[NAXSalsa20 alloc] init];
NSError *error = nil;
NSData *encrypted = [XSalsa20 encrypt:message nonce:nonce key:key error:&error];
```

