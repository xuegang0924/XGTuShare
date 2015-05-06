/* ///////////////////////////////////////////////////////////////////////
 * includes
 */
#include "protect_prefix.h"
#include "protect_ios.h"
#include "protect_md5.h"

/* ///////////////////////////////////////////////////////////////////////
 * macros
 */

// dump the tables
//#define DUMP_TABLE

// the safe key count
#define SAFEKEY_COUNT                           (4)

// the string indexes
#define STRING_error                            (0)
#define STRING_safe_key1_iphone                 (1)
#define STRING_safe_key2_iphone                 (2)
#define STRING_safe_key1_ipad                   (3)
#define STRING_safe_key2_ipad                   (4)
#define STRING_safe_key1_iphone_comic           (5)
#define STRING_safe_key2_iphone_comic           (6)
#define STRING_safe_key1_ipad_comic             (7)
#define STRING_safe_key2_ipad_comic             (8)
#define STRING_com_qiyi_video                   (9)
#define STRING_tv_pps_mobile                    (10)
#define STRING_content_format                   (11)
#define STRING_sign_format                      (12)
#define STRING_md5_format						(13)

// get the decrypt string
#define cstr_(name) \
    get_decrypt_string(STRING_##name, crc32, ddata, sizeof(ddata))

#define cstr2_(name) \
    get_decrypt_string(STRING_##name, crc32, ddata2, sizeof(ddata2))

// done the encrypt magic
#define make_encrypt_magic_done(i) \
    do \
    { \
        (index) = ((index) + g_encrypt_magic[(i)] ^ (g_encrypt_magic[(i) << 1] >> ((i) >> 1))) % (64 - (i)); \
        (magic) ^= g_encrypt_magic[(index)]; \
        \
    } while (0)

// done the encrypt confuse
#define make_encrypt_confuse_done(i) \
    do \
    {\
        (index) = ((index) + g_encrypt_magic[(i)] + (g_encrypt_magic[(i) << 1] >> ((i) >> 2))) % (54 - (i)); \
        confuse ^= g_encrypt_magic[(index)]; \
        \
    } while (0)

// make the encrypt magic for string and address
#define make_encrypt_magic(magic, indx) \
    do \
    { \
        pt_size_t index = (indx); \
        pt_size_t confuse = 0; \
        make_encrypt_magic_done(10); \
        make_encrypt_magic_done(21); \
        make_encrypt_magic_done(2); \
        make_encrypt_magic_done(31); \
        make_encrypt_confuse_done(24); \
        make_encrypt_magic_done(4); \
        make_encrypt_magic_done(15); \
        make_encrypt_magic_done(26); \
        make_encrypt_magic_done(23); \
        make_encrypt_confuse_done(14); \
        make_encrypt_magic_done(28); \
        make_encrypt_magic_done(9); \
        make_encrypt_magic_done(0); \
        make_encrypt_magic_done(11); \
        make_encrypt_confuse_done(2); \
        make_encrypt_magic_done(22); \
        make_encrypt_magic_done(13); \
        make_encrypt_magic_done(24); \
        make_encrypt_confuse_done(12); \
        make_encrypt_magic_done(5); \
        make_encrypt_magic_done(16); \
        make_encrypt_magic_done(17); \
        make_encrypt_magic_done(8); \
        make_encrypt_confuse_done(25); \
        make_encrypt_magic_done(30); \
        make_encrypt_magic_done(20); \
        make_encrypt_magic_done(1); \
        make_encrypt_magic_done(12); \
        make_encrypt_magic_done(7); \
        make_encrypt_confuse_done(7); \
        make_encrypt_magic_done(14); \
        make_encrypt_magic_done(25); \
        make_encrypt_magic_done(6); \
        make_encrypt_magic_done(27); \
        make_encrypt_confuse_done(18); \
        make_encrypt_magic_done(18); \
        make_encrypt_magic_done(29); \
        make_encrypt_magic_done(19); \
        make_encrypt_magic_done(3); \
        \
        (magic) = (pt_byte_t)(((magic) >> 16) | (magic)) ^ ((magic) >> 24); \
        \
    } while (0)

/* ///////////////////////////////////////////////////////////////////////
 * types
 */

// the string table entry type
typedef struct __string_entry_t
{
    // the index
    pt_size_t           indx;

    // the string data
    pt_char_t const*    data;

    // the string size
    pt_size_t           size;

}string_entry_t;

/* ///////////////////////////////////////////////////////////////////////
 * globals
 */

#ifdef DUMP_TABLE
static string_entry_t g_string_table[] = 
{
#   define STRING_ENTRY(s) s, sizeof(s) - 1
    { STRING_error,                     STRING_ENTRY("error")                                                                       }
,   { STRING_safe_key1_iphone,          STRING_ENTRY("1111171717")                                                                  }
,   { STRING_safe_key2_iphone,          STRING_ENTRY("ih++++qiyi")                                                                  }
,   { STRING_safe_key1_ipad,            STRING_ENTRY("1777111717")                                                                  }
,   { STRING_safe_key2_ipad,            STRING_ENTRY("lvf(fiqi")                                                                    }
,   { STRING_safe_key1_iphone_comic,    STRING_ENTRY("1117177771")                                                                  }
,   { STRING_safe_key2_iphone_comic,    STRING_ENTRY("ugc%RcvmBds")                                                                 }
,   { STRING_safe_key1_ipad_comic,      STRING_ENTRY("1771711117")                                                                  }
,   { STRING_safe_key2_ipad_comic,      STRING_ENTRY("O00*5RGd>nv%")                                                               }
,   { STRING_com_qiyi_video,            STRING_ENTRY("com.qiyi.video")                                                              }
,   { STRING_tv_pps_mobile,             STRING_ENTRY("tv.pps.mobile")                                                               }
,   { STRING_content_format,            STRING_ENTRY("t=%lu&sign=%s")                                                               }
,   { STRING_sign_format,               STRING_ENTRY("%lu%s%s%s")                                                                   }
,   { STRING_md5_format,				STRING_ENTRY("%02x")                                                                        }

};
#else
static string_entry_t g_string_table[] = 
{
	{ 0, "\x8c\x51\x70\xf2\x12", 5}
,   { 1, "\xac\x78\xd2\xac\x2e\x5\xe2\x30\xba\x57", 10}
,   { 2, "\x23\x3f\xab\x83\xa0\x91\xe3\xb4\x42\xa6", 10}
,   { 3, "\xef\x1c\x14\xc\x12\x5b\xea\xc\xfe\x61", 10}
,   { 4, "\xd6\x7d\xc6\x7f\x54\xf4\x1b\x62", 8}
,   { 5, "\x34\xef\x82\x5b\x67\xa4\x28\x3c\xaa\xe2", 10}
,   { 6, "\xe8\x44\x9\xfe\x69\xac\x20\x17\xa7\xde\x33", 11}
,   { 7, "\x66\x5\xaa\x5b\x3c\x66\x2a\x4b\x33\xcd", 10}
,   { 8, "\xad\x35\x91\x6a\x75\xd2\xda\xca\xc4\x6b\x20\xfb", 12}
,   { 9, "\x83\xd5\x3\x58\xa2\x8b\x30\x7\x44\xfa\x20\x8\x5e\xf", 14}
,   { 10, "\x34\x18\x58\xa3\x92\x3a\x40\x7\xe3\x2b\x5\x57\x5", 13}
,   { 11, "\xf4\x87\x4b\x96\xe8\x23\x68\x89\x2e\x2\x6\x45\x91", 13}
,   { 12, "\xb7\x25\xd5\x84\x1d\x4f\xff\x6c\x1f", 9}
,   { 13, "\x85\xbb\xfd\x18", 4}
};
#endif

// the encrypt magic table
static pt_uint32_t const g_encrypt_magic[64] = 
{
    0x42812f98, 0x71374191, 0xb5c0fbff, 0xe9b5d9a5
,   0x3952c25b, 0x59f112f1, 0x923f82f4, 0xab1c5ed8
,   0xd803aa98, 0x12835301, 0x243185ee, 0x550c7dc7
,   0x72b45d74, 0x80deb4fe, 0x9bdc06e7, 0xc19bf176
,   0xe49569c1, 0xefbe4586, 0x0fc19de6, 0x240ca1cc
,   0x2de62c6f, 0x4a74846a, 0x5cb0a9ec, 0x76f988da
,   0x98375152, 0xa831c67d, 0xb00327e8, 0xbf597fc7
,   0xc6e80bf3, 0xd5a79197, 0x06ca63e1, 0x14292967
,   0x27b90a85, 0x2e1b21a8, 0x4d2c6dbc, 0x53380d13
,   0x65017354, 0x766a0aab, 0x81c2c94e, 0x92722c86
,   0xa2b2e8a1, 0xa81a66ab, 0xc24b8b80, 0xc76c51a3
,   0xd193e819, 0xd69906c4, 0xf40e3585, 0x106aa070
,   0x19a4c116, 0x1e376cc8, 0x2748774c, 0x34b0bcb5
,   0x39150cb3, 0x4ed8aaca, 0x5b9cca4f, 0x682e6ff3
,   0x748682ee, 0x78a563cf, 0x84c87814, 0x8cc70208
,   0x90b7fffa, 0xa4506ccb, 0xbef9a3f7, 0xc67178f2
};

// the crc32 table
static pt_uint32_t const g_crc32_table[] = 
{
    0x00000000, 0x77073096, 0xee0e612c, 0x990951ba, 0x076dc419, 0x706af48f
,	0xe963a535, 0x9e6495a3, 0x0edb8832, 0x79dcb8a4, 0xe0d5e91e, 0x97d2d988
,	0x09b64c2b, 0x7eb17cbd, 0xe7b82d07, 0x90bf1d91, 0x1db71064, 0x6ab020f2
,	0xf3b97148, 0x84be41de, 0x1adad47d, 0x6ddde4eb, 0xf4d4b551, 0x83d385c7
,	0x136c9856, 0x646ba8c0, 0xfd62f97a, 0x8a65c9ec, 0x14015c4f, 0x63066cd9
,	0xfa0f3d63, 0x8d080df5, 0x3b6e20c8, 0x4c69105e, 0xd56041e4, 0xa2677172
,	0x3c03e4d1, 0x4b04d447, 0xd20d85fd, 0xa50ab56b, 0x35b5a8fa, 0x42b2986c
,	0xdbbbc9d6, 0xacbcf940, 0x32d86ce3, 0x45df5c75, 0xdcd60dcf, 0xabd13d59
,	0x26d930ac, 0x51de003a, 0xc8d75180, 0xbfd06116, 0x21b4f4b5, 0x56b3c423
,	0xcfba9599, 0xb8bda50f, 0x2802b89e, 0x5f058808, 0xc60cd9b2, 0xb10be924
,	0x2f6f7c87, 0x58684c11, 0xc1611dab, 0xb6662d3d, 0x76dc4190, 0x01db7106
,	0x98d220bc, 0xefd5102a, 0x71b18589, 0x06b6b51f, 0x9fbfe4a5, 0xe8b8d433
,	0x7807c9a2, 0x0f00f934, 0x9609a88e, 0xe10e9818, 0x7f6a0dbb, 0x086d3d2d
,	0x91646c97, 0xe6635c01, 0x6b6b51f4, 0x1c6c6162, 0x856530d8, 0xf262004e
,	0x6c0695ed, 0x1b01a57b, 0x8208f4c1, 0xf50fc457, 0x65b0d9c6, 0x12b7e950
,	0x8bbeb8ea, 0xfcb9887c, 0x62dd1ddf, 0x15da2d49, 0x8cd37cf3, 0xfbd44c65
,	0x4db26158, 0x3ab551ce, 0xa3bc0074, 0xd4bb30e2, 0x4adfa541, 0x3dd895d7
,	0xa4d1c46d, 0xd3d6f4fb, 0x4369e96a, 0x346ed9fc, 0xad678846, 0xda60b8d0
,	0x44042d73, 0x33031de5, 0xaa0a4c5f, 0xdd0d7cc9, 0x5005713c, 0x270241aa
,	0xbe0b1010, 0xc90c2086, 0x5768b525, 0x206f85b3, 0xb966d409, 0xce61e49f
,	0x5edef90e, 0x29d9c998, 0xb0d09822, 0xc7d7a8b4, 0x59b33d17, 0x2eb40d81
,	0xb7bd5c3b, 0xc0ba6cad, 0xedb88320, 0x9abfb3b6, 0x03b6e20c, 0x74b1d29a
,	0xead54739, 0x9dd277af, 0x04db2615, 0x73dc1683, 0xe3630b12, 0x94643b84
,	0x0d6d6a3e, 0x7a6a5aa8, 0xe40ecf0b, 0x9309ff9d, 0x0a00ae27, 0x7d079eb1
,	0xf00f9344, 0x8708a3d2, 0x1e01f268, 0x6906c2fe, 0xf762575d, 0x806567cb
,	0x196c3671, 0x6e6b06e7, 0xfed41b76, 0x89d32be0, 0x10da7a5a, 0x67dd4acc
,	0xf9b9df6f, 0x8ebeeff9, 0x17b7be43, 0x60b08ed5, 0xd6d6a3e8, 0xa1d1937e
,	0x38d8c2c4, 0x4fdff252, 0xd1bb67f1, 0xa6bc5767, 0x3fb506dd, 0x48b2364b
,	0xd80d2bda, 0xaf0a1b4c, 0x36034af6, 0x41047a60, 0xdf60efc3, 0xa867df55
,	0x316e8eef, 0x4669be79, 0xcb61b38c, 0xbc66831a, 0x256fd2a0, 0x5268e236
,	0xcc0c7795, 0xbb0b4703, 0x220216b9, 0x5505262f, 0xc5ba3bbe, 0xb2bd0b28
,	0x2bb45a92, 0x5cb36a04, 0xc2d7ffa7, 0xb5d0cf31, 0x2cd99e8b, 0x5bdeae1d
,	0x9b64c2b0, 0xec63f226, 0x756aa39c, 0x026d930a, 0x9c0906a9, 0xeb0e363f
,	0x72076785, 0x05005713, 0x95bf4a82, 0xe2b87a14, 0x7bb12bae, 0x0cb61b38
,	0x92d28e9b, 0xe5d5be0d, 0x7cdcefb7, 0x0bdbdf21, 0x86d3d2d4, 0xf1d4e242
,	0x68ddb3f8, 0x1fda836e, 0x81be16cd, 0xf6b9265b, 0x6fb077e1, 0x18b74777
,	0x88085ae6, 0xff0f6a70, 0x66063bca, 0x11010b5c, 0x8f659eff, 0xf862ae69
,	0x616bffd3, 0x166ccf45, 0xa00ae278, 0xd70dd2ee, 0x4e048354, 0x3903b3c2
,	0xa7672661, 0xd06016f7, 0x4969474d, 0x3e6e77db, 0xaed16a4a, 0xd9d65adc
,	0x40df0b66, 0x37d83bf0, 0xa9bcae53, 0xdebb9ec5, 0x47b2cf7f, 0x30b5ffe9
,	0xbdbdf21c, 0xcabac28a, 0x53b39330, 0x24b4a3a6, 0xbad03605, 0xcdd70693
,	0x54de5729, 0x23d967bf, 0xb3667a2e, 0xc4614ab8, 0x5d681b02, 0x2a6f2b94
,	0xb40bbe37, 0xc30c8ea1, 0x5a05df1b, 0x2d02ef8d
};

/* ///////////////////////////////////////////////////////////////////////
 * implementation
 */
static pt_void_t make_encrypt_string_table()
{
#ifdef DUMP_TABLE
    // compute the crc32 of the self code
    pt_byte_t const*    code_p = (pt_byte_t const*)&getProtectContent;
    pt_byte_t const*    code_e = code_p + 760;
    pt_size_t           crc32 = 0;
    while (code_p < code_e) crc32 = g_crc32_table[((pt_uint8_t)crc32) ^ *code_p++] ^ (crc32 >> 8);

    // trace
    pt_trace("crc32: %x", crc32);

    // done
    pt_size_t i = 0;
    pt_size_t n = sizeof(g_string_table) / sizeof(string_entry_t);
    for (i = 0; i < n; i++)
    {
        // trace
        printf(",   { %lu, \"", g_string_table[i].indx);

        // dump
        pt_size_t j = 0;
        pt_size_t m = g_string_table[i].size;
        pt_size_t l = 0;
        for (j = 0; j < m; j++)
        {
            // make magic
            pt_size_t magic = 0;//crc32;
            make_encrypt_magic(magic, (g_string_table[i].indx + j) ^ l);
            l = magic;

            // encrypt it
            pt_byte_t byte = (pt_byte_t)g_string_table[i].data[j] ^ (pt_byte_t)magic;

            // trace
            printf("\\x%x", byte);
        }

        // trace
        printf("\", %lu}\n", m);
    }
#endif
}
static pt_char_t const* get_decrypt_string(pt_size_t indx, pt_size_t crc32, pt_char_t* data, pt_size_t maxn)
{
	// check
	pt_assert_and_check_return_val(data && maxn, pt_null);
	
	// the table size
	pt_size_t table_size = sizeof(g_string_table) / sizeof(string_entry_t);
	
	// check
	pt_assert_and_check_return_val(indx < table_size, pt_null);
	pt_assert_and_check_return_val(g_string_table[indx].indx == indx, pt_null);
	pt_assert_and_check_return_val(g_string_table[indx].size < maxn, pt_null);
	pt_assert_and_check_return_val(g_string_table[indx].data, pt_null);
	
	// done
	pt_size_t i = 0;
	pt_size_t n = g_string_table[indx].size;
	pt_size_t l = 0;
	for (i = 0; i < n; i++)
	{
		// make magic
		pt_size_t magic = 0;//crc32;
		make_encrypt_magic(magic, (g_string_table[indx].indx + i) ^ l);
		l = magic;
		
		// decrypt it
		data[i] = (pt_char_t)(pt_byte_t)g_string_table[indx].data[i] ^ (pt_byte_t)magic;
	}
	
	// end
	data[i] = '\0';
	
	// ok
	return data;
}
static pt_bool_t get_safekey(pt_size_t crc32, pt_size_t platform, pt_size_t* key1, pt_char_t* key2_data, pt_size_t key2_maxn)
{
    // check
    pt_assert_and_check_return_val(platform < SAFEKEY_COUNT && key1 && key2_data && key2_maxn, pt_false);

    // the safe key string index
    pt_size_t safe_key1 = STRING_safe_key1_iphone + (platform << 1);
    pt_size_t safe_key2 = STRING_safe_key2_iphone + (platform << 1);

    // decrypt the safe key string
    pt_char_t key1_data[512];
    get_decrypt_string(safe_key1, crc32, key1_data, sizeof(key1_data) - 1);
    get_decrypt_string(safe_key2, crc32, key2_data, key2_maxn);
	
    // save the key1
	*key1 = (pt_size_t)atoll(key1_data);

    // ok
    return pt_true;
}
NSString* getProtectContent(int platform, char const* key, char const* version)
{
	// done
    pt_char_t   ddata[512];
    pt_char_t   safe_key2[512];
    pt_char_t   buffer[8192];
    pt_long_t   buffer_size = 0;
	NSString*	content = pt_null;
	do
	{
        // check
        pt_assert_and_check_break(key && version);
		
		// make table
		make_encrypt_string_table();

        // compute the crc32 of the self code
        pt_byte_t const*    code_p = (pt_byte_t const*)&getProtectContent;
        pt_byte_t const*    code_e = code_p + 760;
        pt_size_t           crc32 = 0;
        while (code_p < code_e) crc32 = g_crc32_table[((pt_uint8_t)crc32) ^ *code_p++] ^ (crc32 >> 8);

        // trace
        pt_trace("crc32: %x", crc32);

        // get the safe key
        pt_size_t safe_key1;
        if (!get_safekey(crc32, platform, &safe_key1, safe_key2, sizeof(safe_key2))) break;

        // trace
        pt_trace("safekey: %lu %s", safe_key1, safe_key2);

        // get the current timestamp(s)
		pt_size_t timestamp = (pt_size_t)time(0);

        // trace
        pt_trace("timestamp: %lu", timestamp);

        // trace
        pt_trace("key: %s", key);

        // trace
        pt_trace("version: %s", version);

        // make the sign string
        buffer_size = snprintf(buffer, sizeof(buffer) - 1, cstr_(sign_format), timestamp, safe_key2, key, version);
        pt_assert_and_check_break(buffer_size >= 0 && buffer_size < sizeof(buffer) - 1);
        buffer[buffer_size] = '\0';

        // trace
        pt_trace("sign: %s", buffer);

        // make the sign md5 data
		pt_byte_t sign_md5[16];
		if (16 != pt_md5_encode((pt_byte_t const*)buffer, buffer_size, sign_md5, sizeof(sign_md5))) break;

		// make the sign md5 string
		pt_size_t i = 0;
		pt_char_t sign_md5_str[256] = {0};
		for (i = 0; i < 16; ++i) snprintf(sign_md5_str + (i << 1), 3, cstr_(md5_format), sign_md5[i]);
		
        // trace
        pt_trace("sign_md5: %s", sign_md5_str);

		// make content string: t=xxx&sign=xxxx
        buffer_size = snprintf(buffer, sizeof(buffer) - 1, cstr_(content_format), (timestamp ^ safe_key1), sign_md5_str);
        pt_assert_and_check_break(buffer_size >= 0 && buffer_size < sizeof(buffer) - 1);
        buffer[buffer_size] = '\0';

        // trace
        pt_trace("content: %s", buffer);

		// ok
		content = [NSString stringWithUTF8String:buffer];

	} while (0);

    // error?
    if (!content) content = @"error";

	// ok?
	return content;
}
