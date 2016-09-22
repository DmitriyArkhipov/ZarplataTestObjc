//
//  Vacancy.h
//  VacancyApp
//
//  Created by Dmitriy Arkhipov on 22.09.16.
//  Copyright © 2016 Dmitriy Arkhipov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Currency.h"
#import "WorkingType.h"
#import "ExperienceLength.h"
#import "Company.h"
#import "Contact.h"

@interface Vacancy : NSObject

/**
 API Vacancy id
 */
@property (strong, nonatomic) NSString *ID;


/**
 Дата добавления.
 */
@property (strong, nonatomic) NSDate *addDate;

/**
 Наименование вакансии.
 */
@property (strong, nonatomic) NSString *header;


/**
 Минимальная зарплата для вакансий, в которых указан диапазон.
 */
@property (strong, nonatomic) NSNumber *salary;


/**
 Валюта в которой представлена зарплата для вакансии.
 */
@property (strong, nonatomic) Currency *currency;


/**
 Опыт. Примеры значений: без опыта, 1-3 года, 3-5 лет.
 */
@property (strong, nonatomic) ExperienceLength *experienceLength;


/**
 Тип занятости. Примеры значений: частичная занятость, полная занятость.
 */
@property (strong, nonatomic) WorkingType *workingType;

/**
 Наименование компании, представляющей вакансию.
 */
@property (strong, nonatomic) Company *company;


/**
 Контакты компании предоставляющей вакансии.
 */
@property (strong, nonatomic) Contact *contact;


@property (strong, nonatomic) NSString *vacancyDescription;


@end
