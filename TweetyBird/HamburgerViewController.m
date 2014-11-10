//
//  HamburgerViewController.m
//  TweetyBird
//
//  Created by Larry Wei on 11/9/14.
//  Copyright (c) 2014 Larry Wei. All rights reserved.
//

#import "HamburgerViewController.h"
#import "HomeViewController.h"
#import "UIImageView+AFNetworking.h"
#import "ProfileViewController.h"
#import "TwitterClient.h"

@interface HamburgerViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentContainerView;
@property (weak, nonatomic) IBOutlet UIView *menuContentView;

@property (weak, nonatomic) IBOutlet UIImageView *menuProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *menuUserName;
@property (weak, nonatomic) IBOutlet UILabel *menuUserHandle;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *viewControllers;
@property (strong, nonatomic) UINavigationController *currentViewController;

@end

@implementation HamburgerViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:25];
    cell.textLabel.textColor = [UIColor grayColor];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Profile";
            break;
        case 1:
            cell.textLabel.text = @"Timeline";
            break;
        case 2:
            cell.textLabel.text = @"Mentions";
            break;
        case 3:
            cell.textLabel.text = @"Logout";
            break;
    }
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.tableView.frame.size.height/4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < 2) {
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:self.viewControllers[indexPath.row]];
        self.currentViewController = nvc;
        self.currentViewController.view.frame = self.contentContainerView.bounds;
        [self.contentContainerView addSubview:self.currentViewController.view];
        
    }
    else if (indexPath.row == 3) {
        [User setCurrentUser:nil];
        [[TwitterClient sharedInstance].requestSerializer removeAccessToken];
        [[NSNotificationCenter defaultCenter] postNotificationName:USER_DID_LOGOUT_NOTIFICATION object:nil];
        //[self.navigationController dismissViewControllerAnimated:YES completion:nil];

    }
    [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:.8 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGRect frame = self.contentContainerView.frame;
        frame = self.view.frame;
        self.contentContainerView.frame = frame;
    } completion:^(BOOL finished) {
        NSLog(@"Finished animating");
    }];
}

- (void)viewDidLoad {
    
    //init view controllers
    ProfileViewController *profileVC = [[ProfileViewController alloc] init];
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    self.viewControllers = [NSArray arrayWithObjects:profileVC, homeVC, nil];
    
    [super viewDidLoad];
    ProfileViewController *vc = [[ProfileViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    self.currentViewController = nvc;
    self.currentViewController.view.frame = self.contentContainerView.bounds;
    [self.contentContainerView addSubview:self.currentViewController.view];
    
    //Set up menu
    [self setUpMenu];
    //tableview
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];

    // Do any additional setup after loading the view from its nib.
    
}

- (void) setUpMenu {
    User *user = [User currentUser];
    [self.menuProfileImage setImageWithURL: [NSURL URLWithString: user.profileImageURL]];
    [self.menuContentView setBackgroundColor: [UIColor colorWithRed:0.353 green:0.69 blue:1 alpha:.85]];
    self.menuProfileImage.layer.shadowColor = [UIColor blackColor].CGColor;
    self.menuProfileImage.layer.shadowOffset = CGSizeMake(2, 2);
    self.menuProfileImage.layer.shadowOpacity = .96;
    self.menuProfileImage.layer.shadowRadius = 3.0;
    self.menuUserName.text = user.name;
    self.menuUserHandle.text = [NSString stringWithFormat:@"@%@", user.screenname];
}
- (IBAction)onContentPanGesture:(UIPanGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:self.view];
    CGPoint velocity = [sender velocityInView:self.view];
    //CGPoint translation = [sender translationInView:self.view];
    NSLog(@"Point x: %f Point y: %f", point.x, point.y);
    NSLog(@"Velocity x: %f, Velocity y: %f", velocity.x, velocity.y);
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self setUpMenu];
    }
    else if (sender.state == UIGestureRecognizerStateChanged && point.x < self.menuContentView.frame.size.width) {
        CGRect frame = self.contentContainerView.frame;
        frame.origin.x += velocity.x/80;
        self.contentContainerView.frame = frame;
    }
    else if (sender.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:.8 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseIn animations:^{
            if (velocity.x < 0) {
                CGRect frame = self.contentContainerView.frame;
                frame = self.view.frame;
                self.contentContainerView.frame = frame;
                
            }
            else {
                CGRect frame = self.contentContainerView.frame;
                frame.origin.x = self.menuContentView.frame.size.width-10;
                self.contentContainerView.frame = frame;
                self.contentContainerView.layer.shadowColor = [UIColor blackColor].CGColor;
                self.contentContainerView.layer.shadowOffset = CGSizeMake(2, 2);
                self.contentContainerView.layer.shadowOpacity = .96;
                self.contentContainerView.layer.shadowRadius = 3.0;
            }
        } completion:^(BOOL finished) {
            NSLog(@"Finished animating");
        }];

    }
    
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
