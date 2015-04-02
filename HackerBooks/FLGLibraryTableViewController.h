//
//  FLGLibraryTableViewController.h
//  HackerBooks
//
//  Created by Javi Alzueta on 31/3/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

@import UIKit;
@class FLGLibrary;
@class FLGBook;
#import "FLGBookViewController.h"

@interface FLGLibraryTableViewController : UITableViewController<FLGBookViewControllerDelegate>

@property (strong, nonatomic) FLGLibrary *model;
@property (strong, nonatomic) FLGBook *selectedBook;

// Inicializador designado
- (id) initWithModel: (FLGLibrary *) model
        selectedBook: (FLGBook *) selectedBook
               style: (UITableViewStyle) style;

@end
