/*!The Treasure Box Library
 * 
 * TBox is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; either version 2.1 of the License, or
 * (at your option) any later version.
 * 
 * TBox is distributed ip the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more implementaion.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with TBox; 
 * If not, see <a href="http://www.gnu.org/licenses/"> http://www.gnu.org/licenses/</a>
 * 
 * Copyright (C) 2009 - 2015, ruki All rights reserved.
 *
 * @author      ruki
 * @file        md5.c
 * @ingroup     utils
 *
 */

/* //////////////////////////////////////////////////////////////////////////////////////
 * includes
 */
#include "protect_md5.h"

/* //////////////////////////////////////////////////////////////////////////////////////
 * macros
 */

// PT_MD5_F, PT_MD5_G and PT_MD5_H are basic MD5 functions: selection, majority, parity 
#define PT_MD5_F(x, y, z)   (((x) & (y)) | ((~x) & (z)))
#define PT_MD5_G(x, y, z)   (((x) & (z)) | ((y) & (~z)))
#define PT_MD5_H(x, y, z)   ((x) ^ (y) ^ (z))
#define PT_MD5_I(x, y, z)   ((y) ^ ((x) | (~z)))

// PT_MD5_ROTATE_LEFT rotates x left n bits */
#define PT_MD5_ROTATE_LEFT(x, n)    (((x) << (n)) | ((x) >> (32 - (n))))

// PT_MD5_FF, PT_MD5_GG, PT_MD5_HH, and PT_MD5_II transformations for rounds 1, 2, 3, and 4
// Rotation is separate from addition to prevent recomputation
#define PT_MD5_FF(a, b, c, d, x, s, ac) {(a) += PT_MD5_F ((b), (c), (d)) + (x) + (pt_uint32_t)(ac); (a) = PT_MD5_ROTATE_LEFT ((a), (s)); (a) += (b); }
#define PT_MD5_GG(a, b, c, d, x, s, ac) {(a) += PT_MD5_G ((b), (c), (d)) + (x) + (pt_uint32_t)(ac); (a) = PT_MD5_ROTATE_LEFT ((a), (s)); (a) += (b); }
#define PT_MD5_HH(a, b, c, d, x, s, ac) {(a) += PT_MD5_H ((b), (c), (d)) + (x) + (pt_uint32_t)(ac); (a) = PT_MD5_ROTATE_LEFT ((a), (s)); (a) += (b); }
#define PT_MD5_II(a, b, c, d, x, s, ac) {(a) += PT_MD5_I ((b), (c), (d)) + (x) + (pt_uint32_t)(ac); (a) = PT_MD5_ROTATE_LEFT ((a), (s)); (a) += (b); }

// Constants for transformation 
#define PT_MD5_S11 7  // Round 1
#define PT_MD5_S12 12
#define PT_MD5_S13 17
#define PT_MD5_S14 22
#define PT_MD5_S21 5  // Round 2
#define PT_MD5_S22 9
#define PT_MD5_S23 14
#define PT_MD5_S24 20
#define PT_MD5_S31 4  // Round 3
#define PT_MD5_S32 11
#define PT_MD5_S33 16
#define PT_MD5_S34 23
#define PT_MD5_S41 6  // Round 4
#define PT_MD5_S42 10
#define PT_MD5_S43 15
#define PT_MD5_S44 21

/* //////////////////////////////////////////////////////////////////////////////////////
 * globals
 */

/* Padding */
static pt_byte_t g_md5_padding[64] = 
{
    0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
,   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
,   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
,   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
,   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
,   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
,   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
,   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
};

/* //////////////////////////////////////////////////////////////////////////////////////
 * implementaion
 */

