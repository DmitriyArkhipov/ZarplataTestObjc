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

@interface RestKitFacade : NSObject

+ (instancetype) sharedInstance;

- (void) configure;

- (NSManagedObjectContext *)managedObjectContext;

- (void) requestAPIData;

@end
