/*
 *  Lau 01/11/2011.
 *
 *  Copyright (c) 2010-2011, QiYi
 *  All rights reserved.
 *  
 *  Redistribution and use in source and binary forms, with or without
 *  modification, are permitted provided that the following conditions
 *  are met:
 *
 *  Redistributions of source code must retain the above copyright notice,
 *  this list of conditions and the following disclaimer.
 *  
 *  Redistributions in binary form must reproduce the above copyright
 *  notice, this list of conditions and the following disclaimer in the
 *  documentation and/or other materials provided with the distribution.
 *  
 *  Neither the name of this project's author nor the names of its
 *  contributors may be used to endorse or promote products derived from
 *  this software without specific prior written permission.
 *
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 *  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
 *  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS 
 *  FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 *  HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 *  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 *  TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 *  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
 *  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING 
 *  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS 
 *  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */

#import "QYCoreMacros.h" // For __TTDEPRECATED_METHOD

/**
 * Doxygen does not handle categories very well, so please refer to the .m file in general
 * for the documentation that is reflected on api.three20.info.
 */
@interface NSString (NQSAdditions)

/**
 * Determines if the string contains only whitespace and newlines.
 */
- (BOOL)isWhitespaceAndNewlines;

/**
 * Determines if the string is empty or contains only whitespace.
 */
- (BOOL)isEmptyOrWhitespace;

/**
 * Parses a URL query string into a dictionary where the values are arrays.
 */
- (NSDictionary*)queryContentsUsingEncoding:(NSStringEncoding)encoding;

/**
 * Parses a URL, adds query parameters to its query, and re-encodes it as a new URL.
 */
- (NSString*)stringByAddingQueryDictionary:(NSDictionary*)query;


- (NSString *)stringWithoutPrefix:(NSString *)_prefix;
- (NSString *)stringWithoutSuffix:(NSString *)_suffix;

- (NSString *)stringByReplacingString:(NSString *)_orignal
						   withString:(NSString *)_replacement;

- (NSString *)stringByTrimmingLeadSpaces;
- (NSString *)stringByTrimmingTailSpaces;
- (NSString *)stringByTrimmingSpaces;

/* the following are not available in gstep-base 1.6 ? */
- (NSString *)stringByTrimmingLeadWhiteSpaces;
- (NSString *)stringByTrimmingTailWhiteSpaces;
- (NSString *)stringByTrimmingWhiteSpaces;
- (NSString *)md5String;


-(NSInteger)hexValue;
/* UUID NSString */
+ (NSString*)stringWithNewUUID;

- (NSString *)encodeToPercentEscapeString;
- (NSString *)decodeFromPercentEscapeString;

-(NSString *)URLEncodingUTF8String;//编码
-(NSString *)URLDecodingUTF8String;//解码
/**
 * Calculate the md5 hash of this string using CC_MD5.
 *
 * @return md5 hash of this string
 */
@property (nonatomic, readonly) NSString* md5Hash;

/**
 * Calculate the SHA1 hash of this string using CommonCrypto CC_SHA1.
 *
 * @return NSString with SHA1 hash of this string
 */
@property (nonatomic, readonly) NSString* sha1Hash;

//json解析
- (id)JSONSerializationValue;

//添加qylib前缀,否则与外层重名
- (NSDictionary*)qylibParseURLParameters;
- (NSString*)qylibAddURLParameterWithName:(NSString*)parName value:(NSString*)parValue;
- (BOOL)qylibContainsEmoji;
- (int)qylibLength4ChineseAs2Bytes;

/*
 the JSON string is
 
 {"bid":88.667,"ask":88.704}
 after NSJSONSerialization
 {
 ask = "88.70399999999999";
 bid = "88.667";
 }
 */
//http://stackoverflow.com/questions/15569806/nsjsonserialization-jsonobjectwithdata-float-conversion-rounding-error
//http://stackoverflow.com/questions/17986409/does-nsjsonserialization-deserialize-numbers-as-nsdecimalnumber
- (NSString *)stringByTrimmingTailFloating;
@end

@interface NSMutableString(NQSAdditions)

- (void)trimLeadSpaces;
- (void)trimTailSpaces;
- (void)trimSpaces;
- (void)stringByTrimmingSuffix:(NSString*)sufffix;
- (void)deleteFirstChar; //add by xiwen
- (void)deleteLastChar; //add by xiwen

@end 

