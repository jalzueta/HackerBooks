//
//  FLGVfrReaderViewController.h
//  HackerBooks
//
//  Created by Javi Alzueta on 5/4/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReaderViewController.h"
@class FLGBook;

@interface FLGVfrReaderViewController : UIViewController<ReaderViewControllerDelegate>

@property (strong, nonatomic) FLGBook *model;

- (id) initWithModel: (FLGBook *) model;

@end
