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


#import "NSArrayAdditions.h"

#import "NSObjectAdditions.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * Additions.
 */
@implementation NSArray (NQSCategory)


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)perform:(SEL)selector {
  NSArray *copy = [[NSArray alloc] initWithArray:self];
  NSEnumerator* e = [copy objectEnumerator];
  for (id delegate; (delegate = [e nextObject]); ) {
    if ([delegate respondsToSelector:selector]) {
      [delegate performSelector:selector];
    }
  }
  [copy release];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)perform:(SEL)selector withObject:(id)p1 {
  NSArray *copy = [[NSArray alloc] initWithArray:self];
  NSEnumerator* e = [copy objectEnumerator];
  for (id delegate; (delegate = [e nextObject]); ) {
    if ([delegate respondsToSelector:selector]) {
      [delegate performSelector:selector withObject:p1];
    }
  }
  [copy release];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)perform:(SEL)selector withObject:(id)p1 withObject:(id)p2 {
  NSArray *copy = [[NSArray alloc] initWithArray:self];
  NSEnumerator* e = [copy objectEnumerator];
  for (id delegate; (delegate = [e nextObject]); ) {
    if ([delegate respondsToSelector:selector]) {
      [delegate performSelector:selector withObject:p1 withObject:p2];
    }
  }
  [copy release];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)perform:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3 {
  NSArray *copy = [[NSArray alloc] initWithArray:self];
  NSEnumerator* e = [copy objectEnumerator];
  for (id delegate; (delegate = [e nextObject]); ) {
    if ([delegate respondsToSelector:selector]) {
      [delegate performSelector:selector withObject:p1 withObject:p2 withObject:p3];
    }
  }
  [copy release];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)makeObjectsPerformSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 {
  for (id delegate in self) {
    [delegate performSelector:selector withObject:p1 withObject:p2];
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)makeObjectsPerformSelector: (SEL)selector
                        withObject: (id)p1
                        withObject: (id)p2
                        withObject: (id)p3 {
  for (id delegate in self) {
    [delegate performSelector:selector withObject:p1 withObject:p2 withObject:p3];
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)objectWithValue:(id)value forKey:(id)key {
  for (id object in self) {
    id propertyValue = [object valueForKey:key];
    if ([propertyValue isEqual:value]) {
      return object;
    }
  }
  return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)objectWithClass:(Class)cls {
  for (id object in self) {
    if ([object isKindOfClass:cls]) {
      return object;
    }
  }
  return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)containsObject:(id)object withSelector:(SEL)selector {
  for (id item in self) {
    if ([[item performSelector:selector withObject:object] boolValue]) {
      return YES;
    }
  }
  return NO;
}
///////////////////////////////////////////////////////////////////////////////////////////////////

- (NSArray *) mergedArrayWithArray: (NSArray *) otherArray
{
	NSMutableArray *mergedArray;
	NSUInteger count, max;
	id object;
	
	max = [otherArray count];
	mergedArray = [NSMutableArray arrayWithCapacity: (max + [self count])];
	[mergedArray setArray: self];
	for (count = 0; count < max; count++)
    {
		object = [otherArray objectAtIndex: count];
		if (![mergedArray containsObject: object])
			[mergedArray addObject: object];
    }
	
	return mergedArray;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSArray *) uniqueObjects
{
	NSMutableArray *newArray;
	NSEnumerator *objects;
	id currentObject;
	
	newArray = [NSMutableArray array];
	
	objects = [self objectEnumerator];
	while ((currentObject = [objects nextObject]))
		[newArray addObjectUniquely: currentObject];
	
	return newArray;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
-(NSArray *)reversedArray
{
    return [[self reverseObjectEnumerator] allObjects];
}

-(NSString*)JSONRepresentation{
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        NSData *registerData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        NSString *json_str = [[NSString alloc] initWithData:registerData encoding:NSUTF8StringEncoding];
        QYLog(@"Register JSON:%@", json_str);
        return [json_str autorelease];
    }
    return nil;
}

@end
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation NSMutableArray (NQSCategory)

- (void) addNonNSObject: (void *) objectPtr
               withSize: (size_t) objectSize
                   copy: (BOOL) doCopy
{
	void *newObjectPtr;
	
	if (doCopy)
    {
		newObjectPtr = NSZoneMalloc (NULL, objectSize);
		memcpy (newObjectPtr, objectPtr, objectSize);
    }
	else
		newObjectPtr = objectPtr;
	
	[self addObject: [NSValue valueWithPointer: newObjectPtr]];
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) freeNonNSObjects
{
	unsigned int count, max;
	void *objectPtr;
	
	max = (unsigned int)[self count];
	for (count = 0; count < max; count++)
    {
		objectPtr = [[self objectAtIndex: count] pointerValue];
		NSZoneFree (NULL, objectPtr);
    }
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) addObjectUniquely: (id) object
{
	if (![self containsObject: object])
		[self addObject: object];
}

@end
