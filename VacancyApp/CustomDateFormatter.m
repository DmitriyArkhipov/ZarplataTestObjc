//
//  CustomDateFormatter.m
//  VacancyApp
//
//  Created by Dmitriy Arkhipov on 26.09.16.
//  Copyright © 2016 Dmitriy Arkhipov. All rights reserved.
//

#import "CustomDateFormatter.h"

@implementation CustomDateFormatter

+ (NSString *)relativeDateStringForDate:(NSDate *)date
{
    
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc] init];
    [dataFormatter setDateFormat:@"dd.MM.yyyy"];
    
    
    
    NSCalendarUnit units = NSCalendarUnitDay | NSCalendarUnitWeekOfYear |
    NSCalendarUnitMonth | NSCalendarUnitYear;
    
    // if `date` is before "now" (i.e. in the past) then the components will be positive
    NSDateComponents *components = [[NSCalendar currentCalendar] components:units
                                                                   fromDate:date
                                                                     toDate:[NSDate date]
                                                                    options:0];
    
    if (components.year > 0) {
        
//        return [NSString stringWithFormat:@"%ld лет назад", (long)components.year];
        return [dataFormatter stringFromDate:date];
        
    } else if (components.month > 0) {
        
//        return [NSString stringWithFormat:@"%ld месяцев назад", (long)components.month];
        return [dataFormatter stringFromDate:date];
        
    } else if (components.weekOfYear > 0) {
        
//        return [NSString stringWithFormat:@"%ld недель назад", (long)components.weekOfYear];
        return [dataFormatter stringFromDate:date];
        
    } else if (components.day > 0) {
        
        if (components.day > 4) {
            return [NSString stringWithFormat:@"%ld дней назад", (long)components.day];
        } else if (components.day > 1) {
            
            return [NSString stringWithFormat:@"%ld дня назад", (long)components.day];
        
        } else {
            return @"вчера";
        }
    } else if (components.hour > 0) {
        
        
        if (components.hour == 21) {
            return @"%21 час назад";
        } else if (components.hour > 21) {
            return [NSString stringWithFormat:@"%ld часа назад", (long)components.hour];
        } else if (components.hour > 4) {
            return [NSString stringWithFormat:@"%ld часов назад", (long)components.hour];
        } else if (components.hour > 1)  {
            return [NSString stringWithFormat:@"%ld часа назад", (long)components.hour];
        }
        return @"час назад";
    
    } else {
    
        return @"только что";
    
    }
    
    
    
}


@end
