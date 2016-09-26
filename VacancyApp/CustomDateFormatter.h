//
//  CustomDateFormatter.h
//  VacancyApp
//
//  Created by Dmitriy Arkhipov on 26.09.16.
//  Copyright © 2016 Dmitriy Arkhipov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomDateFormatter : NSObject

+ (NSString *)relativeDateStringForDate:(NSDate *)date;

@end
