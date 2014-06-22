//
//  SettingsViewController.m
//  Yelp
//
//  Created by Alex on 6/21/14.
//  Copyright (c) 2014 alexnj. All rights reserved.
//

#import "SettingsViewController.h"

typedef enum { Expando, Switch, Dropdown } SettingUIType;

@interface SettingsViewController ()
@property (strong, nonatomic) IBOutlet UITableViewCell *cellTypeSegmented;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellTypeSwitch;
@property (strong, nonatomic) NSArray *settingSections;
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
    
    self.settingSections = @[
                                @{
                                        @"caption": @"Category",
                                        @"settings": @[
                                                @{
                                                    @"key": @"category",
                                                    @"type": @(Expando)
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary* setting = self.settingSections[indexPath.section][@"settings"][indexPath.row];
    NSNumber* settingType = setting[@"type"];
    switch ([settingType intValue]) {
        case Switch:
            return self.cellTypeSwitch;
            break;
    }
    return self.cellTypeSegmented;
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray* settings = self.settingSections[section][@"settings"];
    return settings.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.settingSections.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.settingSections[section][@"caption"];
}

@end
