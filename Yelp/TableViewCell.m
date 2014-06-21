//
//  TableViewCell.m
//  Yelp
//
//  Created by Alex on 6/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "TableViewCell.h"

@interface TableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
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
}

@end
