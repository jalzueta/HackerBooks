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
@class FLGLibraryTableViewController;

@protocol FLGLibraryTableViewControllerDelegate <NSObject>

@optional
- (void) libraryTableViewController: (FLGLibraryTableViewController *) libraryTableViewController didSelectBook: (FLGBook *) book;

@end

@interface FLGLibraryTableViewController : UITableViewController<FLGLibraryTableViewControllerDelegate>

@property (strong, nonatomic) FLGLibrary *model;
@property (strong, nonatomic) FLGBook *selectedBook;
@property (nonatomic) BOOL showSelectedCell;

@property (weak, nonatomic) id <FLGLibraryTableViewControllerDelegate> delegate;

// Inicializador designado
- (id) initWithModel: (FLGLibrary *) model
        selectedBook: (FLGBook *) selectedBook
    showSelectedCell: (BOOL) showSelectedCell
               style: (UITableViewStyle) style;

@end
