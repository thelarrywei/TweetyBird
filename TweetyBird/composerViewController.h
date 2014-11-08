//
//  composerViewController.h
//  TweetyBird
//
//  Created by Larry Wei on 11/2/14.
//  Copyright (c) 2014 Larry Wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface composerViewController : UIViewController
@property (nonatomic, assign) long replyID;
@property (nonatomic, weak) NSString *replyHandle;

@end
