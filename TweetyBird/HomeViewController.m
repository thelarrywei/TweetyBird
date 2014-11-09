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
@property (strong, nonatomic) NSArray *tweets;
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
        self.tweets = tweets;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    //[self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil]forCellReuseIdentifier:@"TweetCell"];
    
    [self refreshTweets];


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
    [cell loadTweet:self.tweets[indexPath.row]];
    cell.delegate = self;
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