// basic md5 step. the sp based on ip
static pt_void_t pt_md5_transform(pt_uint32_t* sp, pt_uint32_t* ip)
{
    // check
    pt_assert_and_check_return(sp && ip);

    // init
    pt_uint32_t a = sp[0], b = sp[1], c = sp[2], d = sp[3];

    // round 1 
    PT_MD5_FF ( a, b, c, d, ip[ 0], PT_MD5_S11, (pt_uint32_t) 3614090360u); /* 1 */
    PT_MD5_FF ( d, a, b, c, ip[ 1], PT_MD5_S12, (pt_uint32_t) 3905402710u); /* 2 */
    PT_MD5_FF ( c, d, a, b, ip[ 2], PT_MD5_S13, (pt_uint32_t)  606105819u); /* 3 */
    PT_MD5_FF ( b, c, d, a, ip[ 3], PT_MD5_S14, (pt_uint32_t) 3250441966u); /* 4 */
    PT_MD5_FF ( a, b, c, d, ip[ 4], PT_MD5_S11, (pt_uint32_t) 4118548399u); /* 5 */
    PT_MD5_FF ( d, a, b, c, ip[ 5], PT_MD5_S12, (pt_uint32_t) 1200080426u); /* 6 */
    PT_MD5_FF ( c, d, a, b, ip[ 6], PT_MD5_S13, (pt_uint32_t) 2821735955u); /* 7 */
    PT_MD5_FF ( b, c, d, a, ip[ 7], PT_MD5_S14, (pt_uint32_t) 4249261313u); /* 8 */
    PT_MD5_FF ( a, b, c, d, ip[ 8], PT_MD5_S11, (pt_uint32_t) 1770035416u); /* 9 */
    PT_MD5_FF ( d, a, b, c, ip[ 9], PT_MD5_S12, (pt_uint32_t) 2336552879u); /* 10 */
    PT_MD5_FF ( c, d, a, b, ip[10], PT_MD5_S13, (pt_uint32_t) 4294925233u); /* 11 */
    PT_MD5_FF ( b, c, d, a, ip[11], PT_MD5_S14, (pt_uint32_t) 2304563134u); /* 12 */
    PT_MD5_FF ( a, b, c, d, ip[12], PT_MD5_S11, (pt_uint32_t) 1804603682u); /* 13 */
    PT_MD5_FF ( d, a, b, c, ip[13], PT_MD5_S12, (pt_uint32_t) 4254626195u); /* 14 */
    PT_MD5_FF ( c, d, a, b, ip[14], PT_MD5_S13, (pt_uint32_t) 2792965006u); /* 15 */
    PT_MD5_FF ( b, c, d, a, ip[15], PT_MD5_S14, (pt_uint32_t) 1236535329u); /* 16 */

    // round 2
    PT_MD5_GG ( a, b, c, d, ip[ 1], PT_MD5_S21, (pt_uint32_t) 4129170786u); /* 17 */
    PT_MD5_GG ( d, a, b, c, ip[ 6], PT_MD5_S22, (pt_uint32_t) 3225465664u); /* 18 */
    PT_MD5_GG ( c, d, a, b, ip[11], PT_MD5_S23, (pt_uint32_t)  643717713u); /* 19 */
    PT_MD5_GG ( b, c, d, a, ip[ 0], PT_MD5_S24, (pt_uint32_t) 3921069994u); /* 20 */
    PT_MD5_GG ( a, b, c, d, ip[ 5], PT_MD5_S21, (pt_uint32_t) 3593408605u); /* 21 */
    PT_MD5_GG ( d, a, b, c, ip[10], PT_MD5_S22, (pt_uint32_t)   38016083u); /* 22 */
    PT_MD5_GG ( c, d, a, b, ip[15], PT_MD5_S23, (pt_uint32_t) 3634488961u); /* 23 */
    PT_MD5_GG ( b, c, d, a, ip[ 4], PT_MD5_S24, (pt_uint32_t) 3889429448u); /* 24 */
    PT_MD5_GG ( a, b, c, d, ip[ 9], PT_MD5_S21, (pt_uint32_t)  568446438u); /* 25 */
    PT_MD5_GG ( d, a, b, c, ip[14], PT_MD5_S22, (pt_uint32_t) 3275163606u); /* 26 */
    PT_MD5_GG ( c, d, a, b, ip[ 3], PT_MD5_S23, (pt_uint32_t) 4107603335u); /* 27 */
    PT_MD5_GG ( b, c, d, a, ip[ 8], PT_MD5_S24, (pt_uint32_t) 1163531501u); /* 28 */
    PT_MD5_GG ( a, b, c, d, ip[13], PT_MD5_S21, (pt_uint32_t) 2850285829u); /* 29 */
    PT_MD5_GG ( d, a, b, c, ip[ 2], PT_MD5_S22, (pt_uint32_t) 4243563512u); /* 30 */
    PT_MD5_GG ( c, d, a, b, ip[ 7], PT_MD5_S23, (pt_uint32_t) 1735328473u); /* 31 */
    PT_MD5_GG ( b, c, d, a, ip[12], PT_MD5_S24, (pt_uint32_t) 2368359562u); /* 32 */

    // round 3
    PT_MD5_HH ( a, b, c, d, ip[ 5], PT_MD5_S31, (pt_uint32_t) 4294588738u); /* 33 */
    PT_MD5_HH ( d, a, b, c, ip[ 8], PT_MD5_S32, (pt_uint32_t) 2272392833u); /* 34 */
    PT_MD5_HH ( c, d, a, b, ip[11], PT_MD5_S33, (pt_uint32_t) 1839030562u); /* 35 */
    PT_MD5_HH ( b, c, d, a, ip[14], PT_MD5_S34, (pt_uint32_t) 4259657740u); /* 36 */
    PT_MD5_HH ( a, b, c, d, ip[ 1], PT_MD5_S31, (pt_uint32_t) 2763975236u); /* 37 */
    PT_MD5_HH ( d, a, b, c, ip[ 4], PT_MD5_S32, (pt_uint32_t) 1272893353u); /* 38 */
    PT_MD5_HH ( c, d, a, b, ip[ 7], PT_MD5_S33, (pt_uint32_t) 4139469664u); /* 39 */
    PT_MD5_HH ( b, c, d, a, ip[10], PT_MD5_S34, (pt_uint32_t) 3200236656u); /* 40 */
    PT_MD5_HH ( a, b, c, d, ip[13], PT_MD5_S31, (pt_uint32_t)  681279174u); /* 41 */
    PT_MD5_HH ( d, a, b, c, ip[ 0], PT_MD5_S32, (pt_uint32_t) 3936430074u); /* 42 */
    PT_MD5_HH ( c, d, a, b, ip[ 3], PT_MD5_S33, (pt_uint32_t) 3572445317u); /* 43 */
    PT_MD5_HH ( b, c, d, a, ip[ 6], PT_MD5_S34, (pt_uint32_t)   76029189u); /* 44 */
    PT_MD5_HH ( a, b, c, d, ip[ 9], PT_MD5_S31, (pt_uint32_t) 3654602809u); /* 45 */
    PT_MD5_HH ( d, a, b, c, ip[12], PT_MD5_S32, (pt_uint32_t) 3873151461u); /* 46 */
    PT_MD5_HH ( c, d, a, b, ip[15], PT_MD5_S33, (pt_uint32_t)  530742520u); /* 47 */
    PT_MD5_HH ( b, c, d, a, ip[ 2], PT_MD5_S34, (pt_uint32_t) 3299628645u); /* 48 */

    // round 4
    PT_MD5_II ( a, b, c, d, ip[ 0], PT_MD5_S41, (pt_uint32_t) 4096336452u); /* 49 */
    PT_MD5_II ( d, a, b, c, ip[ 7], PT_MD5_S42, (pt_uint32_t) 1126891415u); /* 50 */
    PT_MD5_II ( c, d, a, b, ip[14], PT_MD5_S43, (pt_uint32_t) 2878612391u); /* 51 */
    PT_MD5_II ( b, c, d, a, ip[ 5], PT_MD5_S44, (pt_uint32_t) 4237533241u); /* 52 */
    PT_MD5_II ( a, b, c, d, ip[12], PT_MD5_S41, (pt_uint32_t) 1700485571u); /* 53 */
    PT_MD5_II ( d, a, b, c, ip[ 3], PT_MD5_S42, (pt_uint32_t) 2399980690u); /* 54 */
    PT_MD5_II ( c, d, a, b, ip[10], PT_MD5_S43, (pt_uint32_t) 4293915773u); /* 55 */
    PT_MD5_II ( b, c, d, a, ip[ 1], PT_MD5_S44, (pt_uint32_t) 2240044497u); /* 56 */
    PT_MD5_II ( a, b, c, d, ip[ 8], PT_MD5_S41, (pt_uint32_t) 1873313359u); /* 57 */
    PT_MD5_II ( d, a, b, c, ip[15], PT_MD5_S42, (pt_uint32_t) 4264355552u); /* 58 */
    PT_MD5_II ( c, d, a, b, ip[ 6], PT_MD5_S43, (pt_uint32_t) 2734768916u); /* 59 */
    PT_MD5_II ( b, c, d, a, ip[13], PT_MD5_S44, (pt_uint32_t) 1309151649u); /* 60 */
    PT_MD5_II ( a, b, c, d, ip[ 4], PT_MD5_S41, (pt_uint32_t) 4149444226u); /* 61 */
    PT_MD5_II ( d, a, b, c, ip[11], PT_MD5_S42, (pt_uint32_t) 3174756917u); /* 62 */
    PT_MD5_II ( c, d, a, b, ip[ 2], PT_MD5_S43, (pt_uint32_t)  718787259u); /* 63 */
    PT_MD5_II ( b, c, d, a, ip[ 9], PT_MD5_S44, (pt_uint32_t) 3951481745u); /* 64 */

    sp[0] += a;
    sp[1] += b;
    sp[2] += c;
    sp[3] += d;
}

