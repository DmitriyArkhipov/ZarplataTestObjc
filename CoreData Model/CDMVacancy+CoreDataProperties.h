//
//  CDMVacancy+CoreDataProperties.h
//  VacancyApp
//
//  Created by Dmitriy Arkhipov on 25.09.16.
//  Copyright © 2016 Dmitriy Arkhipov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDMVacancy.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDMVacancy (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *addDate;
@property (nullable, nonatomic, retain) NSString *header;
@property (nullable, nonatomic, retain) NSNumber *innerID;
@property (nullable, nonatomic, retain) NSString *salary;
@property (nullable, nonatomic, retain) NSString *v_ID;
@property (nullable, nonatomic, retain) NSString *vacancyDescription;
@property (nullable, nonatomic, retain) CDMCompany *company;
@property (nullable, nonatomic, retain) CDMContact *contact;
@property (nullable, nonatomic, retain) CDMCurrency *currency;
@property (nullable, nonatomic, retain) CDMExperienceLength *experienceLength;
@property (nullable, nonatomic, retain) CDMWorkingType *workingType;

@end

NS_ASSUME_NONNULL_END
