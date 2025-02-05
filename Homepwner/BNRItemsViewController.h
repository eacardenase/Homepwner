//
//  BNRItemsViewController.h
//  Homepwner
//
//  Created by Edwin Cardenas on 3/02/25.
//

#import <UIKit/UIKit.h>
#import "BNRHeaderView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BNRItemsViewController : UITableViewController <BNRHeaderViewProtocol>

@property (nonatomic) BNRHeaderView *headerView;

@end

NS_ASSUME_NONNULL_END
