//
//  TwitterClient.m
//  TweetyBird
//
//  Created by Larry Wei on 10/29/14.
//  Copyright (c) 2014 Larry Wei. All rights reserved.
//

#import "TwitterClient.h"


NSString * const kTwitterConsumerKey = @"s1Rrme6f3c0GAvUEEgppuYOM3";
NSString * const kTwitterConsumerSecret = @"HoNmga2EsueIHKhiLdErtbywpKNLbTga93DqyAxn3q7zyqrPZ2";
NSString * const kTwitterBaseURL = @"https://api.twitter.com";



@interface TwitterClient()
@property (nonatomic, strong) void (^loginCompletion)(User *, NSError *);
@end

@implementation TwitterClient

+ (TwitterClient *) sharedInstance {
    static TwitterClient *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            NSLog(@"init shared instance");
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kTwitterBaseURL] consumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret];
        }
    });
    
    return instance;
}

- (void) loginWithCompletion:(void (^)(User *, NSError *))completion {
    self.loginCompletion = completion;
    
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"tweetybird://oauth"] scope:nil success:^(BDBOAuthToken *requestToken) {
        NSLog(@"Got the request token");
        
        NSURL *authURL = [NSURL URLWithString: [NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
        [[UIApplication sharedApplication] openURL:authURL];
        
    } failure:^(NSError *error) {
        NSLog(@"Failed request token");
        self.loginCompletion(nil, error);
    }];

    
}


- (void)openURL:(NSURL *)url {
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuthToken tokenWithQueryString:url.query] success:^(BDBOAuthToken *accessToken) {
        NSLog(@"Successfully got access token!");
        
        NSLog(@"URL QUERY: %@", url.query);
        //save the access token
        [self.requestSerializer saveAccessToken:accessToken];
        
        [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //NSLog(@"Current user: %@", responseObject);        
            User *user = [[User alloc] initWithDictionary:responseObject];
            self.loginCompletion(user, nil);
            [User setCurrentUser:user];
            NSLog(@"Welcome, %@", user.name);
            
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Could not very current user");
            self.loginCompletion(nil, error);
    
        }];
        
    } failure:^(NSError *error) {
        NSLog(@"Did not receive access token");
    }];
}

- (void)tweetsFromTimeline:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion {
  [self GET:@"1.1/statuses/home_timeline.json?include_my_retweet=1" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            NSArray *tweets = [Tweet tweetsWithArray:responseObject];
            completion(tweets, nil);
            NSLog(@"REPONSE: %@", responseObject);
        } else {
            // TODO: learn how to generate a useful NSError
            NSLog(@"response failed");
            completion(nil, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}


- (void) postTweet:(NSString *)composedTweet completion:(void (^)(Tweet *, NSError *))completion {
    NSDictionary * params = [NSDictionary dictionaryWithObject:composedTweet forKey:@"status"];
    [self postTweetWithParams:params completion:completion];
}

- (void) postTweetWithParams:(NSDictionary *)params completion:(void (^)(Tweet *, NSError *))completion {
    [self POST:@"1.1/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Tweet *t = [[Tweet alloc] initWithDictionary:responseObject];
        completion (t, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}
- (void) favorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion {
    NSString *favoriteURLString;
    if (tweet.userFavorited) {
        favoriteURLString = [NSString stringWithFormat:@"1.1/favorites/create.json?id=%@", tweet.tweetID];
    }
    else {
        favoriteURLString = [NSString stringWithFormat:@"1.1/favorites/destroy.json?id=%@", tweet.tweetID];
    }
    [self POST:favoriteURLString parameters:nil
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
           NSLog(@"Succeded in favoriting");
           Tweet *t = [[Tweet alloc] initWithDictionary:responseObject];
           completion (t, nil);
       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           NSLog(@"Tried to favorite but did not succeed");
           completion (nil, error);
       }];
}

- (void) retweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion {
    NSString *retweetURLString;
    if (tweet.userRetweeted) {
        retweetURLString = [NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", tweet.tweetID];
        NSLog(@"********************RETWEET");
    }
    else {
        retweetURLString = [NSString stringWithFormat:@"1.1/statuses/destroy/%@.json", tweet.retweetID];
        NSLog(@"********************DESTROYING RETWEET");
    }
    [self POST: retweetURLString parameters:nil
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
           NSLog(@"Succeded in retweeting");
           Tweet *t = [[Tweet alloc] initWithDictionary:responseObject];
           completion (t, nil);
       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           NSLog(@"Tried to retweet but did not succeed");
           completion (nil, error);
       }];

}


@end
