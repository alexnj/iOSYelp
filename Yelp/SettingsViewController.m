//
//  SettingsViewController.m
//  Yelp
//
//  Created by Alex on 6/21/14.
//  Copyright (c) 2014 alexnj. All rights reserved.
//

#import "SettingsViewController.h"

typedef enum { Switch, Dropdown } SettingUIType;

@interface SettingsViewController ()
@property (strong, nonatomic) IBOutlet UITableViewCell *cellTypeSegmented;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellTypeSwitch;
@property (strong, nonatomic) NSArray *settingSections;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableIndexSet *expandedSections;
@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialize expanded sections set.
    self.expandedSections = [[NSMutableIndexSet alloc] init];
    
    self.settingSections = @[
                                @{
                                        @"caption": @"Category",
                                        @"settings": @[
                                                @{
                                                    @"key": @"category",
                                                    @"type": @(Dropdown)
                                                    }
                                        ],
                                        },
                                @{
                                        @"caption": @"Sort",
                                        @"settings": @[
                                                @{
                                                    @"key": @"sort",
                                                    @"type": @(Dropdown)
                                                    }
                                                ]
                                        },
                                @{
                                    @"caption": @"Radius",
                                    @"settings": @[
                                            @{
                                                @"key": @"radius",
                                                @"type": @(Dropdown)
                                                }
                                            ]
                                    },
                                @{
                                    @"caption": @"General features",
                                    @"settings": @[
                                            @{
                                                @"key": @"deals",
                                                @"caption": @"Deals",
                                                @"type": @(Switch)
                                                }
                                            ]
                                    }
                                ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (NSArray *)sortOptions
{
    static NSArray* _options;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _options = @[
                     @{ @"key": @0, @"caption": @"Best matched (default)" },
                     @{ @"key": @1, @"caption": @"Distance" },
                     @{ @"key": @2, @"caption": @"Highest rated" }
                     ];
    });
    return _options;
}

- (NSInteger)countDropdownOptionsBySettingKey: (NSString*)key {
    NSInteger count = 0;
    
    if ([key isEqualToString:@"radius"]) {
        count = [[self class] sortOptions].count;
    }
    
    if ([key isEqualToString:@"sort"]) {
        count = [[self class] sortOptions].count;
    }
    
    if ([key isEqualToString:@"category"]) {
        count = [[self class] sortOptions].count;
    }
    
    return count;
}

- (NSArray*)dropdownOptionsBySettingKey: (NSString*)key {
    NSArray* options = @[];
    
    if ([key isEqualToString:@"radius"]) {
        options = [[self class] sortOptions];
    }
    
    if ([key isEqualToString:@"sort"]) {
        options = [[self class] sortOptions];
    }
    
    if ([key isEqualToString:@"category"]) {
        options = [[self class] sortOptions];
    }
    
    return options;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Is the current section a collapsible one?
    if ([self tableView:tableView canCollapseSection:indexPath.section]) {

        // Is this the first row that was selected?
        if (!indexPath.row) {
            NSInteger section = indexPath.section;
        
            // only first row toggles exapand/collapse
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            // Calculate final number of rows depending on current state.
            NSInteger rows;
            BOOL isCurrentlyExpanded = [self.expandedSections containsIndex:section];
            if (isCurrentlyExpanded) {
                rows = [self tableView:tableView numberOfRowsInSection:section];
                [self.expandedSections removeIndex:section];
            }
            else {
                [self.expandedSections addIndex:section];
                rows = [self tableView:tableView numberOfRowsInSection:section];
            }
            
            // Prepare row indices for insertion (expansion).
            NSMutableArray *tmpArray = [NSMutableArray array];
            for (int i=1; i<rows; i++) {
                NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:i inSection:section];
                [tmpArray addObject:tmpIndexPath];
            }
            
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            // Expand or remove rows as necessary.
            if (isCurrentlyExpanded) {
                [tableView deleteRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationTop];
            }
            else {
                [tableView insertRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationTop];
            }
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Check if this is asking for a collapsible section's row.
    if (![self tableView:tableView canCollapseSection:indexPath.section]) {
        // Asking for a non-collapsible section's setting.
        NSDictionary* setting = self.settingSections[indexPath.section][@"settings"][indexPath.row];
        NSNumber* settingType = setting[@"type"];
        switch ([settingType intValue]) {
            case Switch:
                return self.cellTypeSwitch;
                break;
        }
    }
    
    // Collapsible section handler.
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Get options list for this setting.
    // Zero'th index because expansion sections don't intend to
    // include multiple settings within a section.
    NSDictionary* setting = self.settingSections[indexPath.section][@"settings"][0];
    NSString* settingKey = setting[@"key"];
    NSArray* options = [self dropdownOptionsBySettingKey:settingKey];
    
    if ([self tableView:tableView canCollapseSection:indexPath.section]) {
        cell.textLabel.text = options[indexPath.row][@"caption"];
        if (!indexPath.row) {
            // First row.
            cell.accessoryView = nil;
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    else {
        cell.accessoryView = nil;
        cell.textLabel.text = @"Normal Cell";
        
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self tableView:tableView canCollapseSection:section]) {
        if ([self.expandedSections containsIndex:section]) {
            NSArray *settings = self.settingSections[section][@"settings"];
            NSDictionary* setting = settings[0];
            NSString* key = setting[@"key"];
            return [self countDropdownOptionsBySettingKey:key];
        }

        return 1; // Show only first row when collapsed (current setting).
    }
    
    NSArray* settings = self.settingSections[section][@"settings"];
    return settings.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.settingSections.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.settingSections[section][@"caption"];
}

- (BOOL)tableView:(UITableView *)tableView canCollapseSection:(NSInteger)section {
    NSArray *settings = self.settingSections[section][@"settings"];
    NSDictionary* setting = settings[0];
    NSNumber* settingType = setting[@"type"];
    
    if ([settingType intValue] == Dropdown) {
        return YES;
    }
    
    return NO;
}


@end
