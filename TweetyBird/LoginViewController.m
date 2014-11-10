//
//  LoginViewController.m
//  TweetyBird
//
//  Created by Larry Wei on 10/29/14.
//  Copyright (c) 2014 Larry Wei. All rights reserved.
//

#import "LoginViewController.h"
#import "TwitterClient.h"
#import "HamburgerViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginViewController


- (IBAction)onLogin:(id)sender {
    
    [[TwitterClient sharedInstance] loginWithCompletion:^(User *user, NSError *error) {
        if (user != nil) {
            //[self beginSession];
            HamburgerViewController *vc = [[HamburgerViewController alloc] init];
            NSLog(@"Should launch new view controller");
            [self presentViewController:vc animated:YES completion:nil];
        }
        else {
            //TODO give some meaningful error
        }
    }];
    
    }


- (void)viewDidLoad {
    self.loginButton.layer.cornerRadius = 3.0;
    self.loginButton.clipsToBounds = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
