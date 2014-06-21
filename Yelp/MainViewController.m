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
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) NSMutableArray *businessArray;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Point table view data source and delegates to this class itself.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.rowHeight = 95;
    
    [self loadData];
    
    UINib *tableViewNib = [UINib nibWithNibName:@"TableViewCell" bundle:nil];
    [self.tableView registerNib:tableViewNib forCellReuseIdentifier:@"TableViewCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.businessArray.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell" forIndexPath:indexPath];
    
    NSDictionary *business = self.businessArray[indexPath.row];
    cell.row = business;
    
    NSLog(@"row: %@", business);
    
    return cell;
}
@end
