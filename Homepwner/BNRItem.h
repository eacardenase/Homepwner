//
//  BNRItem.h
//  Homepwner
//
//  Created by Edwin Cardenas on 3/02/25.
//

#import <UIKit/UIkit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BNRItem : NSObject <NSSecureCoding>

@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *serialNumber;
@property (nonatomic) int valueInDollars;
@property (nonatomic, readonly, strong) NSDate *dateCreated;
@property (nonatomic, copy) NSString *itemKey;
@property (nonatomic) UIImage *thumbnail;

// Convenience method
+ (instancetype)randomItem;

// Designated initializer for BNRItem
- (instancetype)initWithItemName:(NSString *)name
                  valueInDollars:(int)value
                    serialNumber:(NSString *)sNumber;

- (instancetype)initWithItemName:(NSString *)name;
- (void)setThumbnailFromImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
