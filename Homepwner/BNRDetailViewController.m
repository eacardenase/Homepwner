//
//  BNRDetailViewController.m
//  Homepwner
//
//  Created by Edwin Cardenas on 6/02/25.
//

#import "BNRDetailViewController.h"
#import "BNRItem.h"
#import "BNRImageStore.h"

@interface BNRDetailViewController () <UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UITextField *nameField;
@property (nonatomic) UILabel *serialNumberLabel;
@property (nonatomic) UITextField *serialNumberField;
@property (nonatomic) UILabel *valueLabel;
@property (nonatomic) UITextField *valueField;
@property (nonatomic) UILabel *dateLabel;
@property (nonatomic) UIImageView *imageView;

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
        _nameField.delegate = self;
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
        _serialNumberField.delegate = self;
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
        _valueField.keyboardType = UIKeyboardTypeNumberPad;
        _valueField.delegate = self;
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

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        _imageView.backgroundColor = [UIColor secondarySystemBackgroundColor];
        
        UIImage *itemImage = [[BNRImageStore sharedStore]
                              imageForKey:self.item.itemKey];
        
        _imageView.image = itemImage;
    }
    
    return _imageView;
}

- (void)setupViews
{
    self.title = self.item.itemName;
    self.navigationController.toolbarHidden = NO;
    self.toolbarItems = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                                                        target:self
                                                                        action:@selector(takePicture:)]];
    
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.nameField];
    [self.view addSubview:self.serialNumberLabel];
    [self.view addSubview:self.serialNumberField];
    [self.view addSubview:self.valueLabel];
    [self.view addSubview:self.valueField];
    [self.view addSubview:self.dateLabel];
    [self.view addSubview:self.imageView];
    
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
        [self.dateLabel.trailingAnchor constraintEqualToAnchor:self.nameField.trailingAnchor],
        
        [self.imageView.topAnchor constraintEqualToAnchor:self.dateLabel.bottomAnchor constant:10],
        [self.imageView.leadingAnchor constraintEqualToAnchor:self.nameLabel.leadingAnchor],
        [self.imageView.trailingAnchor constraintEqualToAnchor:self.nameField.trailingAnchor],
        [self.imageView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-10]
    ]];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
    BNRItem *item = self.item;
    item.itemName = self.nameField.text;
    item.serialNumber = self.serialNumberField.text;
    item.valueInDollars = [self.valueField.text intValue];
}

#pragma mark - Actions

- (void)takePicture:(id)sender
{
    NSLog(@"DEBUG: takePicture: button tapped");
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    
    [self presentViewController:imagePicker
                       animated:YES
                     completion:nil];
}

- (void)dismissKeyboard
{
    [self.view endEditing:YES];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    [[BNRImageStore sharedStore] setImage:image
                                   forKey:self.item.itemKey];
    
    [self.imageView setImage:image];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}


@end
