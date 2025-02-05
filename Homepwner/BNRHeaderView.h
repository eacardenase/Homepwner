//
//  BNRHeaderView.h
//  Homepwner
//
//  Created by Edwin Cardenas on 5/02/25.
//

#import <UIKit/UIKit.h>

@protocol BNRHeaderViewProtocol <NSObject>

- (void)toggleEditingMode:(id _Nonnull)sender;
- (void)addNewItem:(id _Nonnull)sender;

@end

NS_ASSUME_NONNULL_BEGIN

@interface BNRHeaderView : UIView

@property (nonatomic, weak) id<BNRHeaderViewProtocol> delegate;
@property (nonatomic) UIButton *editButton;
@property (nonatomic) UIButton *addItemButton;

@end

NS_ASSUME_NONNULL_END
