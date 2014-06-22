//
//  TableViewCell.m
//  Yelp
//
//  Created by Alex on 6/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "TableViewCell.h"

@interface TableViewCell ()
@property (strong, nonatomic) IBOutlet UILabel *address;
@property (strong, nonatomic) IBOutlet UIImageView *thumbnail;
@property (strong, nonatomic) IBOutlet UIImageView *ratingImage;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *distance;
@property (strong, nonatomic) IBOutlet UILabel *expense;
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
    self.address.text = row[@"location"][@"display_address"][0];
    self.distance.text = [NSString stringWithFormat:@"%@", row[@"review_count"]];
    self.expense.text = @"";
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:row[@"image_url"]]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        UIImage *image = [UIImage imageWithData:data];
        
        [self setImageOnMainThread:self.thumbnail image:image];
    }];
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:row[@"rating_img_url"]]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        UIImage *image = [UIImage imageWithData:data];
        
        [self setImageOnMainThread:self.ratingImage image:image];
    }];
}

- (void)setImageOnMainThread: (UIImageView *)imageView image:(UIImage *)image
{
    if (!image)
        return;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CATransition *transition = [CATransition animation];
        transition.type = kCATransitionFade;
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [imageView.layer addAnimation:transition forKey:nil];
        
        imageView.image = image;
    });
}
@end
