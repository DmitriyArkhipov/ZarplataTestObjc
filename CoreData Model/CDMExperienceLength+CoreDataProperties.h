//
//  CDMExperienceLength+CoreDataProperties.h
//  VacancyApp
//
//  Created by Dmitriy Arkhipov on 24.09.16.
//  Copyright © 2016 Dmitriy Arkhipov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDMExperienceLength.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDMExperienceLength (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *eL_ID;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSSet<CDMVacancy *> *vacancy;

@end

@interface CDMExperienceLength (CoreDataGeneratedAccessors)

- (void)addVacancyObject:(CDMVacancy *)value;
- (void)removeVacancyObject:(CDMVacancy *)value;
- (void)addVacancy:(NSSet<CDMVacancy *> *)values;
- (void)removeVacancy:(NSSet<CDMVacancy *> *)values;

@end

NS_ASSUME_NONNULL_END
