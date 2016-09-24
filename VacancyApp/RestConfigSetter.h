//
//  RestConfigSetter.h
//  VacancyApp
//
//  Created by Dmitriy Arkhipov on 22.09.16.
//  Copyright © 2016 Dmitriy Arkhipov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

#import "Vacancy.h"
#import "Constants.h"

@interface RestConfigSetter : NSObject

- (void) setConfigRestKit;

- (void) loadAPIData;

- (void) searchRequesWithString:(NSString *)searchItem;

@end
