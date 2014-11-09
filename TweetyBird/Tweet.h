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

//tweet info
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) User *user;

//fav/retweet info
@property (nonatomic) BOOL userFavorited;
@property (nonatomic) BOOL userRetweeted;

//counts
@property (nonatomic, assign) NSInteger retweetCount;
@property (nonatomic, assign) NSInteger favoriteCount;


//ids
@property (nonatomic, strong) NSString *tweetID;
@property (nonatomic, strong) NSString *replyID;
@property (nonatomic, strong) NSString *retweetID;

//Keep track of retweets
@property (nonatomic, strong) Tweet *retweet;





-(id) initWithDictionary:(NSDictionary *)dictionary;

+(NSArray *)tweetsWithArray:(NSArray *)array;

@end
