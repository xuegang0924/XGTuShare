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


#import "NSObjectAdditions.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * Additions.
 */
@implementation NSObject (QY)


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3 {
  NSMethodSignature *sig = [self methodSignatureForSelector:selector];
  if (sig) {
    NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
    [invo setTarget:self];
    [invo setSelector:selector];
    [invo setArgument:&p1 atIndex:2];
    [invo setArgument:&p2 atIndex:3];
    [invo setArgument:&p3 atIndex:4];
    [invo invoke];
    if (sig.methodReturnLength) {
      id anObject;
      [invo getReturnValue:&anObject];
      return anObject;
    } else {
      return nil;
    }
  } else {
    return nil;
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3
    withObject:(id)p4 {
  NSMethodSignature *sig = [self methodSignatureForSelector:selector];
  if (sig) {
    NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
    [invo setTarget:self];
    [invo setSelector:selector];
    [invo setArgument:&p1 atIndex:2];
    [invo setArgument:&p2 atIndex:3];
    [invo setArgument:&p3 atIndex:4];
    [invo setArgument:&p4 atIndex:5];
    [invo invoke];
    if (sig.methodReturnLength) {
      id anObject;
      [invo getReturnValue:&anObject];
      return anObject;
    } else {
      return nil;
    }
  } else {
    return nil;
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3
    withObject:(id)p4 withObject:(id)p5 {
  NSMethodSignature *sig = [self methodSignatureForSelector:selector];
  if (sig) {
    NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
    [invo setTarget:self];
    [invo setSelector:selector];
    [invo setArgument:&p1 atIndex:2];
    [invo setArgument:&p2 atIndex:3];
    [invo setArgument:&p3 atIndex:4];
    [invo setArgument:&p4 atIndex:5];
    [invo setArgument:&p5 atIndex:6];
    [invo invoke];
    if (sig.methodReturnLength) {
      id anObject;
      [invo getReturnValue:&anObject];
      return anObject;
    } else {
      return nil;
    }
  } else {
    return nil;
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3
    withObject:(id)p4 withObject:(id)p5 withObject:(id)p6 {
  NSMethodSignature *sig = [self methodSignatureForSelector:selector];
  if (sig) {
    NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
    [invo setTarget:self];
    [invo setSelector:selector];
    [invo setArgument:&p1 atIndex:2];
    [invo setArgument:&p2 atIndex:3];
    [invo setArgument:&p3 atIndex:4];
    [invo setArgument:&p4 atIndex:5];
    [invo setArgument:&p5 atIndex:6];
    [invo setArgument:&p6 atIndex:7];
    [invo invoke];
    if (sig.methodReturnLength) {
      id anObject;
      [invo getReturnValue:&anObject];
      return anObject;
    } else {
      return nil;
    }
  } else {
    return nil;
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3
    withObject:(id)p4 withObject:(id)p5 withObject:(id)p6 withObject:(id)p7 {
  NSMethodSignature *sig = [self methodSignatureForSelector:selector];
  if (sig) {
    NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
    [invo setTarget:self];
    [invo setSelector:selector];
    [invo setArgument:&p1 atIndex:2];
    [invo setArgument:&p2 atIndex:3];
    [invo setArgument:&p3 atIndex:4];
    [invo setArgument:&p4 atIndex:5];
    [invo setArgument:&p5 atIndex:6];
    [invo setArgument:&p6 atIndex:7];
    [invo setArgument:&p7 atIndex:8];
    [invo invoke];
    if (sig.methodReturnLength) {
      id anObject;
      [invo getReturnValue:&anObject];
      return anObject;
    } else {
      return nil;
    }
  } else {
    return nil;
  }
}

#pragma mark === Thread ===

- (void)performSelectorInGCDThread:(SEL)aSelector withObject:(id)arg {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"4.0")) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                           [self performSelector:aSelector withObject:arg];
                       });
    }else {
        [self performSelectorInBackground:aSelector withObject:arg];
    } 
}


- (id)performSelectorInGCDMainThread:(SEL)selector withObject:(id)arg1 withObject:(id)arg2 {
    NSMethodSignature *sig = [self methodSignatureForSelector:selector];
    if (sig) {
        NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
        [invo setTarget:self];
        [invo setSelector:selector];
        [invo setArgument:&arg1 atIndex:2];
        [invo setArgument:&arg2 atIndex:3];
        [invo performSelectorInGCDMainThread:@selector(invoke) withObject:nil];
        if (sig.methodReturnLength) {
            id anObject;
            [invo getReturnValue:&anObject];
            return anObject;
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

- (void)performSelectorInGCDMainThread:(SEL)aSelector withObject:(id)arg {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"4.0")) {
        dispatch_async(dispatch_get_main_queue(), ^(void)
                       {
                           assert([NSThread isMainThread]);
                           [self performSelector:aSelector withObject:arg];
                       });
    }else {
        [self performSelectorOnMainThread:aSelector withObject:arg waitUntilDone:[NSThread isMainThread]];
    }
}

@end
