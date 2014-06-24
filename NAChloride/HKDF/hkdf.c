// Implements the HKDF algorithm (HMAC-based Extract-and-Expand Key
// Derivation Function, RFC 5869).
//
// This implementation is adapted from IETF's HKDF implementation,
// see associated license below.

/*
 Copyright (c) 2011 IETF Trust and the persons identified as
 authors of the code.  All rights reserved.
 
 Redistribution and use in source and binary forms, with or
 without modification, are permitted provided that the following
 conditions are met:
 
 - Redistributions of source code must retain the above
 copyright notice, this list of conditions and
 the following disclaimer.
 
 - Redistributions in binary form must reproduce the above
 copyright notice, this list of conditions and the following
 disclaimer in the documentation and/or other materials provided
 with the distribution.
 
 - Neither the name of Internet Society, IETF or IETF Trust, nor
 the names of specific contributors, may be used to endorse or
 promote products derived from this software without specific
 prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
 CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
 INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
#include "hkdf.h"

#include <string.h>

#include <CommonCrypto/CommonDigest.h>


static int mac_size_for_algorithm(CCHmacAlgorithm hmac_algorithm) {
  switch (hmac_algorithm) {
    case kCCHmacAlgSHA1:
      return CC_SHA1_DIGEST_LENGTH;
    case kCCHmacAlgSHA224:
      return CC_SHA224_DIGEST_LENGTH;
    case kCCHmacAlgSHA256:
      return CC_SHA256_DIGEST_LENGTH;
    case kCCHmacAlgSHA384:
      return CC_SHA384_DIGEST_LENGTH;
    case kCCHmacAlgSHA512:
      return CC_SHA512_DIGEST_LENGTH;
  }
  return -1;
}


/*
 *  hkdf
 *
 *  Description:
 *      This function will generate keying material using HKDF.
 *
 *  Parameters:
 *      hmac_algorithm: [in]
 *          One of kCCHmacAlgSHA1, kCCHmacAlgSHA256, kCCHmacAlgSHA384,
 *	    kCCHmacAlgSHA512, kCCHmacAlgSHA224.
 *      salt[]: [in]
 *          The optional salt value (a non-secret random value);
 *          if not provided (salt == NULL), it is set internally
 *          to a string of HashLen(hmac_algorithm) zeros.
 *      salt_len: [in]
 *          The length of the salt value. (Ignored if salt == NULL.)
 *      ikm[]: [in]
 *          Input keying material.
 *      ikm_len: [in]
 *          The length of the input keying material.
 *      info[]: [in]
 *          The optional context and application specific information.
 *          If info == NULL or a zero-length string, it is ignored.
 *      info_len: [in]
 *          The length of the optional context and application specific
 *          information. (Ignored if info == NULL.)
 *      okm[]: [out]
 *          Where the HKDF is to be stored.
 *      okm_len: [in]
 *          The length of the buffer to hold okm.
 *          okm_len must be <= 255 * HashSize(hmac_algorithm)
 *
 *  Notes:
 *      Calls hkdfExtract() and hkdfExpand().
 *
 *  Returns:
 *      0 on success, -1 on error.
 *
 */
int hkdf(CCHmacAlgorithm hmac_algorithm,
         const unsigned char *salt, int salt_len,
         const unsigned char *ikm, int ikm_len,
         const unsigned char *info, int info_len,
         uint8_t okm[], int okm_len) {
  uint8_t prk[mac_size_for_algorithm(hmac_algorithm)];
  
  if (mac_size_for_algorithm(hmac_algorithm) == -1)
    return -1;
  
  return hkdf_extract(hmac_algorithm, salt, salt_len, ikm, ikm_len, prk) ||
  hkdf_expand(hmac_algorithm, prk,
              mac_size_for_algorithm(hmac_algorithm),
              info, info_len, okm, okm_len);
}

