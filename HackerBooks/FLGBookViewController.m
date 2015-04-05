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
#import "FLGVfrReaderViewController.h"


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
    
    // Configuro la vista de inicio
    [self configView];
    
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
    
//    [self launchPdfInWebview];
    
    [self launchVfrReader];
}

- (void) launchPdfInWebview{
    // Crear un pdfVC
    FLGPdfViewController *pdfVC = [[FLGPdfViewController alloc] initWithModel:self.model];
    
    // Hacer un push usando la propiedad "navigationController" que tiene todo UIViewController
    [self.navigationController pushViewController:pdfVC animated:YES];
}

- (void) launchVfrReader{
    // Crear un vfrReaderVC
    FLGVfrReaderViewController *vfrVC = [[FLGVfrReaderViewController alloc] initWithModel:self.model];
    
    // Hacer un push usando la propiedad "navigationController" que tiene todo UIViewController
//    [self presentViewController:vfrVC animated:YES completion:nil];
    [self.navigationController pushViewController:vfrVC animated:YES];
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
- (void) configView{
    self.bookImage.layer.shadowColor = [UIColor whiteColor].CGColor;
    self.bookImage.layer.masksToBounds = NO;
    self.bookImage.layer.shadowOffset = CGSizeMake(5, 5);
    self.bookImage.layer.shadowOpacity = 0.5;
    
    self.bookDataView.backgroundColor = SELECTED_CELL_BACKGROUND_COLOR;
}

- (void) syncViewToModel{
    self.title = self.model.title;
    
    self.bookTitle.text = self.model.title;
    self.authors.text = [NSString stringWithFormat:@"Authors: %@", [self.model authorsAsString]];
    self.backgroundBookImage.image = [self.model bookImage];
    self.bookImage.image = [self.model bookImage];
    self.tags.text = [NSString stringWithFormat:@"Tags: %@", [self.model tagsAsString]];
    self.savedOnDiskImage.hidden = !self.model.savedInLocal;
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
