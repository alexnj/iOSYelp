//
//  TableViewCell.m
//  Yelp
//
//  Created by Alex on 6/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "TableViewCell.h"

@interface TableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UILabel *expense;
@end

@implementation TableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRow:(NSDictionary *)row {
    self.title.text = row[@"name"];
    self.address.text = row[@"location"][@"address"][0];
}

@end