/*
 *  hkdf_extract
 *
 *  Description:
 *      This function will perform HKDF extraction.
 *
 *  Parameters:
 *      hmac_algorithm: [in]
 *          One of kCCHmacAlgSHA1, kCCHmacAlgSHA256, kCCHmacAlgSHA384,
 *	    kCCHmacAlgSHA512, kCCHmacAlgSHA224.
 *      salt[]: [in]
 *          The optional salt value (a non-secret random value);
 *          if not provided (salt == NULL), it is set internally
 *          to a string of HashLen(hmac_algorithm) zeros.
 *      salt_len: [in]
 *          The length of the salt value.  (Ignored if salt == NULL.)
 *      ikm[]: [in]
 *          Input keying material.
 *      ikm_len: [in]
 *          The length of the input keying material.
 *      prk[MAX_HMAC_SIZE]: [out]
 *          Array where the HKDF extraction is to be stored.
 *          Must be larger than HashSize(hmac_algorithm);
 *
 *  Returns:
 *      0 on success, -1 on error.
 *
 */
int hkdf_extract(CCHmacAlgorithm hmac_algorithm,
                 const unsigned char *salt, int salt_len,
                 const unsigned char *ikm, int ikm_len,
                 uint8_t prk[]) {
  unsigned char null_salt[mac_size_for_algorithm(hmac_algorithm)];
  
  if (ikm == NULL || salt_len < 0)
    return -1;
  
  if (salt == NULL) {
    salt = null_salt;
    salt_len = mac_size_for_algorithm(hmac_algorithm);
    memset(null_salt, '\0', salt_len);
  }
  
  CCHmac(hmac_algorithm, salt, salt_len, ikm, ikm_len, prk);
  return 0;
}

/*
 *  hkdf_expand
 *
 *  Description:
 *      This function will perform HKDF expansion.
 *
 *  Parameters:
 *      hmac_algorithm: [in]
 *          One of kCCHmacAlgSHA1, kCCHmacAlgSHA256, kCCHmacAlgSHA384,
 *	    kCCHmacAlgSHA512, kCCHmacAlgSHA224.
 *      prk[]: [in]
 *          The pseudo-random key to be expanded; either obtained
 *          directly from a cryptographically strong, uniformly
 *          distributed pseudo-random number generator, or as the
 *          output from hkdfExtract().
 *      prk_len: [in]
 *          The length of the pseudo-random key in prk;
 *          should at least be equal to HashSize(hmac_algorithm).
 *      info[]: [in]
 *          The optional context and application specific information.
 *          If info == NULL or a zero-length string, it is ignored.
 *      info_len: [in]
 *          The length of the optional context and application specific
 *          information. (Ignored if info == NULL.)
 *      okm[]: [out]
 *          Where the HKDF is to be stored.
 *      okm_len: [in]
 *          The length of the buffer to hold okm.
 *          okm_len must be <= 255 * HashSize(hmac_algorithm)
 *
 *  Returns:
 *      0 on success, -1 on error.
 *
 */
int hkdf_expand(CCHmacAlgorithm hmac_algorithm,
                const uint8_t prk[], int prk_len,
                const unsigned char *info, int info_len,
                uint8_t okm[], int okm_len) {
  int hash_len;
  int N;
  unsigned char T[mac_size_for_algorithm(hmac_algorithm)];
  int Tlen;
  int pos;
  int i;
  
  if (info_len < 0 || prk_len <= 0 || okm_len <= 0 || okm == NULL)
    return -1;
  
  if (info == NULL) {
    info = (const unsigned char *)"";
    info_len = 0;
  }
  
  hash_len = mac_size_for_algorithm(hmac_algorithm);
  if (prk_len < hash_len)
    return -1;
  N = okm_len / hash_len;
  if (okm_len % hash_len)
    N++;
  if (N > 255)
    return -1;
  
  Tlen = 0;
  pos = 0;
  for (i = 1; i <= N; i++) {
    CCHmacContext ctx;
    unsigned char c = i;
    CCHmacInit(&ctx, hmac_algorithm, prk, prk_len);
    CCHmacUpdate(&ctx, T, Tlen);
    CCHmacUpdate(&ctx, info, info_len);
    CCHmacUpdate(&ctx, &c, 1);
    CCHmacFinal(&ctx, T);
    memcpy(okm + pos, T, (i != N) ? hash_len : (okm_len - pos));
    pos += hash_len;
    Tlen = hash_len;
  }
  return 0;
}
