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
@property (weak, nonatomic) IBOutlet UIImageView *ratingImage;
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
