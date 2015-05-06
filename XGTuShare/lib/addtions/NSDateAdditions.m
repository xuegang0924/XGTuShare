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

#import "NSDateAdditions.h"


@implementation NSDate (QYCategory)

+ (NSDate*) yesterday{
	QYDateInformation inf = [[NSDate date] dateInformation];
	inf.day--;
	return [NSDate dateFromDateInformation:inf];
}
+ (NSDate*) month{
    return [[NSDate date] monthDate];
}

- (NSDate*) monthDate {
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:self];
	[comp setDay:1];
	NSDate *date = [gregorian dateFromComponents:comp];
    [gregorian release];
    return date;
}


- (int) weekday{
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comps = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSWeekdayCalendarUnit) fromDate:self];
    [gregorian release];
	int weekday = (int)[comps weekday];
	return weekday;
}
- (NSDate*) timelessDate {
	NSDate *day = self;
	NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
	NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:day];
	return [gregorian dateFromComponents:comp];
}
- (NSDate*) monthlessDate {
	NSDate *day = self;
	NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
	NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:day];
	return [gregorian dateFromComponents:comp];
}



- (BOOL) isSameDay:(NSDate*)anotherDate{
	NSCalendar* calendar = [NSCalendar currentCalendar];
	NSDateComponents* components1 = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self];
	NSDateComponents* components2 = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:anotherDate];
	return ([components1 year] == [components2 year] && [components1 month] == [components2 month] && [components1 day] == [components2 day]);
} 

- (int) monthsBetweenDate:(NSDate *)toDate{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *components = [gregorian components:NSMonthCalendarUnit
                                                fromDate:[self monthlessDate]
                                                  toDate:[toDate monthlessDate]
                                                 options:0];
    [gregorian release];
    int months = (int)[components month];
    return abs(months);
}
- (NSInteger) daysBetweenDate:(NSDate*)d{
	
	NSTimeInterval time = [self timeIntervalSinceDate:d];
	return abs(time / 60 / 60/ 24);
	
}
- (BOOL) isToday{
	return [self isSameDay:[NSDate date]];
} 



- (NSDate *) dateByAddingDays:(NSUInteger)days {
	NSDateComponents *c = [[[NSDateComponents alloc] init] autorelease];
	c.day = days;
	return [[NSCalendar currentCalendar] dateByAddingComponents:c toDate:self options:0];
}

+ (NSDate *) dateWithDatePart:(NSDate *)aDate andTimePart:(NSDate *)aTime {
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"dd/MM/yyyy"];
	NSString *datePortion = [dateFormatter stringFromDate:aDate];
	
	[dateFormatter setDateFormat:@"HH:mm"];
	NSString *timePortion = [dateFormatter stringFromDate:aTime];
	
	[dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm"];
	NSString *dateTime = [NSString stringWithFormat:@"%@ %@",datePortion,timePortion];
	return [dateFormatter dateFromString:dateTime];
}

- (NSString*) monthString{
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];	
	[dateFormatter setDateFormat:@"MMMM"];
	return [dateFormatter stringFromDate:self];
}

- (NSString*) yearString{
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];	
	[dateFormatter setDateFormat:@"yyyy"];
	return [dateFormatter stringFromDate:self];
}



- (QYDateInformation) dateInformationWithTimeZone:(NSTimeZone*)tz{
	QYDateInformation info;
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	[gregorian setTimeZone:tz];
	NSDateComponents *comp = [gregorian components:(NSMonthCalendarUnit | NSMinuteCalendarUnit | NSYearCalendarUnit | 
													NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSSecondCalendarUnit) 
										  fromDate:self];
    [gregorian autorelease];
	info.day = [comp day];
	info.month = [comp month];
	info.year = [comp year];
	
	info.hour = [comp hour];
	info.minute = [comp minute];
	info.second = [comp second];
	
	info.weekday = [comp weekday];
	
	return info;
	
}
- (QYDateInformation) dateInformation{
	
	QYDateInformation info;
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comp = [gregorian components:(NSMonthCalendarUnit | NSMinuteCalendarUnit | NSYearCalendarUnit | 
													NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSSecondCalendarUnit) 
										  fromDate:self];
    [gregorian release];
	info.day = [comp day];
	info.month = [comp month];
	info.year = [comp year];
	
	info.hour = [comp hour];
	info.minute = [comp minute];
	info.second = [comp second];
	
	info.weekday = [comp weekday];
	
    
	return info;
}

+ (NSDate*) dateFromDateInformation:(QYDateInformation)info timeZone:(NSTimeZone*)tz{
	
	NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
	[gregorian setTimeZone:tz];
	NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:[NSDate date]];
	
	[comp setDay:info.day];
	[comp setMonth:info.month];
	[comp setYear:info.year];
	[comp setHour:info.hour];
	[comp setMinute:info.minute];
	[comp setSecond:info.second];
	[comp setTimeZone:tz];
	
	return [gregorian dateFromComponents:comp];
}

+ (NSDate*) dateFromDateInformation:(QYDateInformation)info{
	
	NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
	NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:[NSDate date]];
	
	[comp setDay:info.day];
	[comp setMonth:info.month];
	[comp setYear:info.year];
	[comp setHour:info.hour];
	[comp setMinute:info.minute];
	[comp setSecond:info.second];
	//[comp setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	
	return [gregorian dateFromComponents:comp];
}

+ (NSString*) dateInformationDescriptionWithInformation:(QYDateInformation)info{
	return [NSString stringWithFormat:@"%ld %ld %ld %ld:%ld:%ld",info.month,info.day,info.year,info.hour,info.minute,info.second];
}

@end
