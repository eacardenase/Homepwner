//
//  BNRAssetTypeViewController.m
//  Homepwner
//
//  Created by Edwin Cardenas on 3/9/25.
//

#import "BNRAssetTypeViewController.h"
#import "BNRItem.h"
#import "BNRItemStore.h"

@implementation BNRAssetTypeViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Asset Type";
    
    [self.tableView registerClass:UITableViewCell.class
           forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return BNRItemStore.sharedStore.allAssetTypes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)
                                                            forIndexPath:indexPath];
    
    NSArray *allAssets = BNRItemStore.sharedStore.allAssetTypes;
    NSManagedObject *assetType = allAssets[indexPath.row];
    
    NSString *assetLabel = [assetType valueForKey:@"label"];
    cell.textLabel.text = assetLabel;
    
    if (assetType == self.item.assetType) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    NSArray *allAssets = BNRItemStore.sharedStore.allAssetTypes;
    
    NSManagedObject *assetType = allAssets[indexPath.row];
    self.item.assetType = assetType;
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
