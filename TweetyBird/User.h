//
//  User.h
//  TweetyBird
//
//  Created by Larry Wei on 10/30/14.
//  Copyright (c) 2014 Larry Wei. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const USER_DID_LOGIN_NOTIFICATION;
extern NSString * const USER_DID_LOGOUT_NOTIFICATION;

@interface User : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenname;
@property (nonatomic, strong) NSString *profileImageURL;
@property (nonatomic, strong) NSString *tagline;

//redux
@property (nonatomic, strong) NSString *userInfo;
@property (nonatomic, strong) NSString *headerURL;

@property (nonatomic, assign) NSInteger tweetCount;
@property (nonatomic, assign) NSInteger followerCount;
@property (nonatomic, assign) NSInteger followingCount;


-(id) initWithDictionary:(NSDictionary *)dictionary;

+ (User *)currentUser;
+ (void)setCurrentUser:(User *)user;

@end
