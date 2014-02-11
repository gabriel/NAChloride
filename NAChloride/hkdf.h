#ifndef CRYPTO_HKDF_H_
#define CRYPTO_HKDF_H_

#include <stdint.h>

#include <CommonCrypto/CommonHMAC.h>


// All these functions return 0 if they succeed or -1 if they fail.

int hkdf(CCHmacAlgorithm hmac_algorithm,
         const unsigned char *salt, int salt_len,
         const unsigned char *ikm, int ikm_len,
         const unsigned char *info, int info_len,
         uint8_t okm[], int okm_len);

int hkdf_extract(CCHmacAlgorithm hmac_algorithm,
                 const unsigned char *salt, int salt_len,
                 const unsigned char *ikm, int ikm_len,
                 uint8_t prk[]);

int hkdf_expand(CCHmacAlgorithm hmac_algorithm,
                const uint8_t prk[], int prk_len,
                const unsigned char *info, int info_len,
                uint8_t okm[], int okm_len);

#endif  // CRYPTO_HKDF_H_
