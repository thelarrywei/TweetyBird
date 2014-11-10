//
//  User.m
//  TweetyBird
//
//  Created by Larry Wei on 10/30/14.
//  Copyright (c) 2014 Larry Wei. All rights reserved.
//

#import "User.h"
#import "TwitterClient.h"

NSString * const USER_DID_LOGIN_NOTIFICATION = @"USER_DID_LOGIN_NOTIFICATION";
NSString * const USER_DID_LOGOUT_NOTIFICATION = @"USER_DID_LOGIN_NOTIFICATION";


@interface User()

@property (nonatomic, strong) NSDictionary *dictionary;

@end

@implementation User

-(id) initWithDictionary:(NSDictionary *)dictionary {
    
    self.dictionary = dictionary;
    self = [super init];
    
    if (self) {
        self.name = dictionary[@"name"];
        self.screenname = dictionary[@"screen_name"];
        self.profileImageURL = dictionary[@"profile_image_url"];
        self.tagline = dictionary[@"description"];
        
        self.headerURL = dictionary[@"profile_background_image_url"];
        self.tweetCount = [dictionary[@"statuses_count"] intValue];
        self.followerCount = [dictionary[@"followers_count"] intValue];
        self.followingCount = [dictionary[@"friends_count"] intValue];
        
        
    }
    return self;
}

static User *_currentUser = nil;
NSString *const kCurrentUserKey = @"current user";

+ (User *)currentUser {
    if (_currentUser == nil) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentUserKey];
        if (data != nil) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            _currentUser = [[User alloc] initWithDictionary:dictionary];
        }
    }
    return _currentUser;
}



+ (void)setCurrentUser:(User *)currentUser {
    //NSLog(@"Setting current user: %@", currentUser.name);
    _currentUser = currentUser;
    //NSLog(@"Reached here");
    if (_currentUser != nil) {
        //NSLog(@"Dictionary: %@", currentUser.dictionary);
        NSData *data = [NSJSONSerialization dataWithJSONObject:currentUser.dictionary options:0 error:NULL];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kCurrentUserKey];
        NSLog(@"\nUSER IS NOT NIL\n");
        [[NSNotificationCenter defaultCenter] postNotificationName:USER_DID_LOGIN_NOTIFICATION object:nil];
    }
    else {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kCurrentUserKey];
        NSLog(@"\nUSER IS NIL\n");
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
}

@end
