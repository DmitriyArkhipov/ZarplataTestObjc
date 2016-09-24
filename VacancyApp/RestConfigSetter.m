//
//  RestConfigSetter.m
//  VacancyApp
//
//  Created by Dmitriy Arkhipov on 22.09.16.
//  Copyright © 2016 Dmitriy Arkhipov. All rights reserved.
//

#import "RestConfigSetter.h"


@interface RestConfigSetter ()

@property (strong, nonatomic) NSArray *vacancyArray;

@end


@implementation RestConfigSetter


- (void) setConfigRestKit {
    
    // initialize AFNetworking HTTPClient
    NSURL *baseURL = [NSURL URLWithString:API_URL];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    
    // initialize RestKit
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    
    // setup object mappings
    RKObjectMapping *vacancy = [RKObjectMapping mappingForClass:[Vacancy class]];
    
    //addAttributeMappingsFromDictionary: @{  @"JSON" : @"Object property", ...  }
    [vacancy addAttributeMappingsFromDictionary:@{
                                                  @"id":@"ID",
                                                  @"add_date":@"addDate",
                                                  @"header":@"header",
                                                  @"salary":@"salary",
                                                  @"description":@"vacancyDescription"
                                                  }];
    
    
    //define objects mapping in vacancy
    RKObjectMapping *currency = [RKObjectMapping mappingForClass:[Currency class]];

    [currency addAttributeMappingsFromDictionary:@{
                                                   @"id":@"ID",
                                                   @"title":@"title",
                                                   @"alias":@"alias"
                                                   }];

    
    
    RKObjectMapping *experienceLength = [RKObjectMapping mappingForClass:[ExperienceLength class]];
    
    [experienceLength addAttributeMappingsFromDictionary:@{
                                                           @"id":@"ID",
                                                           @"title":@"title"
                                                           }];
    
    
    RKObjectMapping *workingType = [RKObjectMapping mappingForClass:[WorkingType class]];
    
    [workingType addAttributeMappingsFromDictionary:@{
                                                      @"id":@"ID",
                                                      @"title":@"title"
                                                      }];
    
    
    RKObjectMapping *company = [RKObjectMapping mappingForClass:[Company class]];
    
    [company addAttributeMappingsFromDictionary:@{
                                                  @"id":@"ID",
                                                  @"title":@"title"
                                                  }];
    
    
    RKObjectMapping *contact = [RKObjectMapping mappingForClass:[Contact class]];
    
    [contact addAttributeMappingsFromDictionary:@{
                                                  @"address":@"address"
                                                  }];
    
    
    // define relationship mapping
    
    // relationshipMappingFromKeyPath: @"JSON" toKeyPath:@"ObjectName"
    RKRelationshipMapping *currencyRM = [RKRelationshipMapping relationshipMappingFromKeyPath:@"currency" toKeyPath:@"Currency" withMapping:currency];
    RKRelationshipMapping *experienceLengthRM = [RKRelationshipMapping relationshipMappingFromKeyPath:@"experience_length" toKeyPath:@"ExperienceLength" withMapping:experienceLength];
    RKRelationshipMapping *workingTypeRM = [RKRelationshipMapping relationshipMappingFromKeyPath:@"working_type" toKeyPath:@"WorkingType" withMapping:workingType];
    RKRelationshipMapping *companyRM = [RKRelationshipMapping relationshipMappingFromKeyPath:@"company" toKeyPath:@"Company" withMapping:company];
    RKRelationshipMapping *contactRM = [RKRelationshipMapping relationshipMappingFromKeyPath:@"contact" toKeyPath:@"Contact" withMapping:contact];

    
    [vacancy addPropertyMapping:currencyRM];
    [vacancy addPropertyMapping:experienceLengthRM];
    [vacancy addPropertyMapping:workingTypeRM];
    [vacancy addPropertyMapping:companyRM];
    [vacancy addPropertyMapping:contactRM];
    
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:vacancy
                                                                                            method:RKRequestMethodGET
                                                                                       pathPattern:API_PATH_PATTERN
                                                                                           keyPath:@"vacancies"
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    
    
    [objectManager addResponseDescriptor:responseDescriptor];



}


- (void) loadAPIData {
    
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    
    NSDictionary *queryParams = @{
                                  @"offset" : @(25), //Начальный сдвиг возвращаемых результато
                                  @"limit" : @(100)
                                  };
    
    
    
    [[RKObjectManager sharedManager] getObjectsAtPath:API_PATH_PATTERN parameters:queryParams success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        _vacancyArray = mappingResult.array;
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"What do you mean by 'there is no zarplata?': %@", error.description);
    }];
}


- (void) searchRequesWithString:(NSString *)searchItem {
    
    
    
    NSString *searchPath = [NSString stringWithFormat:@"%@%@%@", API_PATH_PATTERN, API_SEARCH_KEY,searchItem];
    
    
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    
    NSDictionary *queryParams = @{
                                  @"offset" : @(25), //Начальный сдвиг возвращаемых результатов
                                  @"limit" : @(25)
                                  };
    
    
    
    [[RKObjectManager sharedManager] getObjectsAtPath:searchPath parameters:queryParams success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        NSLog(@"================== requestAPIData getObjectsAtPath ==================");
        
        _vacancyArray = mappingResult.array;
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"What do you mean by 'there is no zarplata?': %@", error.description);
    }];
}


- (void) searchRequestWithVacancyID:(NSString *)ID {
    
    NSString *searchPath = [NSString stringWithFormat:@"%@%@", API_PATH_PATTERN, ID];
    
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    
    //
    //    NSDictionary *queryParams = @{
    //                                  @"offset" : @(25), //Начальный сдвиг возвращаемых результатов
    //                                  @"limit" : @(25)
    //                                  };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:searchPath parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
                id resultObject = [mappingResult.array firstObject];
        
                //-------- test block
        
                Vacancy *vacancy = resultObject;
        
                NSString *v_ID = vacancy.ID;
        
                NSString *header = vacancy.header;
        
                Contact *contact = vacancy.contact;
        
                NSString *contactAddress = contact.address;
        
        
                NSDate *addDate = vacancy.addDate;
        
                NSLog(@"ID %@",v_ID);
                NSLog(@"Headers: %@", header);
                NSLog(@"Headers address: %@", contactAddress);
                NSLog(@"data: %@", addDate.description);
        
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"What do you mean by 'there is no zarplata?': %@", error.description);
    }];
    
    
    
    
    
}



@end
