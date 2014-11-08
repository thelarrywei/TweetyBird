//
//  HomeViewController.m
//  TweetyBird
//
//  Created by Larry Wei on 10/30/14.
//  Copyright (c) 2014 Larry Wei. All rights reserved.
//

#import "HomeViewController.h"
#import "TwitterClient.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+TimeAgo.h"
#import "composerViewController.h"



@interface HomeViewController ()

@property (nonatomic, retain) UIBarButtonItem *logoutButton;
@property (nonatomic, retain) UIBarButtonItem *composeButton;
@property (strong, nonatomic) NSMutableArray *tweets;
@property (strong, nonatomic) UIRefreshControl *refreshControl;



@end



@implementation HomeViewController

- (NSString *)formatDate:(NSDate *)date {
    NSString *ago = [date dateTimeAgo];
    return [ago stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (void) onLogoutButton{
    [User setCurrentUser:nil];
    [[TwitterClient sharedInstance].requestSerializer removeAccessToken];
    NSLog(@"Logging out");
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    

}

- (void)refreshTweets {
    [[TwitterClient sharedInstance] tweetsFromTimeline:nil completion:^(NSArray *tweets, NSError *error) {
        [self.tweets addObjectsFromArray:tweets];
        /*for (Tweet *t in tweets) {
         //NSLog(@"TWEET: %@", t.text);
         }*/
        
        [self.tableView reloadData];
    }];
    [self.refreshControl endRefreshing];
}

- (void) onComposeButton {
    composerViewController *vc = [[composerViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.353 green:0.69 blue:1 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.Title = @"Twitter";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    self.logoutButton =[[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onLogoutButton)];
    self.navigationItem.leftBarButtonItem = self.logoutButton;
    
    self.composeButton =[[UIBarButtonItem alloc] initWithTitle:@"Compose" style:UIBarButtonItemStylePlain target:self action:@selector(onComposeButton)];
    self.navigationItem.rightBarButtonItem = self.composeButton;

    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //Set up custom cell
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil]forCellReuseIdentifier:@"TweetCell"];
    
    self.tweets = [[NSMutableArray alloc] init];
    [self reloadInputViews];
    [[TwitterClient sharedInstance] tweetsFromTimeline:nil completion:^(NSArray *tweets, NSError *error) {
        [self.tweets addObjectsFromArray:tweets];
        /*for (Tweet *t in tweets) {
         //NSLog(@"TWEET: %@", t.text);
         }*/
        
        [self.tableView reloadData];
    }];


}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSLog(@"Number of table cells populated %ld", self.businesses.count);
    return self.tweets.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    
    Tweet *tweet = self.tweets[indexPath.row];
    cell.tweet = tweet;
    
    //favorite
    if (tweet.isFavorited) {
        [cell.favoriteButton.imageView setImage:[UIImage imageNamed:@"favorite_on"]];
    }
    
    //retweet
    if (tweet.isRetweeted) {
        [cell.retweetButton.imageView setImage:[UIImage imageNamed:@"retweet_on"]];
    }
    cell.nameLabel.text = tweet.user.name;
    cell.handleLabel.text = [NSString stringWithFormat:@"@%@", tweet.user.screenname];
    
    cell.timestampLabel.text = [self formatDate:tweet.createdAt];
    
    //Set up image
    cell.userImage.layer.cornerRadius = 3;
    cell.userImage.clipsToBounds = YES;
    [cell.userImage setImageWithURL:[NSURL URLWithString:tweet.user.profileImageURL]];
    
    //set up tweet
    cell.tweetLabel.text = tweet.text;
    
    return cell;
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
