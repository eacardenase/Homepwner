//
//  BNRItemsViewController.m
//  Homepwner
//
//  Created by Edwin Cardenas on 3/02/25.
//

#import "BNRItemsViewController.h"
#import "BNRItemStore.h"
#import "BNRItem.h"

@interface BNRItemsViewController ()

- (instancetype)init NS_DESIGNATED_INITIALIZER;

@end

@implementation BNRItemsViewController


- (instancetype)init
{
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        for (int i = 0; i < 15; i++) {
            [[BNRItemStore sharedStore] createItem];
        }
    }

    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [[self itemsWithValueLessThan50] count];
    }
    
    return [[self itemsWithValueGreaterThan50] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"<= $50";
    } else {
        return @"> $50";
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
                                                            forIndexPath:indexPath];
    
    NSArray<BNRItem *> *items;
    
    if (section == 0) {
        items = [self itemsWithValueLessThan50];
    } else {
        items = [self itemsWithValueGreaterThan50];
    }
    
    BNRItem * currentItem = items[indexPath.row];
    
    cell.textLabel.text = currentItem.description;
    
    return cell;
}

- (NSArray *)itemsWithValueLessThan50
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"valueInDollars < 50"];
    return [[[BNRItemStore sharedStore] allItems] filteredArrayUsingPredicate:predicate];
}

- (NSArray *)itemsWithValueGreaterThan50
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"valueInDollars > 50"];
    return [[[BNRItemStore sharedStore] allItems] filteredArrayUsingPredicate:predicate];
}


@end
