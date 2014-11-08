//
//  TwitterClient.h
//  TweetyBird
//
//  Created by Larry Wei on 10/29/14.
//  Copyright (c) 2014 Larry Wei. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"
#import "Tweet.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager



+ (TwitterClient *) sharedInstance;

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion;

- (void)openURL:(NSURL *)url;

- (void)tweetsFromTimeline:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion;

- (void) favorite:(long)tweetID completion:(void (^)(Tweet *, NSError *))completion;

- (void) retweet:(long)tweetID completion:(void (^)(Tweet *, NSError *))completion;

- (void) reply:(long)tweetID completion:(void (^)(Tweet *, NSError *))completion;
- (void) postTweet:(NSString *)composedTweet completion:(void (^)(Tweet *, NSError *))completion;
- (void) postTweetWithParams:(NSDictionary *)params completion:(void (^)(Tweet *, NSError *))completion;
@end
