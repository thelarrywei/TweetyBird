//
//  HomeViewController.h
//  TweetyBird
//
//  Created by Larry Wei on 10/30/14.
//  Copyright (c) 2014 Larry Wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetCell.h"

@interface HomeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, TweetCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
