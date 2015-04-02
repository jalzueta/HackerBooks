//
//  FLGBookViewController.h
//  HackerBooks
//
//  Created by Javi Alzueta on 1/4/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

@import UIKit;
@class FLGBook;
@class FLGBookViewController;

@protocol FLGBookViewControllerDelegate <NSObject>

@optional

- (void) bookViewController: (FLGBookViewController *) bookViewController didChangeBook: (FLGBook *) book;

@end

@interface FLGBookViewController : UIViewController<UISplitViewControllerDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *bookTitle;
@property (weak, nonatomic) IBOutlet UILabel *authors;
@property (weak, nonatomic) IBOutlet UIImageView *bookImage;
@property (weak, nonatomic) IBOutlet UITableView *tagsTableView;
@property (weak, nonatomic) IBOutlet UIImageView *favouriteImage;

@property (weak, nonatomic) id <FLGBookViewControllerDelegate> delegate;

@property (strong, nonatomic) FLGBook *model;

- (id) initWithModel: (FLGBook *) model;

- (IBAction)displayPdf:(id)sender;
- (IBAction)didPressFavourite:(id)sender;

@end
