//
//  BNRImageStore.m
//  Homepwner
//
//  Created by Edwin Cardenas on 10/02/25.
//

#import "BNRImageStore.h"

@interface BNRImageStore ()

@property (nonatomic, copy) NSMutableDictionary *dictionary;

@end

@implementation BNRImageStore


+ (instancetype)sharedStore
{
    static BNRImageStore *sharedStore = nil;
    
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    
    return sharedStore;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[BNRImageStore sharedStore]"
                                 userInfo:nil];
}

- (instancetype)initPrivate
{
    if (self = [super init]) {
        _dictionary = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key
{
    [self.dictionary setObject:image forKey:key];
}

- (UIImage *)imageForKey:(NSString *)key
{
    return [self.dictionary objectForKey:key];
}

- (void)deleteImageForKey:(NSString *)key
{
    if (!key) {
        return;
    }
    
    [self.dictionary removeObjectForKey:key];
}


@end
