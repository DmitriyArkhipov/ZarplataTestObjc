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

@interface RestKitFacade : NSObject

+ (instancetype) sharedInstance;

- (void) configure;

- (NSManagedObjectContext *)managedObjectContext;

- (void) requestAPIData;

- (void) searchRequestWithString:(NSString *)searchItem;

- (NSManagedObject *) getVacancyInLocalDBWithID:(NSString *)ID;

- (void) searchRequestWithVacancyID:(NSString *)ID;

@end
