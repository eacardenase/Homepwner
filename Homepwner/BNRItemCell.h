//
//  BNRItemCell.h
//  Homepwner
//
//  Created by Edwin Cardenas on 2/25/25.
//

#import <UIKit/UIKit.h>

@class BNRItem;

NS_ASSUME_NONNULL_BEGIN

@interface BNRItemCell : UITableViewCell

@property (nonatomic) UIImageView *itemImageView;
@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UILabel *serialNumberLabel;
@property (nonatomic) UILabel *valueLabel;

@end

NS_ASSUME_NONNULL_END
