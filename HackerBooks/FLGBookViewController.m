//
//  FLGBookViewController.m
//  HackerBooks
//
//  Created by Javi Alzueta on 1/4/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "FLGBookViewController.h"
#import "FLGBook.h"
#import "FLGConstants.h"
#import "FLGPdfViewController.h"


@implementation FLGBookViewController

#pragma mark - Init

- (id) initWithModel: (FLGBook *) model{
    if (self = [super initWithNibName:nil
                               bundle:nil]) {
        _model = model;
    }
    return self;
}

#pragma mark - LifeCycle

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // Asegurarse de que no se ocupa toda la pantalla cuando se esta en un combinador
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // Sincronizo modelo -> vista(s)
    [self syncViewToModel];
    
    // Asignamos al navigationItem del controlador el boton del SplitViewController.
    self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)displayPdf:(id)sender {
    // Crear un pdfVC
    FLGPdfViewController *pdfVC = [[FLGPdfViewController alloc] initWithModel:self.model];
    
    // Hacer un push usando la propiedad "navigationController" que tiene todo UIViewController
    [self.navigationController pushViewController:pdfVC animated:YES];
}

- (IBAction)didPressFavourite:(id)sender {
    [self.model setIsFavourite: ![self.model isFavourite]];
    [self syncFavouriteValue];
    
    // Mandamos una notificacion -> para avisar a libraryVC
    NSNotification *note = [NSNotification notificationWithName:BOOK_DID_CHANGE_ITS_CONTENT_NOTIFICATION_NAME
                                                         object:self
                                                       userInfo:@{BOOK_KEY: self.model}];
    
    // Enviamos la notificacion
    [[NSNotificationCenter defaultCenter] postNotification:note];
}

#pragma mark - UISplitViewControllerDelegate

- (void) splitViewController:(UISplitViewController *)svc willChangeToDisplayMode:(UISplitViewControllerDisplayMode)displayMode{
    
    // Averiguar si la tabla se ve o no
    if (displayMode == UISplitViewControllerDisplayModePrimaryHidden) {
        self.navigationItem.leftBarButtonItem = svc.displayModeButtonItem;
    }else {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

#pragma mark - FLGLibraryTableViewControllerDelegate
- (void) libraryTableViewController:(FLGLibraryTableViewController *)libraryTableViewController didSelectBook:(FLGBook *)book{
    
    // Actualizamos el modelo
    self.model = book;
    
    // Sincronizamos modelo -> vista
    [self syncViewToModel];
}

#pragma mark - Utils
- (void) syncViewToModel{
    self.title = self.model.title;
    
    self.bookTitle.text = self.model.title;
    self.authors.text = [NSString stringWithFormat:@"Authors: %@", [self.model authorsAsString]];
    self.bookImage.image = [self.model bookImage];
    self.tags.text = [NSString stringWithFormat:@"Tags: %@", [self.model tagsAsString]];
    [self syncFavouriteValue];
}

- (void) syncFavouriteValue{
    if (self.model.isFavourite) {
        self.favouriteImage.image = [UIImage imageNamed:FAVOURITE_ON_IMAGE_NAME];
    } else{
        self.favouriteImage.image = [UIImage imageNamed:FAVOURITE_OFF_IMAGE_NAME];
    }
}


@end
