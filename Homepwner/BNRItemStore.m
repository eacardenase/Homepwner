//
//  BNRItemStore.m
//  Homepwner
//
//  Created by Edwin Cardenas on 3/02/25.
//
#import <UIKit/UIKit.h>
#import "BNRItemStore.h"
#import "BNRItem.h"
#import "BNRImageStore.h"

@import CoreData;

@interface BNRItemStore ()

@property (nonatomic) NSMutableArray<BNRItem *> *privateItems;
@property (nonatomic, strong) NSMutableArray *allAssetTypes;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectModel *model;

@end

@implementation BNRItemStore


+ (instancetype)sharedStore
{
    static BNRItemStore *sharedStore = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    
    return sharedStore;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[BNRItemStore sharedStore]"
                                 userInfo:nil];
}

- (instancetype)initPrivate
{
    if (self = [super init]) {
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                             initWithManagedObjectModel:_model];
        
        NSString *path = [self itemArchivePath];
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        
        NSError *error;
        
        if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                               configuration:nil
                                         URL:storeURL
                                     options:nil
                                       error:&error]) {
            @throw [NSException exceptionWithName:@"OpenFailure"
                                           reason:error.localizedDescription
                                         userInfo:nil];
        }
        
        _context = [[NSManagedObjectContext alloc] init];
        _context.persistentStoreCoordinator = persistentStoreCoordinator;
        
        [self loadAllItems];
    }
    
    return self;
}

- (NSArray<BNRItem *> *)allItems
{
    return [self.privateItems copy];
}

- (BNRItem *)createItem
{
    double order;
    
    if (self.privateItems.count == 0) {
        order = 1.0;
    } else {
        order = [[self.privateItems lastObject] orderingValue] + 1.0;
    }
    
    NSLog(@"Adding after %lu items, order = %.2f", (unsigned long)self.privateItems.count, order);
    
    BNRItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"BNRItem"
                                                  inManagedObjectContext:self.context];
    item.orderingValue = order;
    
    [self.privateItems addObject:item];
    
    return item;
}

- (void)removeItem:(BNRItem *)item
{
    NSString *key = item.itemKey;
    
    [[BNRImageStore sharedStore] deleteImageForKey:key];
    
    [self.context deleteObject:item];
    [self.privateItems removeObjectIdenticalTo:item];
}

- (void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    if (fromIndex == toIndex) {
        return;
    }
    
    BNRItem *item = self.privateItems[fromIndex];
    
    [self.privateItems removeObjectAtIndex:fromIndex];
    [self.privateItems insertObject:item atIndex:toIndex];
    
    // Computing a new orderValue for the object that was moved
    double lowerBound = 0.0;
    double upperBound = 0.0;
    
    // Is there an object before it in the array?
    if (toIndex > 0) {
        lowerBound = [self.privateItems[(toIndex - 1)] orderingValue];
    } else {
        lowerBound = [self.privateItems[1] orderingValue] - 2.0;
    }
    
    // Is there an object after it in the array?
    if (toIndex < self.privateItems.count - 1) {
        upperBound = [self.privateItems[(toIndex + 1)] orderingValue];
    } else {
        upperBound = [self.privateItems[(toIndex - 1)] orderingValue] + 2.0;
    }
    
    double newOrderValue = (lowerBound + upperBound) / 2.0;
    
    NSLog(@"moving to order %f", newOrderValue);
    
    item.orderingValue = newOrderValue;
}

- (NSString *)itemArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                       NSUserDomainMask,
                                                                       YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}

- (BOOL)saveChanges
{
    NSError *error;
    BOOL successful = [self.context save:&error];
    
    if (!successful) {
        NSLog(@"Error saving: %@", error.localizedDescription);
    }
    
    return successful;
}

- (void)loadAllItems
{
    if (!self.privateItems) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"BNRItem"
                                             inManagedObjectContext:self.context];
        request.entity = entity;

        NSSortDescriptor *sortDescriptor = [NSSortDescriptor
                                sortDescriptorWithKey:@"orderingValue"
                                ascending:YES];
        request.sortDescriptors = @[sortDescriptor];

        NSError *error;
        NSArray *result = [self.context executeFetchRequest:request error:&error];

        if (!result) {
            [NSException raise:@"Fetch failed"
                        format:@"Reason: %@", error.localizedDescription];
        }

        self.privateItems = [[NSMutableArray alloc] initWithArray:result];
    }
}

- (NSArray *)allAssetTypes
{
    if (!_allAssetTypes) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"BNRAssetType"
                                                  inManagedObjectContext:self.context];
        request.entity = entity;
        
        NSError *error;
        NSArray *result = [self.context executeFetchRequest:request
                                                      error:&error];
        
        if (!result) {
            [NSException raise:@"Fetch failed"
                        format:@"Reason: %@", error.localizedDescription];
        }
        
        if (_allAssetTypes.count == 0) {
            NSManagedObject *assetType;
            
            assetType = [NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType"
                                                      inManagedObjectContext:self.context];
            [assetType setValue:@"Furniture" forKey:@"label"];
            [_allAssetTypes addObject:assetType];
            
            assetType = [NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType"
                                                      inManagedObjectContext:self.context];
            [assetType setValue:@"Jewelry" forKey:@"label"];
            [_allAssetTypes addObject:assetType];
            
            assetType = [NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType"
                                                      inManagedObjectContext:self.context];
            [assetType setValue:@"Electronics" forKey:@"label"];
            [_allAssetTypes addObject:assetType];
        }
    }
    
    return _allAssetTypes;
}

@end
