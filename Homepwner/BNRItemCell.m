//
//  BNRItemCell.m
//  Homepwner
//
//  Created by Edwin Cardenas on 2/25/25.
//

#import "BNRItemCell.h"
#import "BNRItem.h"


@implementation BNRItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
    }
    
    return self;
}

- (UIImageView *)itemImageView
{
    if (!_itemImageView) {
        _itemImageView = [[UIImageView alloc] init];
        _itemImageView.contentMode = UIViewContentModeScaleAspectFit;
        _itemImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _itemImageView.tintColor = [UIColor lightGrayColor];
    }
    
    return _itemImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return _nameLabel;
}

- (UILabel *)serialNumberLabel
{
    if (!_serialNumberLabel) {
        _serialNumberLabel = [[UILabel alloc] init];
        _serialNumberLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return _serialNumberLabel;
}

- (UILabel *)valueLabel
{
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return _valueLabel;
}

- (void)setupViews
{
    [self.contentView addSubview:self.itemImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.valueLabel];
    [self.contentView addSubview:self.serialNumberLabel];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.itemImageView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:8],
        [self.itemImageView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:20],
        [self.itemImageView.heightAnchor constraintGreaterThanOrEqualToConstant:40],
        [self.itemImageView.widthAnchor constraintEqualToAnchor:self.itemImageView.heightAnchor],
        [self.itemImageView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
        [self.itemImageView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-8],
        
        [self.nameLabel.leadingAnchor constraintEqualToAnchor:self.itemImageView.trailingAnchor constant:10],
        [self.nameLabel.topAnchor constraintEqualToAnchor:self.itemImageView.topAnchor],
        
        [self.serialNumberLabel.leadingAnchor constraintEqualToAnchor:self.nameLabel.leadingAnchor],
        [self.serialNumberLabel.bottomAnchor constraintEqualToAnchor:self.itemImageView.bottomAnchor],
        
        [self.valueLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-20],
        [self.valueLabel.topAnchor constraintEqualToAnchor:self.nameLabel.topAnchor]
    ]];
}


@end
