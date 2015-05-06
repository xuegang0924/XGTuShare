#ifndef PT_MD5_IOS_H
#define PT_MD5_IOS_H

/* //////////////////////////////////////////////////////////////////////////////////////
 * includes
 */
#include "protect_prefix.h"

/* //////////////////////////////////////////////////////////////////////////////////////
 * types
 */

// data structure for md5 (message data) computation 
typedef struct __pt_md5_t
{
    pt_uint32_t     i[2];       //!< number of _bits_ handled mod 2^64 
    pt_uint32_t     sp[4];      //!< scratch buffer 
    pt_byte_t       ip[64];     //!< input buffer 
    pt_byte_t       data[16];   //!< actual data after pt_md5_exit call 

}pt_md5_t;

/* //////////////////////////////////////////////////////////////////////////////////////
 * interfaces
 */

/*! init md5 
 *
 * @param md5           the md5
 * @param pseudo_rand   the pseudo rand
 */
pt_void_t               pt_md5_init(pt_md5_t* md5, pt_uint32_t pseudo_rand);

/*! exit md5 
 *
 * @param md5           the md5
 * @param data          the data
 * @param size          the size
 */
pt_void_t               pt_md5_exit(pt_md5_t* md5, pt_byte_t* data, pt_size_t size);

/*! spak md5 
 *
 * @param md5           the md5
 * @param data          the data
 * @param size          the size
 */
pt_void_t               pt_md5_spak(pt_md5_t* md5, pt_byte_t const* data, pt_size_t size);

/*! encode md5 
 *
 * @param ib            the input data
 * @param in            the input size
 * @param ob            the output data
 * @param on            the output size
 *
 * @return              the real size
 */
pt_size_t				pt_md5_encode(pt_byte_t const* ib, pt_size_t in, pt_byte_t* ob, pt_size_t on);

#endif

