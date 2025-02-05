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
    self.editButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.editButton setTitle:@"Edit" forState:UIControlStateNormal];
    [self.editButton addTarget:self
                        action:@selector(handleEditButtonTap:)
              forControlEvents:UIControlEventTouchUpInside];
    
    self.addItemButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.addItemButton setTitle:@"New" forState:UIControlStateNormal];
    [self.addItemButton addTarget:self
                           action:@selector(handleAddButtonTap:)
                 forControlEvents:UIControlEventTouchUpInside];
    
    self.editButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.addItemButton.translatesAutoresizingMaskIntoConstraints = NO;
    
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
