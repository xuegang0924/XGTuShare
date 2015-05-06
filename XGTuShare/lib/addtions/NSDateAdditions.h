
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



#import <Foundation/Foundation.h>


struct QYDateInformation {
	long day;
	long month;
	long year;
	
	long weekday;
	
	long minute;
	long hour;
	long second;
	
};
typedef struct QYDateInformation QYDateInformation;

@interface NSDate (QYCategory)

+ (NSDate *) yesterday;
+ (NSDate *) month;

- (NSDate *) monthDate;
//- (NSDate *) lastOfMonthDate;



- (BOOL) isSameDay:(NSDate*)anotherDate;
- (int) monthsBetweenDate:(NSDate *)toDate;
- (NSInteger) daysBetweenDate:(NSDate*)d;
- (BOOL) isToday;


- (NSDate *) dateByAddingDays:(NSUInteger)days;
+ (NSDate *) dateWithDatePart:(NSDate *)aDate andTimePart:(NSDate *)aTime;

- (NSString *) monthString;
- (NSString *) yearString;


- (QYDateInformation) dateInformation;
- (QYDateInformation) dateInformationWithTimeZone:(NSTimeZone*)tz;
+ (NSDate*) dateFromDateInformation:(QYDateInformation)info;
+ (NSDate*) dateFromDateInformation:(QYDateInformation)info timeZone:(NSTimeZone*)tz;
+ (NSString*) dateInformationDescriptionWithInformation:(QYDateInformation)info;


@end