/* //////////////////////////////////////////////////////////////////////////////////////
 * implementation
 */

// set pseudo_rand to zero for rfc md5 implementation
pt_void_t pt_md5_init(pt_md5_t* md5, pt_uint32_t pseudo_rand)
{
    // check
    pt_assert_and_check_return(md5);

    // init
    md5->i[0] = md5->i[1] = (pt_uint32_t)0;

    // load magic initialization constants 
    md5->sp[0] = (pt_uint32_t)0x67452301 + (pseudo_rand * 11);
    md5->sp[1] = (pt_uint32_t)0xefcdab89 + (pseudo_rand * 71);
    md5->sp[2] = (pt_uint32_t)0x98badcfe + (pseudo_rand * 37);
    md5->sp[3] = (pt_uint32_t)0x10325476 + (pseudo_rand * 97);
}

pt_void_t pt_md5_spak(pt_md5_t* md5, pt_byte_t const* data, pt_size_t size)
{
    // check
    pt_assert_and_check_return(md5 && data);

    // init
    pt_uint32_t ip[16];
    pt_size_t   i = 0, ii = 0;

    // compute number of bytes mod 64
    pt_int_t mdi = (pt_int_t)((md5->i[0] >> 3) & 0x3F);

    // update number of bits
    if ((md5->i[0] + ((pt_uint32_t)size << 3)) < md5->i[0]) md5->i[1]++;

    md5->i[0] += ((pt_uint32_t)size << 3);
    md5->i[1] += ((pt_uint32_t)size >> 29);

    while (size--)
    {
        // add new character to buffer, increment mdi
        md5->ip[mdi++] = *data++;

        // transform if necessary 
        if (mdi == 0x40)
        {
            for (i = 0, ii = 0; i < 16; i++, ii += 4)
            {
                ip[i] =     (((pt_uint32_t)md5->ip[ii + 3]) << 24)
                        |   (((pt_uint32_t)md5->ip[ii + 2]) << 16)
                        |   (((pt_uint32_t)md5->ip[ii + 1]) << 8)
                        |   ((pt_uint32_t)md5->ip[ii]);
            }

            pt_md5_transform(md5->sp, ip);
            mdi = 0;
        }
    }
}

