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


#import "NSStringAdditions.h"

#import "NSDataAdditions.h"
#import <CommonCrypto/CommonDigest.h>


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation NSString (NQSAdditions)


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isWhitespaceAndNewlines {
  NSCharacterSet* whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  for (NSInteger i = 0; i < self.length; ++i) {
    unichar c = [self characterAtIndex:i];
    if (![whitespace characterIsMember:c]) {
      return NO;
    }
  }
  return YES;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isEmptyOrWhitespace {
  return !self.length ||
         ![self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSDictionary*)queryContentsUsingEncoding:(NSStringEncoding)encoding {
  NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
  NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
  NSScanner* scanner = [[[NSScanner alloc] initWithString:self] autorelease];
  while (![scanner isAtEnd]) {
    NSString* pairString = nil;
    [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
    [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
    NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
    if (kvPair.count == 1 || kvPair.count == 2) {
      NSString* key = [[kvPair objectAtIndex:0] 
                       stringByReplacingPercentEscapesUsingEncoding:encoding];
      NSMutableArray* values = [pairs objectForKey:key];
      if (!values) {
        values = [NSMutableArray array];
        [pairs setObject:values forKey:key];
      }
      if (kvPair.count == 1) {
        [values addObject:[NSNull null]];
      } else if (kvPair.count == 2) {
        NSString* value = [[kvPair objectAtIndex:1] 
                           stringByReplacingPercentEscapesUsingEncoding:encoding];
        [values addObject:value];
      }
    }
  }
  return [NSDictionary dictionaryWithDictionary:pairs];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)stringByAddingQueryDictionary:(NSDictionary*)query {
  NSMutableArray* pairs = [NSMutableArray array];
  for (NSString* key in [query keyEnumerator]) {
    NSString* value = [query objectForKey:key];
    value = [value stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
    value = [value stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
    NSString* pair = [NSString stringWithFormat:@"%@=%@", key, value];
    [pairs addObject:pair];
  }

  NSString* params = [pairs componentsJoinedByString:@"&"];
  if ([self rangeOfString:@"?"].location == NSNotFound) {
    return [self stringByAppendingFormat:@"?%@", params];
  } else {
    return [self stringByAppendingFormat:@"&%@", params];
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)md5Hash {
  return [[self dataUsingEncoding:NSUTF8StringEncoding] md5Hash];
}

- (NSString*)sha1Hash {
  return [[self dataUsingEncoding:NSUTF8StringEncoding] sha1Hash];
}

- (NSString *)md5String
{
    const char* str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);

    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

//////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)stringWithoutPrefix:(NSString *)_prefix
{
    return ([self hasPrefix:_prefix])
	? [self substringFromIndex:[_prefix length]]
	: (NSString *)[[self copy] autorelease];
}
//////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)stringWithoutSuffix:(NSString *)_suffix
{
    return ([self hasSuffix:_suffix])
	? [self substringToIndex:([self length] - [_suffix length])]
	: (NSString *)[[self copy] autorelease];
}
//////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)stringByReplacingString:(NSString *)_orignal
						   withString:(NSString *)_replacement
{
    /* very slow solution .. */
    
    if ([self rangeOfString:_orignal].length == 0)
        return [[self copy] autorelease];
    
    return [[self componentsSeparatedByString:_orignal]
			componentsJoinedByString:_replacement];
}
//////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)stringByTrimmingLeadWhiteSpaces
{
    // should check 'whitespaceAndNewlineCharacterSet' ..
    NSUInteger len;
    
    if ((len = [self length]) > 0) {
        unichar  *buf;
        NSUInteger idx;
        
        buf = calloc(len + 1, sizeof(unichar));
        [self getCharacters:buf];
        
        for (idx = 0; (idx < len) && (buf[idx] == 32); idx++)
            ;
        
        self = [NSString stringWithCharacters:&(buf[idx]) length:(len - idx)];
        free(buf);
        return self;
    }
    else
        return [[self copy] autorelease];
}
//////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)stringByTrimmingTailWhiteSpaces
{
    // should check 'whitespaceAndNewlineCharacterSet' ..
    NSUInteger len;
    
    if ((len = [self length]) > 0) {
        unichar  *buf;
        NSUInteger idx;
        
        buf = calloc(len + 1, sizeof(unichar));
        [self getCharacters:buf];
		
        for (idx = (len - 1); (idx > -1) && (buf[idx] == 32); idx--)
            ;
        
        self = [NSString stringWithCharacters:buf length:(idx + 1)];
        free(buf);
        return self;
    }
    else
        return [[self copy] autorelease];
}
//////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)stringByTrimmingLeadSpaces
{
    NSUInteger len;
    
    if ((len = [self length]) > 0) {
        unichar  *buf;
        NSUInteger idx;
        
        buf = calloc(len + 1, sizeof(unichar));
        [self getCharacters:buf];
        
        for (idx = 0; (idx < len) && isspace(buf[idx]); idx++)
            ;
        
        self = [NSString stringWithCharacters:&(buf[idx]) length:(len - idx)];
        free(buf);
        return self;
    }
    else
        return [[self copy] autorelease];
}
//////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)stringByTrimmingTailSpaces
{
    NSUInteger len;
    
    if ((len = [self length]) > 0) {
        unichar  *buf;
        NSUInteger idx;
        
        buf = calloc(len + 1, sizeof(unichar));
        [self getCharacters:buf];
        
        for (idx = (len - 1); (idx > -1) && isspace(buf[idx]); idx--)
            ;
        
        self = [NSString stringWithCharacters:buf length:(idx + 1)];
        free(buf);
        return self;
    }
    else
        return [[self copy] autorelease];
}
//////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)stringByTrimmingWhiteSpaces
{
    return [[self stringByTrimmingTailWhiteSpaces]
			stringByTrimmingLeadWhiteSpaces];
}
//////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)stringByTrimmingSpaces
{
    return [[self stringByTrimmingTailSpaces]
			stringByTrimmingLeadSpaces];
}
//////////////////////////////////////////////////////////////////////////////////////////////////


-(NSInteger)hexValue
{
	CFStringRef cfSelf = (CFStringRef)self;
	UInt8 buffer[64];
	const char *cptr;
	
	if((cptr = CFStringGetCStringPtr(cfSelf, kCFStringEncodingMacRoman)) == NULL) {
		CFRange range     = CFRangeMake(0L, CFStringGetLength(cfSelf));
		CFIndex usedBytes = 0L;
		CFStringGetBytes(cfSelf, range, kCFStringEncodingUTF8, '?', false, buffer, 60L, &usedBytes);
		buffer[usedBytes] = 0;
		cptr              = (const char *)buffer;
	}
	
	return((NSInteger)strtol(cptr, NULL, 16));
}
//////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString*)stringWithNewUUID
{
    // Create a new UUID
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    
    // Get the string representation of the UUID
    NSString *newUUID = (NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return [newUUID autorelease];
}

//url encode
- (NSString *)encodeToPercentEscapeString {  
    // Encode all the reserved characters, per RFC 3986  
    // (<http://www.ietf.org/rfc/rfc3986.txt>)  
    NSString *outputStr = (NSString *)   
    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,  
                                            (CFStringRef)self,  
                                            NULL,  
                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",  
                                            kCFStringEncodingUTF8);  
    return [outputStr autorelease];  
}  

//url decode.
- (NSString *)decodeFromPercentEscapeString {  
    NSMutableString *outputStr = [NSMutableString stringWithString:self];  
    [outputStr replaceOccurrencesOfString:@"+"  
                               withString:@" "  
                                  options:NSLiteralSearch  
                                    range:NSMakeRange(0, [outputStr length])];  
	
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];  
}
-(NSString *)URLEncodingUTF8String{
    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (CFStringRef)self,
                                                                           NULL,
                                                                           CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                           kCFStringEncodingUTF8);
    [result autorelease];
    return result;
}
-(NSString *)URLDecodingUTF8String{
    NSString *result = (NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                           (CFStringRef)self,
                                                                                           CFSTR(""),
                                                                                           kCFStringEncodingUTF8);
    [result autorelease];
    return result;
}

- (id)JSONSerializationValue{
 
    NSDictionary *resultJSON  = nil;
    @try {
        NSData *resultData = [self dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        resultJSON = [NSJSONSerialization JSONObjectWithData:resultData options:kNilOptions error:&error];
        
        if (!resultJSON || error) {
            QYLog(@"qiyilib -JSONSerializationValue failed. Error:%@",error);
        }

    }
    @catch (NSException *exception) {
        NSLog(@"%@ , %@" , exception , [exception callStackSymbols]);
    }
    @finally {

    }
    return resultJSON;
}

- (NSDictionary*)qylibParseURLParameters{
    //event_id=a98b5ed03e28a261a1d7cba10063d087&bkt=m_lizard_main&area=m_lizard&cid=-3&fromType=1&tag=
    //http://www.iqiyi.com/iface?event_id=xx&&bkt=&cid=
    
    //sub paramters firstly, remove leading "http://www.xxxx/xx?"
    NSRange startRange = [self rangeOfString:@"?"];
    NSString *parseStr = self;
    if (startRange.length && (startRange.location+startRange.length)<self.length) {
        parseStr = [self substringFromIndex:startRange.location+1];
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (parseStr.length) {
        NSArray *paramters = [parseStr componentsSeparatedByString:@"&"];
        for (NSString *onePar in paramters) {
            NSArray *components = [onePar componentsSeparatedByString:@"="];
            if (components.count==2) {
                if ([components objectAtIndex:1]) {
                    [dict setObject:[components objectAtIndex:1] forKey:[components objectAtIndex:0]];
                }
            }else if(components.count>2) {
                if ([components objectAtIndex:1]) {
                    NSString *par = [[components subarrayWithRange:NSMakeRange(1, components.count-1)] componentsJoinedByString:@"="];
                    [dict setObject:par forKey:[components objectAtIndex:0]];
                }
            }else{
                QYLog(@"paramters format illegal");
            }
        }
    }
    return dict;
}

- (NSString*)qylibAddURLParameterWithName:(NSString*)parName value:(NSString*)parValue{
    NSDictionary *paramters = [self qylibParseURLParameters];
    NSRange startRange = [self rangeOfString:@"?"];
    NSString *parseStr = self;
    if (startRange.length) {
        parseStr = [self substringToIndex:startRange.location];
    }
    
    if (!parseStr) {
        return @"";
    }
    
    NSMutableString *str = [NSMutableString stringWithString:parseStr];
    [str appendFormat:@"?%@=%@",parName, parValue];
    
    for (NSString *key in paramters.allKeys) {
        if ([key isEqualToString:parName]) {
            //去掉服务器返回的。服务器会返回 http://www.xxx.com/?token=xxx&artener=C002
            continue;
        }
        [str appendFormat:@"&%@=%@",key,[paramters objectForKey:key]];
    }
    return str;
}

- (BOOL)qylibContainsEmoji{
    
    __block BOOL returnValue = NO;
    
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3 || ls == 0xfe0f) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}

- (int)qylibLength4ChineseAs2Bytes{
    int length = 0;
    for(int i=0; i< [self length];i++){
        int a = [self characterAtIndex:i];
        //        if( a > 0x4e00 && a < 0x9fff){
        //            //chinese character
        //            length += 2;
        //        }else{
        //            length ++;
        //        }
        if (a>=0 && a<255) {
            //ansic
            length ++;
        }else{
            //multi-bytes
            length += 2;
        }
    }
    return length;
}

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
- (NSString *)stringByTrimmingTailFloating{
    
    //79.00->79; 79.10->79.1
    if (!self) {
        return nil;
    }
    NSArray *coms = [self componentsSeparatedByString:@"."];
    if (coms.count<2 && coms.count>0) {
        //整数
        return self;
    }else if(coms.count==2){
        //小数后保留两位
        NSString *ptLeft = coms[0];
        NSString *ptRight = coms[1];
        if (ptRight.length>2) {
            ptRight = [ptRight substringWithRange:NSMakeRange(0, 2)];
        }
        
        //修正xx.x0的问题 去掉未尾的0
        NSString *fixedRight = ptRight;
        while ([ptRight hasSuffix:@"0"]) {
            fixedRight = [ptRight substringToIndex:self.length-1];
            ptRight = fixedRight;
        }
        if (ptLeft && fixedRight) {
            return [NSString stringWithFormat:@"%@.%@",ptLeft,fixedRight];
        }else if(ptLeft){
            return ptLeft;
        }else{
            return @"";
        }
    }else{
        //不处理
        return self;
    }
}

@end
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
@implementation NSMutableString(NQSAdditions)

- (void)trimLeadSpaces
{
    [self setString:[self stringByTrimmingLeadSpaces]];
}
//////////////////////////////////////////////////////////////////////////////////////////////////
- (void)trimTailSpaces
{
    [self setString:[self stringByTrimmingTailSpaces]];
}
//////////////////////////////////////////////////////////////////////////////////////////////////
- (void)trimSpaces
{
    [self setString:[self stringByTrimmingSpaces]];
}

//////////////////////////////////////////////////////////////////////////////////////////////////
- (void)stringByTrimmingSuffix:(NSString*)sufffix {
	if ([self hasSuffix:sufffix]) {
		[self deleteCharactersInRange:NSMakeRange(self.length-sufffix.length, sufffix.length)];
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////
- (void)deleteLastChar //add by xiwen
{
    NSRange t_r;
    t_r.length = 1;
    if (self.length>0) {
        t_r.location = [self length] - 1;
        [self deleteCharactersInRange:t_r];
    }
}

- (void)deleteFirstChar //add by xiwen
{
    NSRange t_r;
    t_r.length = 1;
    t_r.location = 0;
    [self deleteCharactersInRange:t_r];
}

//move to NSString(NQSAdditions)
//- (id)JSONSerializationValue{
//    //    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
//    //    id repr = [parser objectWithString:self];
//    //    if (!repr)
//    //        QYLog(@"-JSONValue failed. Error is: %@", parser.error);
//    //    return repr;
//    NSData *resultData = [self dataUsingEncoding:NSUTF8StringEncoding];
//    NSError *error = nil;
//    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:resultData options:kNilOptions error:&error];
//    if (!resultJSON || error) {
//        QYLog(@"-JSONSerializationValue failed. Error:%@",error);
//    }
//    return resultJSON;
//}

- (id)JSONValue{
    return [self JSONSerializationValue];
}
@end
