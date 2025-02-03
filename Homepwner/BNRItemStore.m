//
//  BNRItemStore.m
//  Homepwner
//
//  Created by Edwin Cardenas on 3/02/25.
//

#import "BNRItemStore.h"

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
    return [super init];
}


@end
