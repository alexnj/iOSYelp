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
@property (strong, nonatomic) NSUserDefaults* defaults;
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
    self.defaults = [NSUserDefaults standardUserDefaults];
    
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
                     @{ @"key": @"0", @"caption": @"Best matched (default)" },
                     @{ @"key": @"1", @"caption": @"Distance" },
                     @{ @"key": @"2", @"caption": @"Highest rated" }
                     ];
    });
    return _options;
}

+ (NSArray *)distanceOptions
{
    static NSArray* _options;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _options = @[
                     @{ @"key": @"", @"caption": @"Auto" },
                     @{ @"key": @"482", @"caption": @"0.3 miles" },
                     @{ @"key": @"1609", @"caption": @"1 mile" },
                     @{ @"key": @"8046", @"caption": @"5 miles" },
                     @{ @"key": @"32186", @"caption": @"20 miles" }
                     ];
    });
    return _options;
}

+ (NSArray *)categoryOptions
{
    static NSArray* _options;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _options = @[
                     @{@"key": @"", @"caption": @"All"},
                     @{@"key": @"active", @"caption": @"Active Life"},
                     @{@"key": @"arts", @"caption": @"Arts & Entertainment"},
                     @{@"key": @"auto", @"caption": @"Automotive"},
                     @{@"key": @"beautysvc", @"caption": @"Beauty & Spas"},
                     @{@"key": @"education", @"caption": @"Education"},
                     @{@"key": @"eventservices", @"caption": @"Event Planning & Services"},
                     @{@"key": @"financialservices", @"caption": @"Financial Services"},
                     @{@"key": @"food", @"caption": @"Food"},
                     @{@"key": @"health", @"caption": @"Health & Medical"},
                     @{@"key": @"diagnosticservices", @"caption": @"Diagnostic Services"},
                     @{@"key": @"physicians", @"caption": @"Doctors"},
                     @{@"key": @"homeservices", @"caption": @"Home Services"},
                     @{@"key": @"hotelstravel", @"caption": @"Hotels & Travel"},
                     @{@"key": @"nightlife", @"caption": @"Nightlife"},
                     @{@"key": @"restaurants", @"caption": @"Restaurants"},
                     @{@"key": @"shopping", @"caption": @"Shopping"}
                     ];
    });
    return _options;
}


- (NSInteger)countDropdownOptionsBySettingKey: (NSString*)key {
    NSInteger count = 0;
    
    if ([key isEqualToString:@"radius"]) {
        count = [[self class] distanceOptions].count;
    }
    
    if ([key isEqualToString:@"sort"]) {
        count = [[self class] sortOptions].count;
    }
    
    if ([key isEqualToString:@"category"]) {
        count = [[self class] categoryOptions].count;
    }
    
    return count;
}

- (NSArray*)dropdownOptionsBySettingKey: (NSString*)key {
    NSArray* options = @[];
    
    if ([key isEqualToString:@"radius"]) {
        options = [[self class] distanceOptions];
    }
    
    if ([key isEqualToString:@"sort"]) {
        options = [[self class] sortOptions];
    }
    
    if ([key isEqualToString:@"category"]) {
        options = [[self class] categoryOptions];
    }
    
    return options;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Is the current section a collapsible one?
    if ([self tableView:tableView canCollapseSection:indexPath.section]) {
        NSInteger section = indexPath.section;

        // Is this already collapsed? Then expand.
        if (![self.expandedSections containsIndex:indexPath.section]) {
            
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
            
            // Expand or remove rows as necessary.
            if (isCurrentlyExpanded) {
                [tableView deleteRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationTop];
            }
            else {
                [tableView insertRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationTop];

                // Refresh row to update setting.
                [self.tableView beginUpdates];
                NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
                [self.tableView reloadRowsAtIndexPaths:@[tmpIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView endUpdates];

            }
        }
        else {
            // Expanded section. Means we have a new preference.

            // Current selection?
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            NSString* caption = cell.textLabel.text;
            
            // Which setting are we catering to?
            NSDictionary* setting = self.settingSections[indexPath.section][@"settings"][0];
            NSString* settingKey = setting[@"key"];
            NSArray* options = [self dropdownOptionsBySettingKey:settingKey];

            for(NSDictionary* optionPair in options) {
                if ([optionPair[@"caption"] isEqualToString:caption]) {
                    [self.defaults setObject:optionPair[@"key"] forKey:settingKey];
                    [self.defaults synchronize];
                }
            }
            
            NSInteger rows;
            rows = [self tableView:tableView numberOfRowsInSection:indexPath.section];
            [self.expandedSections removeIndex:section];
            // Prepare row indices for insertion (expansion).
            NSMutableArray *tmpArray = [NSMutableArray array];
            for (int i=1; i<rows; i++) {
                NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:i inSection:section];
                [tmpArray addObject:tmpIndexPath];
            }
            
            // Expand or remove rows as necessary.
            [tableView deleteRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationTop];

            
            // Refresh row to update setting.
            [self.tableView beginUpdates];
            NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
            [self.tableView reloadRowsAtIndexPaths:@[tmpIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
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
        if (![self.expandedSections containsIndex:indexPath.section]) {
            // Collapsed stage. Show current setting.
            if( [self.defaults objectForKey:settingKey] != nil){
                for(NSDictionary* optionPair in options) {
                    if ([optionPair[@"key"] isEqualToString:[self.defaults objectForKey:settingKey]]) {
                        NSLog(@"Selected option resurface %@", optionPair);
                        cell.textLabel.text = optionPair[@"caption"];
                        
                        cell.accessoryView = nil;
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    }
                }
            }
        }
        else {
            cell.textLabel.text = options[indexPath.row][@"caption"];
            if( [self.defaults objectForKey:settingKey] != nil){
                if ([options[indexPath.row][@"key"] isEqualToString:[self.defaults objectForKey:settingKey]]) {
                    cell.accessoryView = nil;
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
                else {
                    cell.accessoryView = nil;
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            }
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
