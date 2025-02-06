//
//  BNRHeaderView.m
//  Homepwner
//
//  Created by Edwin Cardenas on 5/02/25.
//

#import "BNRHeaderView.h"

@interface BNRHeaderView ()

- (void)setupViews;

@end

@implementation BNRHeaderView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    
    return self;
}

- (void)setupViews
{
    self.backgroundColor = [UIColor clearColor]; // transparent
    
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[
        self.editButton, self.addItemButton
    ]];
    
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.distribution = UIStackViewDistributionFillProportionally;
    
    [self addSubview:stackView];
    
    [NSLayoutConstraint activateConstraints:@[
        [stackView.topAnchor constraintEqualToAnchor:self.topAnchor constant:20],
        [stackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:20],
        [stackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-20],
        [stackView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-20],
    ]];
}

- (UIButton *)editButton
{
    if (!_editButton) {
        _editButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_editButton setTitle:@"Edit" forState:UIControlStateNormal];
        _editButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_editButton addTarget:self
                            action:@selector(handleEditButtonTap:)
                  forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _editButton;
}

- (UIButton *)addItemButton
{
    if (!_addItemButton) {
        _addItemButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_addItemButton setTitle:@"New" forState:UIControlStateNormal];
        _addItemButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_addItemButton addTarget:self
                               action:@selector(handleAddButtonTap:)
                     forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _addItemButton;
}

# pragma mark - Actions

- (void)handleEditButtonTap:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(toggleEditingMode:)]) {
        [self.delegate toggleEditingMode:sender];
    }
}

- (void)handleAddButtonTap:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(addNewItem:)]) {
        [self.delegate addNewItem:sender];
    }
}


@end
