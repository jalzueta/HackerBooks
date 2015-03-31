//
//  FLGLibraryTableViewController.h
//  HackerBooks
//
//  Created by Javi Alzueta on 31/3/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FLGLibrary;

@interface FLGLibraryTableViewController : UITableViewController

@property (strong, nonatomic) FLGLibrary *model;

// Inicializador designado
- (id) initWithModel: (FLGLibrary *) model
               style: (UITableViewStyle) style;

@end
