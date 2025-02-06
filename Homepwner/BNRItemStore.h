//
//  BNRItemStore.h
//  Homepwner
//
//  Created by Edwin Cardenas on 3/02/25.
//

#import <Foundation/Foundation.h>

@class BNRItem;

NS_ASSUME_NONNULL_BEGIN

@interface BNRItemStore : NSObject

@property (nonatomic, readonly) NSArray<BNRItem *> *allItems;

+ (instancetype)sharedStore;
- (BNRItem *)createItem;
- (void)removeItem:(BNRItem *)item;

@end

NS_ASSUME_NONNULL_END
