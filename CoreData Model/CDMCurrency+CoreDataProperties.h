//
//  CDMCurrency+CoreDataProperties.h
//  VacancyApp
//
//  Created by Dmitriy Arkhipov on 24.09.16.
//  Copyright © 2016 Dmitriy Arkhipov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDMCurrency.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDMCurrency (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *curr_ID;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *alias;
@property (nullable, nonatomic, retain) NSSet<CDMVacancy *> *vacancy;

@end

@interface CDMCurrency (CoreDataGeneratedAccessors)

- (void)addVacancyObject:(CDMVacancy *)value;
- (void)removeVacancyObject:(CDMVacancy *)value;
- (void)addVacancy:(NSSet<CDMVacancy *> *)values;
- (void)removeVacancy:(NSSet<CDMVacancy *> *)values;

@end

NS_ASSUME_NONNULL_END
