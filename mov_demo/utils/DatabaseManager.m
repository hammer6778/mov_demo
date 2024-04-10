#import "DatabaseManager.h"

@implementation DatabaseManager

@synthesize managedObjectContext = _managedObjectContext;

+ (instancetype)sharedInstance {
    static DatabaseManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (NSError *)setupManagedObjectContext {
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"LoaclUserModel" withExtension:@"momd"];
    if (!modelURL) {
        return [NSError errorWithDomain:@"YourAppDomain" code:1001 userInfo:@{NSLocalizedDescriptionKey: @"Failed to locate data model URL"}];
    }
    
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    if (!mom) {
        return [NSError errorWithDomain:@"YourAppDomain" code:1002 userInfo:@{NSLocalizedDescriptionKey: @"Failed to initialize managed object model"}];
    }
    
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    if (!coordinator) {
        return [NSError errorWithDomain:@"YourAppDomain" code:1003 userInfo:@{NSLocalizedDescriptionKey: @"Failed to initialize persistent store coordinator"}];
    }
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL *storeURL = [NSURL fileURLWithPath:[docsDir stringByAppendingPathComponent:@"LoaclUserModel.sqlite"]];
    
    NSError *error = nil;
    if (![coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        return error;
    }
    
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    
    return nil;
}

- (void)saveContextAsync {
    [self.managedObjectContext performBlock:^{
        NSError *error = nil;
        if ([self.managedObjectContext hasChanges] && ![self.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }];
}

- (NSManagedObject *)insertNewObjectForEntityForName:(NSString *)entityName {
    if (!entityName) {
        NSLog(@"Entity name is nil");
        return nil;
    }
    
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.managedObjectContext];
    if (!object) {
        NSLog(@"Failed to insert new object for entity %@", entityName);
    }
    
    return object;
}

- (NSArray *)executeFetchRequestForEntity:(NSString *)entityName withPredicate:(NSPredicate *)predicate {
    if (!entityName) {
        NSLog(@"Entity name is nil");
        return nil;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    fetchRequest.predicate = predicate;
    
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"Error fetching data for entity %@: %@", entityName, error);
    }
    
    return results;
}

- (void)deleteManagedObject:(NSManagedObject *)object {
    if (!object) {
        NSLog(@"Object to delete is nil");
        return;
    }
    
    [self.managedObjectContext deleteObject:object];
}

- (void)updateManagedObject:(NSManagedObject *)object withValues:(NSDictionary *)newValues {
    if (!object) {
        NSLog(@"Object to update is nil");
        return;
    }
    
    if (!newValues) {
        NSLog(@"New values dictionary is nil");
        return;
    }
    
    [newValues enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        [object setValue:value forKey:key];
    }];
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error updating managed object: %@", error);
    }
}

@end
