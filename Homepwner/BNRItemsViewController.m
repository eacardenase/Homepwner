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
        for (int i = 0; i < 5; i++) {
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
    
    self.headerView.delegate = self;
    
    [self setupViews];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore sharedStore] allItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
                                                            forIndexPath:indexPath];
    
    NSArray<BNRItem *> *items = [[BNRItemStore sharedStore] allItems];
    BNRItem *currentItem = items[indexPath.row];
    
    cell.textLabel.text = currentItem.description;
    
    return cell;
}

- (BNRHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[BNRHeaderView alloc] initWithFrame:CGRectMake(0, 0, 0, 60)];
    }
    
    return _headerView;
}

- (void)addNewItem:(id)sender
{
    NSLog(@"addItem: tapped");
}

- (void)toggleEditingMode:(id)sender
{
    NSLog(@"toggleEditingMode: tapped");
}

- (void)setupViews
{
    self.tableView.tableHeaderView = self.headerView;
}


@end
