//
//  RestKitFacade.m
//  VacancyApp
//
//  Created by Dmitriy Arkhipov on 23.09.16.
//  Copyright © 2016 Dmitriy Arkhipov. All rights reserved.
//

#import "RestKitFacade.h"


@interface RestKitFacade ()

@property (strong, nonatomic) RKObjectManager *objectManager;
@property (strong, nonatomic) RKManagedObjectStore *managedObjectStore;
@property (strong, nonatomic) NSArray *requestObjectsTempArray;

@end



@implementation RestKitFacade

+ (instancetype) sharedInstance {
    
    static RestKitFacade *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[RestKitFacade alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
    
}

- (instancetype)init
{
    if (self = [super init]) {
        // Do any other initialisation stuff here
        
        [self configure];
        
    }
    
    return self;
}


- (NSManagedObjectContext *)managedObjectContext
{
    return _managedObjectStore.mainQueueManagedObjectContext;
}

#pragma mark - Default CoreData Search

- (NSManagedObject *) getVacancyInLocalDBWithID:(NSString *)ID {
    
    NSManagedObjectContext *managedObjectContext = [[DefaultCoreDataStack sharedInstance] managedObjectContext];
    
    if (!managedObjectContext) {
        return nil;
    }
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CDMVacancy"];
    
    @try {
        
        NSArray *results = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
        
        for (CDMVacancy *item in results) {
            
            if ([ID isEqualToString:item.v_ID]) {
                
                NSLog(@"getObjectWithID id = %@", item.v_ID);
                NSLog(@"getObjectWithID header = %@", item.header);
                
                return item;
            }
        }
        
    } @catch (NSException *exception) {
        
        NSLog(@"CoreData exception: %@", exception.description);
        
    }
}


#pragma mark - RestKit Requests

- (void) searchRequestWithVacancyID:(NSString *)ID {
    
    RKResponseDescriptor *currentDescriptor = [self createResponseDescriptorWithID:ID];
    
    NSString *searchPath = [NSString stringWithFormat:@"%@%@", API_PATH_PATTERN, ID];
    
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    
    [[RKObjectManager sharedManager] getObjectsAtPath:searchPath parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        id resultObject = [mappingResult.array firstObject];
        
        //-------- test block
        
        CDMVacancy *vacancy = resultObject;
            
        NSString *v_ID = vacancy.v_ID;
        
        NSString *header = vacancy.header;
        
        CDMContact *contact = vacancy.contact;
        
        NSString *contactAddress = contact.address;
        
        
        NSDate *addDate = vacancy.addDate;
        
        NSLog(@"ID %@",v_ID);
        NSLog(@"Headers: %@", header);
        NSLog(@"Headers address: %@", contactAddress);
        NSLog(@"data: %@", addDate.description);
        
        //----------
        
        [_objectManager removeResponseDescriptor:currentDescriptor];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"What do you mean by 'there is no zarplata?': %@", error.description);
    }];
}


- (void) searchRequestWithString:(NSString *)searchItem {
    
    NSString *searchPath = [NSString stringWithFormat:@"%@%@%@", API_PATH_PATTERN, API_SEARCH_KEY,searchItem];

    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    
    NSDictionary *queryParams = @{
                                  @"offset" : @(25), //Начальный сдвиг возвращаемых результатов
                                  @"limit" : @(25)
                                  };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:searchPath parameters:queryParams success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        _requestObjectsTempArray = mappingResult.array;
        
        
        //-------- test block
        
        
        for (CDMVacancy *vacancyItem in _requestObjectsTempArray) {
            
            
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
        
        //--------
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"What do you mean by 'there is no zarplata?': %@", error.description);
    }];
    
}



- (void) requestAPIData {

    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    
    NSDictionary *queryParams = @{
                                  @"offset" : @(25), //Начальный сдвиг возвращаемых результатов
                                  @"limit" : @(25)
                                  };
    
    
    
    [[RKObjectManager sharedManager] getObjectsAtPath:API_PATH_PATTERN parameters:queryParams success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        NSLog(@"================== requestAPIData getObjectsAtPath ==================");
        
        NSArray *results = mappingResult.array;
        
        for (CDMVacancy *item in results) {
                
                NSLog(@"getObjectWithID id = %@", item.v_ID);
                NSLog(@"getObjectWithID header = %@", item.header);
        }
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"What do you mean by 'there is no zarplata?': %@", error.description);
    }];

}


#pragma mark - RestKit Config

- (void) configure {
    
    // initialize AFNetworking HTTPClient
    NSURL *baseURL = [NSURL URLWithString:API_URL];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    _objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];

    
    // Configure CoreData managed object model.
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"VacancyAppModel" withExtension:@"momd"];
    
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    // Initialize managed object store
    _managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    _objectManager.managedObjectStore = _managedObjectStore;
    
    [self prepareCoreDataStackWithManagedObjectModel:managedObjectModel];
    
    [self createDefaultResponseDescriptor];
}


- (RKEntityMapping *) addMappingForEntityForName:(NSString *)entityName
                 attributeMappingsFromDictionary:(NSDictionary *)attributeMappings
                        identificationAttributes:(NSArray *)ids
{
    if (!_managedObjectStore)
        return nil;
    
    // Create mapping for the particular entity.
    RKEntityMapping *objectMapping = [RKEntityMapping mappingForEntityForName:entityName
                                                         inManagedObjectStore:_managedObjectStore];
    [objectMapping addAttributeMappingsFromDictionary:attributeMappings];
    objectMapping.identificationAttributes = ids;
    
    return objectMapping;
}



