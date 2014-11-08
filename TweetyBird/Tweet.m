//
//  Tweet.m
//  TweetyBird
//
//  Created by Larry Wei on 10/30/14.
//  Copyright (c) 2014 Larry Wei. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

-(id) initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self ) {
        self.text = dictionary[@"text"];
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        self.retweetID = [[dictionary valueForKey:@"current_user_retweet.id"] longValue];
        self.tweetID = [dictionary[@"id"] longValue];
        self.isFavorited = (BOOL) [dictionary[@"favorited"] boolValue];
        self.isRetweeted = (BOOL) [dictionary[@"retweeted"] boolValue];
        
        NSString *createdAtString = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
    
        self.createdAt = [formatter dateFromString:createdAtString];
                               
    }
    return self;
}

+(NSArray *) tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [NSMutableArray array];
    for (NSDictionary *dictionary in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dictionary]];
    }
    return tweets;
}
@end
