//
//  DetailsViewController.m
//  VacancyApp
//
//  Created by Dmitriy Arkhipov on 26.09.16.
//  Copyright © 2016 Dmitriy Arkhipov. All rights reserved.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [RestKitFacade sharedInstance].updateSelectedDetailDelegate = self;
    
    [[RestKitFacade sharedInstance] getVacancyInLocalDBWithID:_vacancyID];
    //    [[RestKitFacade sharedInstance] searchRequestWithVacancyID:_vacancyID]
    
    NSLog(@"selected vacancyID = %@", _vacancyID);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - DetailViewUpdateDelegate support

- (void) didUpdateViewsWithResultSearchObject:(id)resultObject {

    CDMVacancy *vacancy = resultObject;
    
    [_headerLebel setText:vacancy.header];
    
    [_salaryLabel setText:vacancy.salary];
    
    [_addDateLabel setText:[CustomDateFormatter relativeDateStringForDate:vacancy.addDate]];
    
    [_experienceLengthLabel setText:vacancy.experienceLength.title];
    
    [_companyTitleLabel setText:vacancy.company.title];
    
    [_contactAddressLabel setText:vacancy.contact.address];
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData: [vacancy.vacancyDescription dataUsingEncoding:NSUnicodeStringEncoding]
                                                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                                 documentAttributes: nil
                                                                              error: nil
    ];
    
    [_vacancyDescription setAttributedText:attributedString];

}


/*

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
