#ifndef PT_PREFIX_H
#define PT_PREFIX_H

#ifdef __cplusplus
extern "C" {
#endif

/* ///////////////////////////////////////////////////////////////////////
 * includes
 */

#include <stdio.h>
#include <ctype.h>
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>
#include <asl.h>

/* ///////////////////////////////////////////////////////////////////////
 * macros
 */

// debug
#define PT_DEBUG 								(0)

// bool values
#define pt_true									((pt_bool_t)1)
#define	pt_false								((pt_bool_t)0)

// null
#ifdef __cplusplus
# 	define pt_null 								(0)
#else
# 	define pt_null 								((pt_pointer_t)0)
#endif

// trace
#if PT_DEBUG
# 	define pt_tracef(fmt, arg ...)				pt_printf(fmt, ## arg)
# 	define pt_trace(fmt, arg ...)				pt_printf(fmt "\n", ## arg)
# 	define pt_trace_line(fmt, arg ...) 			pt_printf(fmt " at func: %s, line: %d, file: %s\n", ##arg, __FUNCTION__, __LINE__, __FILE__)
#else
# 	define pt_tracef(...)
# 	define pt_trace(...)
# 	define pt_trace_line(...)
#endif

// check
#define pt_check_return(x) 						do { if (!(x)) return ; } while (0)
#define pt_check_return_val(x, v) 				do { if (!(x)) return (v); } while (0)
#define pt_check_goto(x, b) 					do { if (!(x)) goto b; } while (0)
#define pt_check_break(x) 						{ if (!(x)) break ; }
#define pt_check_continue(x) 					{ if (!(x)) continue ; }

// assert
#ifdef PT_DEBUG
# 	define pt_assert(x)							do { if (!(x)) {pt_trace_line("[assert]: expr: %s", #x); } } while(0)
# 	define pt_assert_return(x)					do { if (!(x)) {pt_trace_line("[assert]: expr: %s", #x); return ; } } while(0)
# 	define pt_assert_return_val(x, v)			do { if (!(x)) {pt_trace_line("[assert]: expr: %s", #x); return (v); } } while(0)
# 	define pt_assert_goto(x, b)					do { if (!(x)) {pt_trace_line("[assert]: expr: %s", #x); goto b; } } while(0)
# 	define pt_assert_break(x)					{ if (!(x)) {pt_trace_line("[assert]: expr: %s", #x); break ; } }
# 	define pt_assert_continue(x)				{ if (!(x)) {pt_trace_line("[assert]: expr: %s", #x); continue ; } }
# 	define pt_assert_and_check_return(x)		pt_assert_return(x)
# 	define pt_assert_and_check_return_val(x, v)	pt_assert_return_val(x, v)
# 	define pt_assert_and_check_goto(x, b)		pt_assert_goto(x, b)
# 	define pt_assert_and_check_break(x)			pt_assert_break(x)
# 	define pt_assert_and_check_continue(x)		pt_assert_continue(x)
#else
# 	define pt_assert(x)
# 	define pt_assert_return(x)
# 	define pt_assert_return_val(x, v)
# 	define pt_assert_goto(x, b)
# 	define pt_assert_break(x)
# 	define pt_assert_continue(x)
# 	define pt_assert_and_check_return(x)		pt_check_return(x)
# 	define pt_assert_and_check_return_val(x, v)	pt_check_return_val(x, v)
# 	define pt_assert_and_check_goto(x, b)		pt_check_goto(x, b)
# 	define pt_assert_and_check_break(x)			pt_check_break(x)
# 	define pt_assert_and_check_continue(x)		pt_check_continue(x)
#endif

/* ///////////////////////////////////////////////////////////////////////
 * types
 */

// basic
typedef signed int					pt_int_t;
typedef unsigned int				pt_uint_t;
typedef signed long					pt_long_t;
typedef unsigned long				pt_ulong_t;
typedef pt_ulong_t					pt_size_t;
typedef pt_int_t					pt_bool_t;
typedef signed char					pt_int8_t;
typedef pt_int8_t					pt_sint8_t;
typedef unsigned char				pt_uint8_t;
typedef signed short				pt_int16_t;
typedef pt_int16_t					pt_sint16_t;
typedef unsigned short				pt_uint16_t;
typedef pt_int_t					pt_int32_t;
typedef pt_int32_t					pt_sint32_t;
typedef pt_uint_t					pt_uint32_t;
typedef char 						pt_char_t;
typedef pt_int32_t 					pt_wchar_t;
typedef pt_int32_t 					pt_uchar_t;
typedef pt_uint8_t					pt_byte_t;
typedef void 						pt_void_t;
typedef pt_void_t* 					pt_pointer_t;
typedef pt_void_t const* 			pt_cpointer_t;
typedef pt_pointer_t 				pt_handle_t;
typedef signed long long 			pt_int64_t;
typedef unsigned long long 			pt_uint64_t;
typedef pt_int64_t					pt_sint64_t;
typedef pt_sint64_t					pt_hong_t;
typedef pt_uint64_t					pt_hize_t;
typedef float 						pt_float_t;
typedef double 						pt_double_t;

/* ///////////////////////////////////////////////////////////////////////
 * helper
 */

// printf
static inline pt_void_t pt_printf(pt_char_t const* fmt, ...)
{
	va_list list;
	pt_char_t data[8192] = {0};
	va_start(list, fmt);
	vsnprintf(data, 8191, fmt, list);
	va_end(list);

	printf("%s", data);
	asl_log(pt_null, pt_null, ASL_LEVEL_WARNING, "%s", data);
}

#ifdef __cplusplus
}
#endif


#endif

