//
//  BNRItem.h
//  Homepwner
//
//  Created by Edwin Cardenas on 3/6/25.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface BNRItem : NSManagedObject

@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *serialNumber;
@property (nonatomic) NSDate *dateCreated;
@property (nonatomic, copy) NSString *itemKey;
@property (nonatomic) UIImage *thumbnail;
@property (nonatomic) double orderingValue;
@property (nonatomic) int valueInDollars;
@property (nonatomic) NSManagedObject *assetType;

- (void)setThumbnailFromImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
