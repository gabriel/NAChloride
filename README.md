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

See [Generating Random Data](https://download.libsodium.org/doc/generating_random_data/index.html).

```objc
NSData *data = [NARandom randomData:32]; // 32 bytes of random data
```

# Secret-Key Cryptography

## Authenticated Encryption

Encrypts and authenticates a message using a shared key and nonce.

See [Authenticated Encryption](https://download.libsodium.org/doc/secret-key_cryptography/authenticated_encryption.html).

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

See [Authentication](https://download.libsodium.org/doc/secret-key_cryptography/secret-key_authentication.html).

```objc
NSData *key = [NARandom randomData:NAAuthKeySize];
NSData *message = [@"This is a message" dataUsingEncoding:NSUTF8StringEncoding];

NSError *error = nil;
NAAuth *auth = [[NAAuth alloc] init];
NSData *authData = [auth auth:message key:key &error];
BOOL verified = [auth verify:authData data:message key:key error:&error];
```

## AEAD

See [Authenticated Encryption with Additional Data](https://download.libsodium.org/doc/secret-key_cryptography/aead.html).

```objc
NSData *key = [NARandom randomData:NAAEADKeySize];
NSData *nonce = [NARandom randomData:NAAEADNonceSize];
NSData *message = [@"This is a secret message" dataUsingEncoding:NSUTF8StringEncoding];
NSData *additionalData = [@"Additional data" dataUsingEncoding:NSUTF8StringEncoding];

NAAEAD *AEAD = [[NAAEAD alloc] init];
NSError *error = nil;
NSData *encryptedData = [AEAD encrypt:message nonce:nonce key:key additionalData:additionalData error:&error];
NSData *decryptedData = [AEAD decrypt:encryptedData nonce:nonce key:key additionalData:additionalData error:&error];
```

# Password Hashing

See [Password Hashing](https://download.libsodium.org/doc/password_hashing/index.html).

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

See [One-Time Authentication](https://download.libsodium.org/doc/advanced/poly1305.html).

```objc
NSData *key = [NARandom randomData:NAOneTimeAuthKeySize];
NSData *message = [@"This is a message" dataUsingEncoding:NSUTF8StringEncoding];

NSError *error = nil;
NAOneTimeAuth *oneTimeAuth = [[NAOneTimeAuth alloc] init];
NSData *auth = [oneTimeAuth auth:message key:key error:&error];
BOOL verified = [oneTimeAuth verify:auth data:message key:key error:&error];
```

## Stream Ciphers

### XSalsa20

See [XSalsa20](https://download.libsodium.org/doc/advanced/xsalsa20.html).

```objc
// Nonce should be 24 bytes
// Key should be 32 bytes
NAXSalsa20 *XSalsa20 = [[NAXSalsa20 alloc] init];
NSError *error = nil;
NSData *encrypted = [XSalsa20 xor:message nonce:nonce key:key error:&error];
```

## Dispatch

There is a helper to dispatch these operations on a queue:

```objc
dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
NADispatch(queue, ^id(NSError **error) {
  return [NAScrypt scrypt:password salt:salt error:error];
}, ^(NSError *error, NSData *key) {
  // This is on the main queue
  // Error if failed, output if not
});
```
