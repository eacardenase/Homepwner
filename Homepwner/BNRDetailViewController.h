//
//  BNRDetailViewController.h
//  Homepwner
//
//  Created by Edwin Cardenas on 6/02/25.
//

#import <UIKit/UIKit.h>

@class BNRItem;

NS_ASSUME_NONNULL_BEGIN

@interface BNRDetailViewController : UIViewController

- (instancetype)initForNewItem:(BOOL)isNew NS_DESIGNATED_INITIALIZER;

@property (nonatomic) BNRItem *item;
@property (nonatomic, copy) void (^dismissBlock)(void);

@end

NS_ASSUME_NONNULL_END
