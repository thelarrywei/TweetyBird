//
//  ProfileViewController.m
//  TweetyBird
//
//  Created by Larry Wei on 11/9/14.
//  Copyright (c) 2014 Larry Wei. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"
#import "User.h"
#import "ProfileCell.h"
#import "TwitterClient.h"
#import "composerViewController.h"
#import "TweetCell.h"


@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *tweets;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopConstraint;

@property (nonatomic, strong) User *user;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeightConstrant;

@property (nonatomic, retain) UIBarButtonItem *logoutButton;
@property (nonatomic, retain) UIBarButtonItem *composeButton;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation ProfileViewController


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count + 1;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat contentOffset = scrollView.contentOffset.y;
    
    if (contentOffset < 0) {
        self.headerHeightConstrant.constant = 150-contentOffset;
        
    }
    else {
        if (self.headerHeightConstrant > 0)
            self.headerHeightConstrant.constant = 150 - contentOffset;
        NSLog(@"Scrolling up, constraint %f, content offset %f.", self.tableViewTopConstraint.constant, contentOffset);
        //self.tableViewTopConstraint -=
        //self.tableViewTopConstraint.constant += contentOffset;
        
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row > 0) {
        ProfileViewController *vc = [[ProfileViewController alloc]init];
        vc.user = self.tweets[indexPath.row-1];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCell"];
        cell.followerCountLabel.text = [NSString stringWithFormat:@"%ld", self.user.followerCount];
        cell.followingCountLabel.text = [NSString stringWithFormat:@"%ld", self.user.followingCount];
        NSLog(@"Tagline: '%@'", self.user.tagline);
        cell.tweetCountLabel.text = [NSString stringWithFormat:@"%ld", self.user.tweetCount];
        cell.descriptionLabel.text = [NSString stringWithFormat: @"\"%@\"", self.user.tagline];
        [cell.userImage setImageWithURL:[NSURL URLWithString:self.user.profileImageURL]];
        cell.userImage.layer.shadowColor = [UIColor blackColor].CGColor;
        cell.userImage.layer.shadowOffset = CGSizeMake(2, 2);
        cell.userImage.layer.shadowOpacity = .96;
        cell.userImage.layer.shadowRadius = 3.0;
        cell.nameLabel.text = self.user.name;
        cell.handleLabel.text = [NSString stringWithFormat:@"@%@", self.user.screenname];
        return cell;
    }
    else {
        TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
        [cell loadTweet:self.tweets[indexPath.row - 1]];
        return cell;
    }
}

- (void) onLogoutButton{
    [User setCurrentUser:nil];
    [[TwitterClient sharedInstance].requestSerializer removeAccessToken];
    [[NSNotificationCenter defaultCenter] postNotificationName:USER_DID_LOGOUT_NOTIFICATION object:nil];
    //[self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void) onComposeButton {
    composerViewController *vc = [[composerViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (void)refreshTweets {
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.user.screenname, @"screen_name", [NSNumber numberWithInteger:1], @"include_rts", [NSNumber numberWithInteger:1], @"include_my_retweet", nil];
    [[TwitterClient sharedInstance] tweetsFromUserTimeline:params completion:^(NSArray *tweets, NSError *error) {
        self.tweets = tweets;
        [self.tableView reloadData];
    }];
    [self.refreshControl endRefreshing];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.user == nil) {
        self.user = [User currentUser];
    }
    
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];

    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.353 green:0.69 blue:1 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.Title = @"Profile";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    self.logoutButton =[[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onLogoutButton)];
    //self.navigationItem.leftBarButtonItem = self.logoutButton;
    
    self.composeButton =[[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(onComposeButton)];
    self.navigationItem.rightBarButtonItem = self.composeButton;
    

    
    if (self.user.headerURL != nil) {
        [self.headerImage setImageWithURL:[NSURL URLWithString:self.user.headerURL]];
    }

    //register nib
    [self.tableView registerNib:[UINib nibWithNibName:@"ProfileCell" bundle:nil] forCellReuseIdentifier:@"ProfileCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self refreshTweets];


    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [self refreshTweets];
    [self.tableView reloadData];
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
