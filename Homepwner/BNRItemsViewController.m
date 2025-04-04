//
//  BNRItemsViewController.m
//  Homepwner
//
//  Created by Edwin Cardenas on 3/02/25.
//

#import "BNRItemsViewController.h"
#import "BNRItemStore.h"
#import "BNRItem.h"
#import "BNRDetailViewController.h"
#import "BNRItemCell.h"
#import "BNRImageStore.h"
#import "BNRImageViewController.h"

@interface BNRItemsViewController ()

- (instancetype)init NS_DESIGNATED_INITIALIZER;

@end

@implementation BNRItemsViewController


- (instancetype)init
{
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Homepwner";
        
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                   target:self
                                                                                   action:@selector(addNewItem:)];
        navItem.rightBarButtonItem = addButton;
        navItem.leftBarButtonItem = self.editButtonItem;
        
        NSNotificationCenter *notificationCenter = NSNotificationCenter.defaultCenter;
        
        [notificationCenter addObserver:self
                               selector:@selector(updateTableViewForDynamicTypeSize)
                                   name:UIContentSizeCategoryDidChangeNotification
                                 object:nil];
    }
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)dealloc
{
    NSNotificationCenter *notificationCenter = NSNotificationCenter.defaultCenter;
    [notificationCenter removeObserver:self];
}

- (void)updateTableViewForDynamicTypeSize
{
    static NSDictionary *cellHeightDictionary;
    
    if (!cellHeightDictionary) {
        cellHeightDictionary = @{
            UIContentSizeCategoryExtraSmall: @44,
            UIContentSizeCategorySmall: @44,
            UIContentSizeCategoryMedium: @44,
            UIContentSizeCategoryLarge: @44,
            UIContentSizeCategoryExtraLarge: @55,
            UIContentSizeCategoryExtraExtraLarge: @65,
            UIContentSizeCategoryExtraExtraExtraLarge: @75
        };
    }
    
    NSString *userSize = UIApplication.sharedApplication.preferredContentSizeCategory;
    NSNumber *cellHeight = cellHeightDictionary[userSize];
    
    [self.tableView setRowHeight:cellHeight.floatValue];
    [self.tableView reloadData];
}

#pragma mark - Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateTableViewForDynamicTypeSize];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[BNRItemCell class]
           forCellReuseIdentifier:NSStringFromClass([BNRItemCell class])];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore sharedStore] allItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSNumberFormatter *currencyFormatter;
    
    if (!currencyFormatter) {
        currencyFormatter = [[NSNumberFormatter alloc] init];
        currencyFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    }
    
    BNRItemCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BNRItemCell class])
                                                            forIndexPath:indexPath];
    
    NSArray<BNRItem *> *items = [[BNRItemStore sharedStore] allItems];
    BNRItem *currentItem = items[indexPath.row];
    
    cell.nameLabel.text = currentItem.itemName;
    cell.itemImageView.image = currentItem.thumbnail;
    cell.serialNumberLabel.attributedText = [[NSAttributedString alloc] initWithString:currentItem.serialNumber attributes:@{
        NSFontAttributeName: [UIFont italicSystemFontOfSize:12],
        NSForegroundColorAttributeName: [UIColor grayColor]
    }];
    
    NSString *formattedString = [currencyFormatter stringFromNumber: @(currentItem.valueInDollars)];
    UIColor *valueTextColor = currentItem.valueInDollars >= 50 ? [UIColor systemGreenColor] : [UIColor systemRedColor];
    
    cell.valueLabel.attributedText = [[NSAttributedString alloc] initWithString:formattedString attributes:@{
        NSForegroundColorAttributeName: valueTextColor
    }];
    
    __weak BNRItemCell *weakCell = cell;
    
    cell.actionBlock = ^{
        if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPad) {
            return;
        }
        
        BNRItemCell *strongCell = weakCell;
        
        NSString *itemKey = currentItem.itemKey;
        UIImage *image = [[BNRImageStore sharedStore] imageForKey:itemKey];
        
        if (!image) {
            return;
        }
        
        BNRImageViewController *imageViewController = [[BNRImageViewController alloc] init];
        
        imageViewController.image = image;
        imageViewController.modalPresentationStyle = UIModalPresentationPopover;
        imageViewController.popoverPresentationController.sourceView = strongCell.itemImageView;
        
        [self presentViewController:imageViewController
                           animated:YES
                         completion:nil];
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray<BNRItem *> *allItems = [[BNRItemStore sharedStore] allItems];
        BNRItem *item = allItems[indexPath.row];
        
        UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"Remove item?"
                                                                            message:@"Please confirm that you want to remove an item."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *destroyAction = [UIAlertAction actionWithTitle:@"Remove"
                                                                style:UIAlertActionStyleDestructive
                                                              handler:^(UIAlertAction * _Nonnull action) {
            [[BNRItemStore sharedStore] removeItem:item];
            
            [tableView deleteRowsAtIndexPaths:@[indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
        }];
        
        [alertViewController addAction:cancelAction];
        [alertViewController addAction:destroyAction];
        
        [self presentViewController:alertViewController animated:YES completion:nil];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[BNRItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row
                                        toIndex:destinationIndexPath.row];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Remove";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *allItems = [[BNRItemStore sharedStore] allItems];
    BNRItem *item = allItems[indexPath.row];
    
    BNRDetailViewController *detailController = [[BNRDetailViewController alloc] initForNewItem:NO];
    detailController.item = item;
    
    [self.navigationController pushViewController:detailController animated:YES];
}

#pragma mark - Actions

- (void)addNewItem:(id)sender
{
    BNRItem *newItem = [[BNRItemStore sharedStore] createItem];
    BNRDetailViewController *detailController = [[BNRDetailViewController alloc] initForNewItem:YES];
    
    detailController.item = newItem;
    detailController.dismissBlock = ^{
        NSInteger lastRow = [[[BNRItemStore sharedStore] allItems] indexOfObject:newItem];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
        
        [self.tableView insertRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
    };
    
    UINavigationController *navController = [[UINavigationController alloc]
                                             initWithRootViewController:detailController];
    navController.modalInPresentation = YES;
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)toggleEditingMode:(id)sender
{
    if (self.isEditing) {
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        
        [self setEditing:NO animated:YES];
    } else {
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        
        [self setEditing:YES animated:YES];
    }
}


@end
