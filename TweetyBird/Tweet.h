//
//  Tweet.h
//  TweetyBird
//
//  Created by Larry Wei on 10/30/14.
//  Copyright (c) 2014 Larry Wei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "user.h"

@interface Tweet : NSObject

@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) User *user;
@property (nonatomic) BOOL isFavorited;
@property (nonatomic) BOOL isRetweeted;
@property (nonatomic) long tweetID;
@property (nonatomic) long retweetID;

-(id) initWithDictionary:(NSDictionary *)dictionary;

+(NSArray *)tweetsWithArray:(NSArray *)array;
@end
