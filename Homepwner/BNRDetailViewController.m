//
//  BNRDetailViewController.m
//  Homepwner
//
//  Created by Edwin Cardenas on 6/02/25.
//

#import "BNRDetailViewController.h"

@interface BNRDetailViewController ()

@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UITextField *nameField;
@property (nonatomic) UILabel *serialNumberLabel;
@property (nonatomic) UITextField *serialNumberField;
@property (nonatomic) UILabel *valueLabel;
@property (nonatomic) UITextField *valueField;
@property (nonatomic) UILabel *dateLabel;

@end

@implementation BNRDetailViewController


- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"Name";
        _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [_nameLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh
                                                    forAxis:UILayoutConstraintAxisHorizontal];
    }
    
    return _nameLabel;
}

- (UITextField *)nameField
{
    if (!_nameField) {
        _nameField = [UITextField new];
        _nameField.borderStyle = UITextBorderStyleRoundedRect;
        _nameField.text = self.item.itemName;
        _nameField.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return _nameField;
}

- (UILabel *)serialNumberLabel
{
    if (!_serialNumberLabel) {
        _serialNumberLabel = [[UILabel alloc] init];
        _serialNumberLabel.text = @"Serial";
        _serialNumberLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [_serialNumberLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh
                                      forAxis:UILayoutConstraintAxisHorizontal];
    }
    
    return _serialNumberLabel;
}

- (UITextField *)serialNumberField
{
    if (!_serialNumberField) {
        _serialNumberField = [UITextField new];
        _serialNumberField.borderStyle = UITextBorderStyleRoundedRect;
        _serialNumberField.text = self.item.serialNumber;
        _serialNumberField.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return _serialNumberField;
}

- (UILabel *)valueLabel
{
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.text = @"Value";
        _valueLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [_valueLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh
                                              forAxis:UILayoutConstraintAxisHorizontal];
    }
    
    return _valueLabel;
}

- (UITextField *)valueField
{
    if (!_valueField) {
        _valueField = [UITextField new];
        _valueField.borderStyle = UITextBorderStyleRoundedRect;
        _valueField.text = [NSString stringWithFormat:@"%d", self.item.valueInDollars];
        _valueField.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return _valueField;
}

- (UILabel *)dateLabel
{
    static NSDateFormatter *dateFormatter = nil;
    
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.text = [dateFormatter stringFromDate:self.item.dateCreated];
        [_dateLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh
                                       forAxis:UILayoutConstraintAxisHorizontal];
    }
    
    return _dateLabel;
}

- (void)setupViews
{
    self.title = self.item.itemName;
    
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.nameField];
    [self.view addSubview:self.serialNumberLabel];
    [self.view addSubview:self.serialNumberField];
    [self.view addSubview:self.valueLabel];
    [self.view addSubview:self.valueField];
    [self.view addSubview:self.dateLabel];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.nameLabel.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:20],
        [self.nameLabel.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor constant:20],
        [self.nameLabel.centerYAnchor constraintEqualToAnchor:self.nameField.centerYAnchor],
        [self.nameLabel.widthAnchor constraintEqualToConstant:50],
        
        [self.nameField.topAnchor constraintEqualToAnchor:self.nameLabel.topAnchor],
        [self.nameField.leadingAnchor constraintEqualToAnchor:self.nameLabel.trailingAnchor constant:20],
        [self.nameField.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor constant:-20],
        
        [self.serialNumberLabel.topAnchor constraintEqualToAnchor:self.nameLabel.bottomAnchor constant:10],
        [self.serialNumberLabel.leadingAnchor constraintEqualToAnchor:self.nameLabel.leadingAnchor],
        [self.serialNumberLabel.trailingAnchor constraintEqualToAnchor:self.nameLabel.trailingAnchor],
        [self.serialNumberLabel.centerYAnchor constraintEqualToAnchor:self.serialNumberField.centerYAnchor],
        
        [self.serialNumberField.topAnchor constraintEqualToAnchor:self.serialNumberLabel.topAnchor],
        [self.serialNumberField.leadingAnchor constraintEqualToAnchor:self.nameField.leadingAnchor],
        [self.serialNumberField.trailingAnchor constraintEqualToAnchor:self.nameField.trailingAnchor],
        
        [self.valueLabel.topAnchor constraintEqualToAnchor:self.serialNumberLabel.bottomAnchor constant:10],
        [self.valueLabel.leadingAnchor constraintEqualToAnchor:self.nameLabel.leadingAnchor],
        [self.valueLabel.trailingAnchor constraintEqualToAnchor:self.nameLabel.trailingAnchor],
        [self.valueLabel.centerYAnchor constraintEqualToAnchor:self.valueField.centerYAnchor],
        
        [self.valueField.topAnchor constraintEqualToAnchor:self.valueLabel.topAnchor],
        [self.valueField.leadingAnchor constraintEqualToAnchor:self.nameField.leadingAnchor],
        [self.valueField.trailingAnchor constraintEqualToAnchor:self.nameField.trailingAnchor],
        
        [self.dateLabel.topAnchor constraintEqualToAnchor:self.valueLabel.bottomAnchor constant:10],
        [self.dateLabel.leadingAnchor constraintEqualToAnchor:self.nameLabel.leadingAnchor],
        [self.dateLabel.trailingAnchor constraintEqualToAnchor:self.nameField.trailingAnchor]
    ]];
}

#pragma mark - Lifecycle

- (void)loadView
{
    self.view = [UIView new];
    [self setupViews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}


@end