pt_void_t pt_md5_exit(pt_md5_t* md5, pt_byte_t* data, pt_size_t size)
{
    // check
    pt_assert_and_check_return(md5 && data);

    // init
    pt_uint32_t ip[16];
    pt_int_t    mdi = 0;
    pt_size_t   i = 0;
    pt_size_t   ii = 0;
    pt_size_t   pad_n = 0;

    // save number of bits 
    ip[14] = md5->i[0];
    ip[15] = md5->i[1];

    // compute number of bytes mod 64
    mdi = (pt_int_t)((md5->i[0] >> 3) & 0x3F);

    // pad out to 56 mod 64
    pad_n = (mdi < 56) ? (56 - mdi) : (120 - mdi);
    pt_md5_spak (md5, g_md5_padding, pad_n);

    // append length ip bits and transform
    for (i = 0, ii = 0; i < 14; i++, ii += 4)
    {
        ip[i] =     (((pt_uint32_t)md5->ip[ii + 3]) << 24)
                |   (((pt_uint32_t)md5->ip[ii + 2]) << 16)
                |   (((pt_uint32_t)md5->ip[ii + 1]) <<  8)
                |   ((pt_uint32_t)md5->ip[ii]);
    }
    pt_md5_transform (md5->sp, ip);

    // store buffer ip data
    for (i = 0, ii = 0; i < 4; i++, ii += 4)
    {
        md5->data[ii]   = (pt_byte_t)( md5->sp[i]        & 0xff);
        md5->data[ii+1] = (pt_byte_t)((md5->sp[i] >>  8) & 0xff);
        md5->data[ii+2] = (pt_byte_t)((md5->sp[i] >> 16) & 0xff);
        md5->data[ii+3] = (pt_byte_t)((md5->sp[i] >> 24) & 0xff);
    }

    // output
    memcpy(data, md5->data, 16);
}

pt_size_t pt_md5_encode(pt_byte_t const* ib, pt_size_t in, pt_byte_t* ob, pt_size_t on)
{
    // check
    pt_assert_and_check_return_val(ib && in && ob && on >= 16, 0);

    // init 
    pt_md5_t md5;
    pt_md5_init(&md5, 0);

    // spank
    pt_md5_spak(&md5, ib, in);

    // exit
    pt_md5_exit(&md5, ob, on);

    // ok
    return 16;
}

