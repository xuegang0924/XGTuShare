/*
 * Copyright (C) 2010-2011 QiYi.
 *
 * Author: Lau 01/11/2011.
 * 
 * This file is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * This file is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; see the file COPYING.  
 */


#import "NSDictionaryAdditions.h"

@implementation NSDictionary (NSDictionaryAdditions)

+ (NSDictionary *) dictionaryFromStringsFile: (NSString *) file
{
  NSString *serialized;
  NSMutableData *content;
  NSDictionary *newDictionary;

  content = [NSMutableData data];
  [content appendBytes: "{" length: 1];
  [content appendData: [NSData dataWithContentsOfFile: file]];
  [content appendBytes: "}" length: 1];
  serialized = [[NSString alloc] initWithData: content
				 encoding: NSUTF8StringEncoding];
  [serialized autorelease];
  newDictionary = [serialized propertyList];

  return newDictionary;
}
- (id)safeObjectForKey:(id)aKey{
    id data = [self objectForKey:aKey];
    if (data && ![data isKindOfClass:[NSNull class]]) {
        return data;
    }
    return nil;
}

-(NSString*)JSONRepresentation{
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        NSData *registerData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        NSString *json_str = [[NSString alloc] initWithData:registerData encoding:NSUTF8StringEncoding];
        QYLog(@"Register JSON:%@",json_str);
        return [json_str autorelease];
    }
    return nil;
}

@end

@implementation NSMutableDictionary (NSDictionaryAdditions)

- (void) setObject: (id) object
           forKeys: (NSArray *) keys
{
  unsigned int count, max;

  max = (unsigned int)[keys count];
  for (count = 0; count < max; count++)
    [self setObject: object
             forKey: [keys objectAtIndex: count]];
}

- (void) setObjects: (NSArray *) objects
	    forKeys: (NSArray *) keys
{
  unsigned int count, max;

  max = (unsigned int)[objects count];
  if ([keys count] == max)
    for (count = 0; count < max; count++)
      [self setObject: [objects objectAtIndex: count]
	    forKey: [keys objectAtIndex: count]];
  else
    [NSException raise: NSInvalidArgumentException
		 format: @"Number of objects does not match"
		 @" the number of keys."];
}

@end
