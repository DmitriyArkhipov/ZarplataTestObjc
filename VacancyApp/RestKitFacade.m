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


- (void) requestAPIData {

    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    
    NSDictionary *queryParams = @{
                                  @"offset" : @(25), //Начальный сдвиг возвращаемых результато
                                  @"limit" : @(100)
                                  };
    
    
    
    [[RKObjectManager sharedManager] getObjectsAtPath:API_PATH_PATTERN parameters:queryParams success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        NSLog(@"================== requestAPIData getObjectsAtPath ==================");
        
        [[self managedObjectContext] saveToPersistentStore:nil];
        
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"What do you mean by 'there is no zarplata?': %@", error.description);
    }];



}

- (void) addMappingForEntities {
    
    if (!_objectManager) {
        return;
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
                                                                  @"id":@"cont_ID",
                                                                  @"address":@"address"
                                                                  }
                                       identificationAttributes:@[@"cont_ID"]
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
    
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:vacancy
                                                                                            method:RKRequestMethodGET
                                                                                       pathPattern:API_PATH_PATTERN
                                                                                           keyPath:@"vacancies"
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];


    [_objectManager addResponseDescriptor:responseDescriptor];


}

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
    
    [self configureWithManagedObjectModel:managedObjectModel];
    
    [self addMappingForEntities];
}



#pragma mark - RestKit Config



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



- (void)configureWithManagedObjectModel:(NSManagedObjectModel *)managedObjectModel
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





@end
