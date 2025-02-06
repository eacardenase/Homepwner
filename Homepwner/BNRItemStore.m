//
//  BNRItemStore.m
//  Homepwner
//
//  Created by Edwin Cardenas on 3/02/25.
//

#import "BNRItemStore.h"
#import "BNRItem.h"

@interface BNRItemStore ()

@property (nonatomic) NSMutableArray<BNRItem *> *privateItems;

@end

@implementation BNRItemStore


+ (instancetype)sharedStore
{
    static BNRItemStore *sharedStore = nil;
    
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    
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
        _privateItems = [[NSMutableArray<BNRItem *> alloc] init];
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
    [self.privateItems removeObjectIdenticalTo:item];
}


@end
