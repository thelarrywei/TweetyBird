//
//  TweetCell.h
//  TweetyBird
//
//  Created by Larry Wei on 10/30/14.
//  Copyright (c) 2014 Larry Wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@class TweetCell;
@protocol TweetCellDelegate <NSObject>

//- (void)TweetCell:(TweetCell *)cell onReplyButtonClicked:(NSString *)replyHandle tweetReplyID:(long)replyID;
- (void)onProfileTapped:(User *)user;

@end
@interface TweetCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *retweetedButton;
@property (weak, nonatomic) IBOutlet UILabel *retweetedLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userImageTopMargin;
@property (weak, nonatomic) IBOutlet UILabel *retweetCount;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCount;

@property (strong, nonatomic) Tweet *tweet;
@property (strong, nonatomic) Tweet *displayTweet;

@property (nonatomic, weak) id <TweetCellDelegate> delegate;
- (void) loadTweet:(Tweet *)tweet;
@end
