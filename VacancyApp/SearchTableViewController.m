//
//  SearchTableViewController.m
//  VacancyApp
//
//  Created by Dmitriy Arkhipov on 25.09.16.
//  Copyright © 2016 Dmitriy Arkhipov. All rights reserved.
//

#import "SearchTableViewController.h"

@interface SearchTableViewController ()


//@property (strong, nonatomic) NSArray *testTableArray;

@property (strong, nonatomic) NSMutableArray *loadedData;
@property (strong, nonatomic) NSMutableArray *searchResults;

@property (strong, nonatomic) UISearchController *searchController;

@property (strong, nonatomic) UIRefreshControl *mRefreshControl;

@property (assign, nonatomic) BOOL isScrollRequestActive;

@property (strong, nonatomic) NSString *tempSearchItem;

@end

@implementation SearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isScrollRequestActive = YES;
    
    _loadedData = [[NSMutableArray alloc] init];
    _searchResults = [[NSMutableArray alloc] init];
    
    [RestKitFacade sharedInstance].updateTableDelegate = self;
    
    // Setup the Search Controller
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater = self;
    _searchController.searchBar.delegate = self;
    
    [_searchController.searchBar sizeToFit];
    
    // Add the UISearchBar to the top header of the table view
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.searchController.searchBar.placeholder = @"Введите должность";
    
    // Hides search bar initially.  When the user pulls down on the list, the search bar is revealed.
    [self.tableView setContentOffset:CGPointMake(0, self.searchController.searchBar.frame.size.height)];
    
    self.definesPresentationContext = YES;
    
    
    _searchController.dimsBackgroundDuringPresentation = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
//
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 300.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    unsigned long count = 0;
    
    if (_searchController.active && ![_searchController.searchBar.text isEqualToString:@""]){
    
                count = [_searchResults count];
        
                return count > 0 ? count : 1;
    }
    
    
    count = [_loadedData count];
    
    return count > 0 ? count : 1;
   
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    
    CDMVacancy *vacancyItem;
    
    if (_searchController.active && ![_searchController.searchBar.text isEqualToString:@""]) {
    
        unsigned long searchCount = [_searchResults count];
        
        if (searchCount == 0) {
            
            ActivityTableViewCell *activityCell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCell" forIndexPath:indexPath];
            
            [activityCell.loadingActivityIndicator startAnimating];
            
            return activityCell;
            
        }
    
        vacancyItem = _searchResults[indexPath.row];
        
    } else {
        
        unsigned long loadedCount = [_loadedData count];
        
        if (loadedCount == 0) {
            
            ActivityTableViewCell *activityCell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCell" forIndexPath:indexPath];
            
            [activityCell.loadingActivityIndicator startAnimating];
            
            return activityCell;
            
        }
    
        vacancyItem = _loadedData[indexPath.row];
    
    }
    
    
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    
    [cell.headerLabel setText:vacancyItem.header];
    
    [cell.timeLabel setText:[CustomDateFormatter relativeDateStringForDate:vacancyItem.addDate]];
    
    
    [cell.salaryLabel setText:vacancyItem.salary];
    
    [cell.companyLabel setText:vacancyItem.company.title];
    
    
    
    // Configure the cell...
    
    return cell;
}

// infinity scrolling

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat actualPosition = scrollView.contentOffset.y;
    CGFloat contentHeight = scrollView.contentSize.height - _tableViewForVacancy.frame.size.height;
    if (actualPosition >= contentHeight) {
        
        if (!_isScrollRequestActive) {
            _isScrollRequestActive = YES;
            
            if (_searchController.active && ![_searchController.searchBar.text isEqualToString:@""]) {
                
                [[RestKitFacade sharedInstance] searchRequestWithString:_searchController.searchBar.text];
                
            } else {
            
                [[RestKitFacade sharedInstance] requestAPIData];
            }
            
        }
        
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"toDetailSegueID"]) {
        
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];;
        CDMVacancy *vacancyItem;
        
        if (_searchController.active && ![_searchController.searchBar.text isEqualToString:@""]) {
            
            vacancyItem =_searchResults[indexPath.row];
            
        } else {
            
            vacancyItem =_loadedData[indexPath.row];
        }
    
        DetailsViewController *destinationViewController = segue.destinationViewController;
        
        destinationViewController.vacancyID = vacancyItem.v_ID;
    
    }
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.navigationController.navigationBar.topItem.backBarButtonItem = backButton;
 
}



#pragma mark - TableViewUpdateDelegate support

- (void) didUpdateLoadedDataWithResultArray:(NSArray *)resultArray {
    
    _isScrollRequestActive = NO;
    
    [_loadedData addObjectsFromArray:resultArray];
    
    [self.tableViewForVacancy reloadData];
    
}

- (void) didUpdateSearchedDataWithResultArray:(NSArray *)resultArray {
    
    _isScrollRequestActive = NO;
    
    [_searchResults addObjectsFromArray:resultArray];
    
    [self.tableViewForVacancy reloadData];
}


#pragma mark - UISearch support

// When the user types in the search bar, this method gets called.
- (void)updateSearchResultsForSearchController:(UISearchController *)aSearchController {
    
    NSString *searchString = aSearchController.searchBar.text;
    
    if ([searchString isEqualToString:_tempSearchItem]) {
        return;
    }
    
    // Check if the user cancelled or deleted the search term so we can display the full list instead.
    if (![searchString isEqualToString:@""]) {
        
        
            
            _isScrollRequestActive = YES;
            
            _tempSearchItem = searchString;
            
            [_searchResults removeAllObjects];
            
            [[RestKitFacade sharedInstance] searchRequestWithString:searchString];
            
        
        
    }
    
    [self.tableView reloadData];
}







@end