- (void) prepareCoreDataStackWithManagedObjectModel:(NSManagedObjectModel *)managedObjectModel
{
    NSAssert(managedObjectModel, @"managedObjectModel can't be nil");
    
    // Initialize managed object store
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    _objectManager.managedObjectStore = managedObjectStore;
    
    
    // Complete Core Data stack initialization
    [managedObjectStore createPersistentStoreCoordinator];
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"VacancyAppDB.sqlite"];
    NSError *error;
    NSPersistentStore *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:nil withConfiguration:nil options:nil error:&error];
    NSAssert(persistentStore, @"Failed to add persistent store with error: %@", error);
    
    // Create the managed object contexts
    [managedObjectStore createManagedObjectContexts];
    
    // Configure a managed object cache to ensure we do not create duplicate objects
    managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:managedObjectStore.persistentStoreManagedObjectContext];
    
}


- (RKEntityMapping *) mappingForEntities {

    if (!_objectManager) {
        return nil;
    }
    
    //addAttributeMappingsFromDictionary: @{  @"JSON" : @"Object property", ...  }
    
    
    RKEntityMapping *vacancy = [self addMappingForEntityForName:@"CDMVacancy"
                                attributeMappingsFromDictionary:@{
                                                                  @"id":@"v_ID",
                                                                  @"add_date":@"addDate",
                                                                  @"header":@"header",
                                                                  @"salary":@"salary",
                                                                  @"description":@"vacancyDescription"
                                                                  }
                                       identificationAttributes:@[@"v_ID"]
                                ];
    
    
    
    RKEntityMapping *currency = [self addMappingForEntityForName:@"CDMCurrency"
                                 attributeMappingsFromDictionary:@{
                                                                   @"id":@"curr_ID",
                                                                   @"title":@"title",
                                                                   @"alias":@"alias"
                                                                   }
                                        identificationAttributes:@[@"curr_ID"]
                                 ];
    
    
    RKEntityMapping *experienceLength = [self addMappingForEntityForName:@"CDMExperienceLength"
                                         attributeMappingsFromDictionary:@{
                                                                           @"id":@"eL_ID",
                                                                           @"title":@"title"
                                                                           }
                                                identificationAttributes:@[@"eL_ID"]
                                         ];
    
    
    
    RKEntityMapping *workingType = [self addMappingForEntityForName:@"CDMWorkingType"
                                    attributeMappingsFromDictionary:@{
                                                                      @"id":@"wT_ID",
                                                                      @"title":@"title"
                                                                      }
                                           identificationAttributes:@[@"wT_ID"]
                                    ];
    
    
    RKEntityMapping *company = [self addMappingForEntityForName:@"CDMCompany"
                                attributeMappingsFromDictionary:@{
                                                                  @"id":@"comp_ID",
                                                                  @"title":@"title"
                                                                  }
                                       identificationAttributes:@[@"comp_ID"]
                                ];
    
    
    RKEntityMapping *contact = [self addMappingForEntityForName:@"CDMContact"
                                attributeMappingsFromDictionary:@{
                                                                  @"address":@"address"
                                                                  }
                                       identificationAttributes:@[@"address"]
                                ];
    
    
    // relationshipMappingFromKeyPath: @"JSON" toKeyPath:@"ObjectName"
    RKRelationshipMapping *currencyRM = [RKRelationshipMapping relationshipMappingFromKeyPath:@"currency" toKeyPath:@"currency" withMapping:currency];
    RKRelationshipMapping *experienceLengthRM = [RKRelationshipMapping relationshipMappingFromKeyPath:@"experience_length" toKeyPath:@"experienceLength" withMapping:experienceLength];
    RKRelationshipMapping *workingTypeRM = [RKRelationshipMapping relationshipMappingFromKeyPath:@"working_type" toKeyPath:@"workingType" withMapping:workingType];
    RKRelationshipMapping *companyRM = [RKRelationshipMapping relationshipMappingFromKeyPath:@"company" toKeyPath:@"company" withMapping:company];
    RKRelationshipMapping *contactRM = [RKRelationshipMapping relationshipMappingFromKeyPath:@"contact" toKeyPath:@"contact" withMapping:contact];
    
    
    [vacancy addPropertyMapping:currencyRM];
    [vacancy addPropertyMapping:experienceLengthRM];
    [vacancy addPropertyMapping:workingTypeRM];
    [vacancy addPropertyMapping:companyRM];
    [vacancy addPropertyMapping:contactRM];
    
    return vacancy;
}



- (void) createDefaultResponseDescriptor {
    
    RKEntityMapping *modelMapping = [self mappingForEntities];
    
    if (!modelMapping) {
        return;
    }
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:modelMapping
                                                                                            method:RKRequestMethodGET
                                                                                       pathPattern:API_PATH_PATTERN
                                                                                           keyPath:@"vacancies"
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    
    [_objectManager addResponseDescriptor:responseDescriptor];
}



- (RKResponseDescriptor *) createResponseDescriptorWithID:(NSString *)ID {
    
    
    RKEntityMapping *modelMapping = [self mappingForEntities];
    
    if (!modelMapping) {
        return nil;
    }
    
    NSString *pathPattern = [NSString stringWithFormat:@"%@%@", API_PATH_PATTERN, ID];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:modelMapping
                                                                                            method:RKRequestMethodGET
                                                                                       pathPattern:pathPattern
                                                                                           keyPath:@"vacancies"
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    
    [_objectManager addResponseDescriptor:responseDescriptor];
    
    
    return responseDescriptor;
    
}



@end
