//
//  CDMContact+CoreDataProperties.h
//  VacancyApp
//
//  Created by Dmitriy Arkhipov on 24.09.16.
//  Copyright © 2016 Dmitriy Arkhipov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDMContact.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDMContact (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *cont_ID;
@property (nullable, nonatomic, retain) NSString *address;
@property (nullable, nonatomic, retain) NSSet<CDMVacancy *> *vacancy;

@end

@interface CDMContact (CoreDataGeneratedAccessors)

- (void)addVacancyObject:(CDMVacancy *)value;
- (void)removeVacancyObject:(CDMVacancy *)value;
- (void)addVacancy:(NSSet<CDMVacancy *> *)values;
- (void)removeVacancy:(NSSet<CDMVacancy *> *)values;

@end

NS_ASSUME_NONNULL_END
