//
//  AppDelegate.h
//  HackerBooks
//
//  Created by Javi Alzueta on 30/3/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

@import UIKit;
@class FLGLibrary;
@class FLGLibraryTableViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) FLGLibrary *library;
@property (strong, nonatomic) FLGLibraryTableViewController *libraryVC;


@end

