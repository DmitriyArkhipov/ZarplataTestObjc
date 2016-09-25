//
//  CDMVacancy.h
//  VacancyApp
//
//  Created by Dmitriy Arkhipov on 25.09.16.
//  Copyright © 2016 Dmitriy Arkhipov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDMCompany, CDMContact, CDMCurrency, CDMExperienceLength, CDMWorkingType;

NS_ASSUME_NONNULL_BEGIN

@interface CDMVacancy : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "CDMVacancy+CoreDataProperties.h"
