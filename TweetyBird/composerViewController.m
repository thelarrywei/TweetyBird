//
//  composerViewController.m
//  TweetyBird
//
//  Created by Larry Wei on 11/2/14.
//  Copyright (c) 2014 Larry Wei. All rights reserved.
//

#import "composerViewController.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"

@interface composerViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextView *composeTextField;


@end

@implementation composerViewController
- (IBAction)onCancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onTweetButton:(id)sender {
    if (![self.composeTextField.text isEqualToString:@""]) {
        if (self.replyID == 0) {
            [[TwitterClient sharedInstance] postTweet:self.composeTextField.text completion:^(Tweet *tweet, NSError *error) {
                NSLog(@"Completed tweet");
            }];
        }
        else {
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                     self.composeTextField.text, @"status",
                                     self.replyID, @"in_reply_to_status_id", nil];
            [[TwitterClient sharedInstance] postTweetWithParams:params completion:^(Tweet *tweet, NSError *error) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            
        }
    }
    else {
        //TODO GIVE USER WARNING ABOUT EMPTY TWEET.
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) textViewDidBeginEditing:(UITextView *)textView {
    textView.text = @"";
}

- (void) textViewDidChange:(UITextView *)textView {
    self.composeTextField.text = textView.text;
    //NSLog(@"NEW TWEET: %@", self.composeTextField.text);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //textview delegate
    self.composeTextField.delegate = self;
    
    
    //set up image, name, etc
    User *user = [User currentUser];
    self.nameLabel.text = user.name;
    self.handleLabel.text = [NSString stringWithFormat:@"@%@", user.screenname];
    [self.userImage setImageWithURL:[NSURL URLWithString:user.profileImageURL]];
    self.userImage.layer.cornerRadius = 3;
    self.userImage.clipsToBounds = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
