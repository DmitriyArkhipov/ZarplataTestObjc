//
//  SearchTableViewController.m
//  VacancyApp
//
//  Created by Dmitriy Arkhipov on 25.09.16.
//  Copyright © 2016 Dmitriy Arkhipov. All rights reserved.
//

#import "SearchTableViewController.h"
#import "SearchTableViewCell.h"
#import "RestKitFacade.h"

@interface SearchTableViewController ()


@property (strong, nonatomic) NSArray *testTableArray;



@end

@implementation SearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
//    self.tableViewForVacancy.rowHeight = UITableViewAutomaticDimension;
//    self.tableViewForVacancy.estimatedRowHeight = 300.0;
    
    NSManagedObjectContext *managedObjectContext = [[DefaultCoreDataStack sharedInstance] managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CDMVacancy"];
    
    @try {
        
        _testTableArray = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
        
        NSLog(@"====================== table view controller log ===============");
        
        for (CDMVacancy *vacancyItem in _testTableArray) {
        
            NSString *v_ID = vacancyItem.v_ID;
            
            NSString *header = vacancyItem.header;
            
            CDMContact *contact = vacancyItem.contact;
            
            NSString *contactAddress = contact.address;
            
            NSDate *addDate = vacancyItem.addDate;
            
            NSLog(@"ID %@",v_ID);
            NSLog(@"Headers: %@", header);
            NSLog(@"Headers address: %@", contactAddress);
            NSLog(@"data: %@", addDate.description);
        
        
        }

        
    } @catch (NSException *exception) {
        
        NSLog(@"CoreData exception: %@", exception.description);
        
    }

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
//    return 0;
    
    return [_testTableArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    
    CDMVacancy *vacancyItem = _testTableArray[indexPath.row];
    
    
    [cell.headerLabel setText:vacancyItem.header];
    
    NSString *date = [NSString stringWithFormat:@"%f",vacancyItem.addDate.timeIntervalSince1970];
    
    [cell.timeLabel setText:date];
    
    
    [cell.salaryLabel setText:vacancyItem.salary];
    
    [cell.companyLabel setText:vacancyItem.company.title];
    
    
    
    // Configure the cell...
    
    return cell;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
