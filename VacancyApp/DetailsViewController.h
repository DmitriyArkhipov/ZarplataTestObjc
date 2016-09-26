//
//  DetailsViewController.h
//  VacancyApp
//
//  Created by Dmitriy Arkhipov on 26.09.16.
//  Copyright © 2016 Dmitriy Arkhipov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RestKitFacade.h"
#import "DetailViewUpdateDelegate.h"
#import "CustomDateFormatter.h"

@interface DetailsViewController : UIViewController <DetailViewUpdateDelegate>

@property (weak, nonatomic) IBOutlet UILabel *headerLebel;

@property (weak, nonatomic) IBOutlet UILabel *salaryLabel;

@property (weak, nonatomic) IBOutlet UILabel *addDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *experienceLengthLabel;

@property (weak, nonatomic) IBOutlet UILabel *companyTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *contactAddressLabel;

@property (weak, nonatomic) IBOutlet UILabel *vacancyDescription;

@property (strong, nonatomic) NSString *vacancyID;

- (void) didUpdateViewsWithResultSearchObject:(id)resultObject;

@end
