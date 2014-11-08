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

@implementation TweetCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onReplyButton:(id)sender {
    composerViewController *vc = [[composerViewController alloc] init];
    vc.replyID = self.tweet.tweetID;
    [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
    
}
- (IBAction)onRetweetButton:(id)sender {
    [[TwitterClient sharedInstance] retweet:self.tweet.tweetID completion:^(Tweet *tweet, NSError *error) {
        NSLog(@"Retweeted");
        [self.retweetButton.imageView setImage:[UIImage imageNamed:@"retweet_on"]];
    }];

}
- (IBAction)onFavoriteButton:(id)sender {
    [[TwitterClient sharedInstance] favorite:self.tweet.tweetID completion:^(Tweet * tweet, NSError * error) {
        NSLog(@"Favorited");
        
        [self.favoriteButton.imageView setImage:[UIImage imageNamed:@"favorite_on"]];
    }];
}


@end
