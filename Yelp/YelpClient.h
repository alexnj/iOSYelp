//
//  YelpClient.h
//  Yelp
//
//  Created by Alex on 6/21/14.
//  Copyright (c) 2014 alexnj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDBOAuth1RequestOperationManager.h"

@interface YelpClient : BDBOAuth1RequestOperationManager

- (id)init;

- (AFHTTPRequestOperation *)searchWithTerm:(NSString *)term sort:(NSString*)sort category:(NSString*)category radius:(NSString*)radius deals:(NSString*)deals success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
