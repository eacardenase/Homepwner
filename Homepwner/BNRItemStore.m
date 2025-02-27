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

@interface BNRItemStore ()

@property (nonatomic) NSMutableArray<BNRItem *> *privateItems;

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
        NSString *path = [self itemArchivePath];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSError *error;
        
        NSSet *validClasses = [NSSet setWithObjects: NSMutableArray.class, BNRItem.class, NSString.class, NSDate.class, UIImage.class, nil];
        _privateItems = [NSKeyedUnarchiver unarchivedObjectOfClasses:validClasses fromData:data error:&error];
        
        if (!_privateItems) {
            NSLog(@"%@", error.localizedDescription);
            _privateItems = [NSMutableArray array];
        }
    }
    
    return self;
}

- (NSArray<BNRItem *> *)allItems
{
    return [self.privateItems copy];
}

- (BNRItem *)createItem
{
    BNRItem *item = [BNRItem randomItem];
    
    [self.privateItems addObject:item];
    
    return item;
}

- (void)removeItem:(BNRItem *)item
{
    NSString *key = item.itemKey;
    
    [[BNRImageStore sharedStore] deleteImageForKey:key];
    
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
}

- (NSString *)itemArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                       NSUserDomainMask,
                                                                       YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
}

- (BOOL)saveChanges
{
    NSString *path = [self itemArchivePath];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.privateItems
                                         requiringSecureCoding:YES
                                                         error:nil];
    return [data writeToFile:path atomically:YES];
}


@end
