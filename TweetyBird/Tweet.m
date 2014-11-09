//
//  Tweet.m
//  TweetyBird
//
//  Created by Larry Wei on 10/30/14.
//  Copyright (c) 2014 Larry Wei. All rights reserved.
//

#import "Tweet.h"
#import "TwitterClient.h"


@implementation Tweet

-(id) initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self ) {
        //tweet info
        self.text = dictionary[@"text"];
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        NSString *createdAtString = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        self.createdAt = [formatter dateFromString:createdAtString];
        
        //fav/retweet info
        self.userFavorited = (BOOL) [dictionary[@"favorited"] boolValue];
        self.userRetweeted = (BOOL) [dictionary[@"retweeted"] boolValue];
        
        //ids
        self.tweetID = dictionary[@"id_str"];
        if (dictionary[@"in_reply_to_status_id_str"] != nil) {
            self.replyID = dictionary[@"in_reply_to_status_id_str"];
        }
        if (dictionary[@"current_user_retweet"] != nil) {
            self.retweetID = [dictionary valueForKeyPath:@"current_user_retweet.id_str"];
        }
        if (dictionary[@"retweeted_status"] != nil) {
            self.retweet = [[Tweet alloc] initWithDictionary:dictionary[@"retweeted_status"]];
        }
        
        //counts
        self.retweetCount = [dictionary[@"retweet_count"] intValue];
        self.favoriteCount = [dictionary[@"favorite_count"] intValue];
        
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
