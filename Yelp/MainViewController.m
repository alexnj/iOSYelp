//
//  MainViewController.m
//  Yelp
//
//  Created by Alex on 6/21/14.
//  Copyright (c) 2014 alexnj. All rights reserved.
//

#import "MainViewController.h"
#import "TableViewCell.h"
#import "YelpClient.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) NSMutableArray *businessArray;
@property (nonatomic, strong) NSArray *searchResults;
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.client = [[YelpClient alloc] init];
    }
    return self;
}

- (void)loadData
{
    [self.client searchWithTerm:@"Thai" success:^(AFHTTPRequestOperation *operation, NSDictionary* data) {
        self.businessArray = data[@"businesses"];
        NSLog(@"businessArray, %@", self.businessArray);
                NSLog(@"count, %d", self.businessArray.count);
        
        
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
    
}

- (void)showFilerView {
    
}

- (void)addFilterButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self action:@selector(showFilerView) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Filter" forState:UIControlStateNormal];
    button.frame = CGRectMake(80.0, 10.0, 60.0, 40.0);
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setLeftBarButtonItem:backItem];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Point table view data source and delegates to this class itself.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.rowHeight = 95;
    
    [self loadData];
    
    self.searchDisplayController.displaysSearchBarInNavigationBar = YES;
    [self addFilterButton];

    UINib *tableViewNib = [UINib nibWithNibName:@"TableViewCell" bundle:nil];
    [self.tableView registerNib:tableViewNib forCellReuseIdentifier:@"TableViewCell"];

    [self.searchDisplayController.searchResultsTableView registerNib:tableViewNib forCellReuseIdentifier:@"TableViewCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.searchResults count];
        
    } else {
        return [self.businessArray count];
        
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell" forIndexPath:indexPath];
    
    NSDictionary *business;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        business = self.searchResults[indexPath.row];
    } else {
        business = self.businessArray[indexPath.row];
    }
    
    NSLog(@"row: %@", business);
    cell.row = business;
    
    return cell;
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF.name   contains[cd] %@",
                                    searchText];
    
    self.searchResults = [self.businessArray filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

@end
