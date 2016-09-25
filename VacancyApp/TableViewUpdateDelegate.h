//
//  TableViewUpdateDelegate.h
//  VacancyApp
//
//  Created by Dmitriy Arkhipov on 26.09.16.
//  Copyright © 2016 Dmitriy Arkhipov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TableViewUpdateDelegate <NSObject>

- (void) didUpdateLoadedDataWithResultArray:(NSArray *)resultArray;

- (void) didUpdateSearchedDataWithResultArray:(NSArray *)resultArray;

@end
