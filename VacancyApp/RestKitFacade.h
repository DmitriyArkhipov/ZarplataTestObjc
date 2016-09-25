//
//  RestKitFacade.h
//  VacancyApp
//
//  Created by Dmitriy Arkhipov on 23.09.16.
//  Copyright © 2016 Dmitriy Arkhipov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/CoreData.h>
#import <RestKit/RestKit.h>

#import "Constants.h"
#import "CoreDataModel.h"

#import "DefaultCoreDataStack.h"

#import "TableViewUpdateDelegate.h"

@interface RestKitFacade : NSObject


@property (weak, nonatomic) id<TableViewUpdateDelegate> updateTableDelegate;


+ (instancetype) sharedInstance;

- (void) configure;

- (NSManagedObjectContext *)managedObjectContext;

/**
 Получение данных от API с параметрами по умолчанию (offset = 25, limit = 25)
 */
- (void) requestAPIData;


- (void) searchRequestWithString:(NSString *)searchItem;

/**
 Поиск объекта вакансии по ID в локальной базе данных
 @param ID Идентификатор вакансии.
 */
- (NSManagedObject *) getVacancyInLocalDBWithID:(NSString *)ID;

/**
 Поиск объекта вакансии по ID запросив данные с API
 @param ID Идентификатор вакансии. При перечислении идентификаторов через запятую будут выданы вакансии в соответствии с идентификаторами
 */
- (void) searchRequestWithVacancyID:(NSString *)ID;

@end
