// DatabaseManager.h

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DatabaseManager : NSObject

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

+ (instancetype)sharedInstance;
- (void)saveContext;
- (void)saveContextAsync;
- (NSManagedObject *)insertNewObjectForEntityForName:(NSString *)entityName;
- (NSArray *)executeFetchRequestForEntity:(NSString *)entityName withPredicate:(NSPredicate *)predicate;
- (void)deleteManagedObject:(NSManagedObject *)object;
- (void)updateManagedObject:(NSManagedObject *)object withValues:(NSDictionary *)newValues;

@end
