//
//  BNRItemCell.m
//  Homepwner
//
//  Created by Edwin Cardenas on 2/25/25.
//

#import "BNRItemCell.h"
#import "BNRItem.h"

@interface BNRItemCell ()

@property (nonatomic) UIButton *thumbnailButton;

@end

@implementation BNRItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
        [self updateInterfaceForDynamicTypeSize];
        
        NSNotificationCenter *notificationCenter = NSNotificationCenter.defaultCenter;
        
        [notificationCenter addObserver:self
                               selector:@selector(updateInterfaceForDynamicTypeSize)
                                   name:UIContentSizeCategoryDidChangeNotification
                                 object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (UIImageView *)itemImageView
{
    if (!_itemImageView) {
        _itemImageView = [[UIImageView alloc] init];
        _itemImageView.contentMode = UIViewContentModeScaleAspectFit;
        _itemImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _itemImageView.tintColor = [UIColor lightGrayColor];
        _itemImageView.layer.cornerRadius = 8.0;
        _itemImageView.layer.masksToBounds = YES;
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

- (UIButton *)thumbnailButton
{
    if (!_thumbnailButton) {
        _thumbnailButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _thumbnailButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_thumbnailButton addTarget:self
                             action:@selector(showImage:)
              forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _thumbnailButton;
}

- (void)setupViews
{
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[
        self.nameLabel, self.serialNumberLabel,
    ]];
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.distribution = UIStackViewDistributionEqualCentering;
    stackView.spacing = 4;
    
    [self.contentView addSubview:self.itemImageView];
    [self.contentView addSubview:stackView];
    [self.contentView addSubview:self.valueLabel];
    [self.contentView addSubview:self.thumbnailButton];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.itemImageView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:8],
        [self.itemImageView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:20],
        [self.itemImageView.heightAnchor constraintEqualToAnchor:self.itemImageView.widthAnchor],
        [self.itemImageView.widthAnchor constraintEqualToAnchor:self.itemImageView.heightAnchor],
        [self.itemImageView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
        [self.itemImageView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-8],
        
        [stackView.leadingAnchor constraintEqualToAnchor:self.itemImageView.trailingAnchor constant:10],
        [stackView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
        
        [self.valueLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-20],
        [self.valueLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
        
        [self.thumbnailButton.topAnchor constraintEqualToAnchor:self.itemImageView.topAnchor],
        [self.thumbnailButton.leadingAnchor constraintEqualToAnchor:self.itemImageView.leadingAnchor],
        [self.thumbnailButton.trailingAnchor constraintEqualToAnchor:self.itemImageView.trailingAnchor],
        [self.thumbnailButton.bottomAnchor constraintEqualToAnchor:self.itemImageView.bottomAnchor]
    ]];
}

- (void)updateInterfaceForDynamicTypeSize
{
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    self.nameLabel.font = font;
    self.serialNumberLabel.font = font;
    self.valueLabel.font = font;
}

#pragma mark - Actions

- (void)showImage:(id)sender
{
    if (self.actionBlock) {
        self.actionBlock();
    }
}


@end
