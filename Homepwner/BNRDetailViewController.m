//
//  BNRDetailViewController.m
//  Homepwner
//
//  Created by Edwin Cardenas on 6/02/25.
//

#import "AppDelegate.h"
#import "BNRDetailViewController.h"
#import "BNRItem.h"
#import "BNRImageStore.h"
#import "BNRItemStore.h"
#import "BNRAssetTypeViewController.h"

@interface BNRDetailViewController () <UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UITextField *nameField;
@property (nonatomic) UILabel *serialNumberLabel;
@property (nonatomic) UITextField *serialNumberField;
@property (nonatomic) UILabel *valueLabel;
@property (nonatomic) UITextField *valueField;
@property (nonatomic) UILabel *dateLabel;
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UIBarButtonItem *cameraButton;
@property (nonatomic) UIBarButtonItem *assetTypeButton;

@end

@implementation BNRDetailViewController


- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"Name";
        _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [_nameLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_nameLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
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
                                      forAxis:UILayoutConstraintAxisVertical];
    }
    
    return _dateLabel;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        UIImage *itemImage = [[BNRImageStore sharedStore]
                              imageForKey:self.item.itemKey];
        
        if (!itemImage) {
            itemImage = _item.thumbnail;
        }
        
        _imageView = [[UIImageView alloc] initWithImage:itemImage];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        _imageView.tintColor = [UIColor lightGrayColor];
    }
    
    return _imageView;
}

- (UIBarButtonItem *)cameraButton
{
    if (!_cameraButton) {
        _cameraButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                                                      target:self
                                                                      action:@selector(takePicture:)];
    }
    
    return _cameraButton;
}

- (UIBarButtonItem *)assetTypeButton
{
    if (!_assetTypeButton) {
//        _assetTypeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
//                                                                         target:self
//                                                                         action:@selector(showAssetTypePicker:)];
//        _assetTypeButton = [[UIBarButtonItem alloc] initWithTitle:buttonTitle
//                                                            style:UIBarButtonItemStylePlain
//                                                           target:self
//                                                           action:@selector(showAssetTypePicker:)];
        _assetTypeButton = [[UIBarButtonItem alloc] init];
        _assetTypeButton.target = self;
        _assetTypeButton.action = @selector(showAssetTypePicker:);
    }
    
    return _assetTypeButton;
}

- (void)setupViews
{
    self.title = self.item.itemName;
    self.navigationController.toolbarHidden = NO;
    self.toolbarItems = @[self.cameraButton, self.assetTypeButton];
    
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
        
        [self.nameField.topAnchor constraintEqualToAnchor:self.nameLabel.topAnchor],
        [self.nameField.leadingAnchor constraintEqualToAnchor:self.nameLabel.trailingAnchor constant:20],
        [self.nameField.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor constant:-20],
        
        [self.serialNumberLabel.topAnchor constraintEqualToAnchor:self.nameLabel.bottomAnchor constant:10],
        [self.serialNumberLabel.leadingAnchor constraintEqualToAnchor:self.nameLabel.leadingAnchor],
        [self.serialNumberLabel.widthAnchor constraintEqualToAnchor:self.nameLabel.widthAnchor],
        [self.serialNumberLabel.centerYAnchor constraintEqualToAnchor:self.serialNumberField.centerYAnchor],
        
        [self.serialNumberField.topAnchor constraintEqualToAnchor:self.serialNumberLabel.topAnchor],
        [self.serialNumberField.leadingAnchor constraintEqualToAnchor:self.nameField.leadingAnchor],
        [self.serialNumberField.trailingAnchor constraintEqualToAnchor:self.nameField.trailingAnchor],
        
        [self.valueLabel.topAnchor constraintEqualToAnchor:self.serialNumberLabel.bottomAnchor constant:10],
        [self.valueLabel.leadingAnchor constraintEqualToAnchor:self.nameLabel.leadingAnchor],
        [self.valueLabel.widthAnchor constraintEqualToAnchor:self.nameLabel.widthAnchor],
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

- (void)prepareViewsForOrientation:(UITraitCollection *)collection
{
    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return;
    }
    
    if (collection.verticalSizeClass == UIUserInterfaceSizeClassCompact) {
        self.imageView.hidden = YES;
        self.cameraButton.enabled = NO;
    } else {
        self.imageView.hidden = NO;
        self.cameraButton.enabled = YES;
    }
}

- (void)updateFonts
{
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    self.nameLabel.font = font;
    self.serialNumberLabel.font = font;
    self.valueLabel.font = font;
    self.dateLabel.font = font;
    
    self.nameField.font = font;
    self.serialNumberField.font = font;
    self.valueField.font = font;
}

#pragma mark - Lifecycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    @throw [NSException exceptionWithName:@"Wrong initializer"
                                   reason:@"Use initForNewItem:"
                                 userInfo:nil];
    
    return nil;
}

- (instancetype)initForNewItem:(BOOL)isNew
{
    if (self = [super initWithNibName:nil bundle:nil]) {
        if (isNew) {
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]
                                         initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                         target:self
                                         action:@selector(save:)];
            self.navigationItem.rightBarButtonItem = doneItem;
            
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                           target:self
                                           action:@selector(cancel:)];
            self.navigationItem.leftBarButtonItem = cancelItem;
        }
        
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        [defaultCenter addObserver:self
                          selector:@selector(updateFonts)
                              name:UIContentSizeCategoryDidChangeNotification
                            object:nil];
    }
    
    return self;
}

- (void)loadView
{
    self.view = [UIView new];
    [self setupViews];
    [self updateFonts];
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
    
    int newValue = [self.valueField.text intValue];
    
    if (newValue == item.valueInDollars) {
        return;
    }
    
    item.valueInDollars = newValue;
    
    NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
    
    [defaults setInteger:newValue
                  forKey:BNRNextItemValuePrefsKey];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *typeLabel = [self.item.assetType valueForKey:@"label"];
    
    if (!typeLabel) {
        typeLabel = @"None";
    }
    
    self.assetTypeButton.title = [NSString stringWithFormat:@"Type: %@", typeLabel];
    
    [self prepareViewsForOrientation:[UITraitCollection currentTraitCollection]];
}

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [self prepareViewsForOrientation:newCollection];
    
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
}

- (void)dealloc
{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self];
}

#pragma mark - Actions

- (void)takePicture:(id)sender
{
    NSLog(@"DEBUG: takePicture: button tapped");
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    
    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        imagePicker.modalPresentationStyle = UIModalPresentationPopover;
        imagePicker.popoverPresentationController.barButtonItem = self.cameraButton;
    }
    
    [self presentViewController:imagePicker
                       animated:YES
                     completion:nil];
}

- (void)showAssetTypePicker:(id)sender
{
    NSLog(@"DEBUG: showAssetTypePicker: button tapped");
    
    [self.view endEditing:YES];
    
    BNRAssetTypeViewController *assetViewController = [[BNRAssetTypeViewController alloc]
                                                       initWithStyle:UITableViewStylePlain];
    assetViewController.item = self.item;
    
    [self.navigationController pushViewController:assetViewController
                                         animated:YES];
}

- (void)dismissKeyboard
{
    [self.view endEditing:YES];
}

- (void)save:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:self.dismissBlock];
}

- (void)cancel:(id)sender
{
    [[BNRItemStore sharedStore] removeItem:self.item];
    
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    [self.item setThumbnailFromImage:image];
    
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
