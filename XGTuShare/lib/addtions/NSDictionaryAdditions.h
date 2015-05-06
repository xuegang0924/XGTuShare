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


@class NSArray;
@class NSString;

@interface NSDictionary (NSDictionaryAdditions)

+ (NSDictionary *) dictionaryFromStringsFile: (NSString *) file;
- (id)safeObjectForKey:(id)aKey;
-(NSString*)JSONRepresentation;
@end

@interface NSMutableDictionary (NSDictionaryAdditions)

- (void) setObject: (id) object
           forKeys: (NSArray *) keys;
- (void) setObjects: (NSArray *) objects
	    forKeys: (NSArray *) keys;

@end

