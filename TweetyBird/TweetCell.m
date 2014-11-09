//
//  TweetCell.m
//  TweetyBird
//
//  Created by Larry Wei on 10/30/14.
//  Copyright (c) 2014 Larry Wei. All rights reserved.
//

#import "TweetCell.h"
#import "TwitterClient.h"
#import "composerViewController.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+TimeAgo.h"

@implementation TweetCell



- (void)awakeFromNib {
    
    //cell.tweet = tweet;
   
}
- (IBAction)onRetweetButton:(id)sender {
    self.tweet.userRetweeted = !self.tweet.userRetweeted;
    [[TwitterClient sharedInstance] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if (self.tweet.userRetweeted) {
            if (tweet != nil) {
                self.tweet.retweetID = tweet.tweetID;
                NSLog(@"Changing retweet ID to %@", self.tweet.retweetID);
            }
            self.tweet.retweetCount++;
        }
        else {
            self.tweet.retweetCount--;
        }
        [self updateImages];
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onReplyButton:(id)sender {
    NSLog(@"Button pressed");
    composerViewController *vc = [[composerViewController alloc] init];
    //vc.replyID = self.tweet.tweetID;
    [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
    
}

- (IBAction)onFavoriteButton:(id)sender {
    self.displayTweet.userFavorited = !self.displayTweet.userFavorited;
    [[TwitterClient sharedInstance] favorite:self.displayTweet completion:^(Tweet * tweet, NSError * error) {
        if (tweet != nil) {
            if (self.displayTweet.userFavorited) {
                self.displayTweet.favoriteCount++;
            }
            else {
                self.displayTweet.favoriteCount--;
            }
            [self updateImages];
        }
    }];
}

- (void) updateImages{
    UIImage* retweet_off= [UIImage imageNamed:@"retweet"];
    UIImage* retweet_on = [UIImage imageNamed:@"retweet_on"];
    
    UIImage* favorite_off = [UIImage imageNamed:@"favorite"];
    UIImage* favorite_on = [UIImage imageNamed:@"favorite_on"];
    
    
    if (self.displayTweet.userFavorited) {
        NSLog(@"Is favorited");
        [self.favoriteButton setImage:favorite_on forState:UIControlStateNormal];
    } else {
        NSLog(@"Is not favorited");
        [self.favoriteButton setImage:favorite_off forState:UIControlStateNormal];
    }
    
    if (self.tweet.userRetweeted) {
        NSLog(@"Is retweeted");
        [self.retweetButton setImage:retweet_on forState:UIControlStateNormal];
    } else {
        NSLog(@"Is not retweeted");
        [self.retweetButton setImage:retweet_off forState:UIControlStateNormal];
    }
    
    //counts
    if (self.tweet.retweetCount > 0) {
        self.retweetCount.text = [NSString stringWithFormat:@"%ld", self.tweet.retweetCount];
        self.retweetCount.hidden = NO;
        NSLog(@"%@ shows %ld retweets", self.displayTweet.user.name, self.tweet.retweetCount);
    }
    else {
        self.retweetCount.hidden = YES;
    }
    if (self.displayTweet.favoriteCount > 0) {
        self.favoriteCount.text = [NSString stringWithFormat:@"%ld", self.displayTweet.favoriteCount];
        self.favoriteCount.hidden = NO;
        NSLog(@"%@ shows %ld favorites", self.displayTweet.user.name, self.displayTweet.favoriteCount);
    }
    else {
        self.favoriteCount.hidden = YES;
    }
}
    
- (void)loadTweet:(Tweet *)tweet {
    _tweet = tweet;
    if (tweet.retweet != nil) {
        self.displayTweet = tweet.retweet;
    }
    else {
        self.displayTweet = tweet;
    }
    
    //adjust the view for retweets
    if (tweet.retweet != nil) {
        self.displayTweet = tweet.retweet;
        self.userImageTopMargin.constant = 15;
        self.retweetedLabel.text = [NSString stringWithFormat:@"%@ retweeted", tweet.user.name];
        NSLog(@"%@, %@", tweet.user.name, tweet.user.screenname);
        self.retweetedButton.hidden = NO;
        self.retweetedLabel.hidden = NO;
    }
    else {
        self.displayTweet = tweet;
        self.userImageTopMargin.constant = 0;
        self.retweetedButton.hidden = YES;
        self.retweetedLabel.hidden = YES;
    }

    [self updateImages];
    
    self.nameLabel.text = self.displayTweet.user.name;
    self.handleLabel.text = [NSString stringWithFormat:@"@%@", self.displayTweet.user.screenname];
    
    
    
    //self.timestampLabel.text = [self formatDate:self.tweet.createdAt];
    
    //Set up image
    self.userImage.layer.cornerRadius = 3;
    self.userImage.clipsToBounds = YES;
    [self.userImage setImageWithURL:[NSURL URLWithString:self.displayTweet.user.profileImageURL]];
    
    //set up tweet
    self.tweetLabel.text = self.displayTweet.text;
    
    //time
    self.timestampLabel.text = [self getTimeAgo:self.tweet.createdAt];

}

- (NSString *)getTimeAgo:(NSDate *)date {
    return [[date dateTimeAgo] stringByReplacingOccurrencesOfString:@" " withString:@""];
}
@end
