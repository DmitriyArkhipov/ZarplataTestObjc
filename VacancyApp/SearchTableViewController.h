//
//  SearchTableViewController.h
//  VacancyApp
//
//  Created by Dmitriy Arkhipov on 25.09.16.
//  Copyright © 2016 Dmitriy Arkhipov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RestKitFacade.h"

#import "TableViewUpdateDelegate.h"
#import "SearchTableViewCell.h"
#import "ActivityTableViewCell.h"

@interface SearchTableViewController : UITableViewController <TableViewUpdateDelegate, UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating>


@property (strong, nonatomic) IBOutlet UITableView *tableViewForVacancy;

- (void) didUpdateLoadedDataWithResultArray:(NSArray *)resultArray;

- (void) didUpdateSearchedDataWithResultArray:(NSArray *)resultArray;

@end
