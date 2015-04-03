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
    
    // Nos damos de alta en las notificaciones
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(notifyThatBookDidChange:)
                   name:BOOK_DID_CHANGE_NOTIFICATION_NAME
                 object:nil];
    
    // Asigno los delegados
    self.tagsTableView.dataSource = self;
    
    // Sincronizar model -> vista
    // Sincronizo modelo -> vista(s)
    [self syncViewToModel];
    
    // Asignamos al navigationItem del controlador el boton del SplitViewController.
    self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
}

- (void) viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
}

- (void) dealloc{
    // Nos damos de baja de las notificaciones
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
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
    
    // Mandamos una notificacion -> para avisar a bookViewController y a pdfViewController
    NSNotification *note = [NSNotification notificationWithName:BOOK_DID_CHANGE_ITS_CONTENT_NOTIFICATION_NAME
                                                         object:self
                                                       userInfo:@{BOOK_KEY: self.model}];
    
    // Enviamos la notificacion
    [[NSNotificationCenter defaultCenter] postNotification:note];
//    [self.delegate bookViewController:self didChangeBook:self.model];
}

#pragma mark - UISplitViewControllerDelegate

- (void) splitViewController:(UISplitViewController *)svc willChangeToDisplayMode:(UISplitViewControllerDisplayMode)displayMode{
    
    // Averiguar si la tabla se ve o no
    if (displayMode == UISplitViewControllerDisplayModePrimaryHidden) {
        // La tabla esta oculta y cuelga del boton
        // Ponemos ese boton en mi barra de navegación
        self.navigationItem.leftBarButtonItem = svc.displayModeButtonItem;
    }else {
        // Se muestra la tabla
        // Oculto el boton de la barra de navegacion
        self.navigationItem.leftBarButtonItem = nil;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.model.tags count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
    // Crear una celda
    static NSString *cellId = @"TagCell"; // al ser "static" solo se va a asignar la primera vez que se entre en este método. Las siguientes veces, simplemente se recuperará el valor guardado.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        // La tenemos que crear nosotros
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:cellId];
    }
    // Sincronizamos modelo (tag) -> vista (celda)
    cell.textLabel.text = [self.model.tags objectAtIndex:indexPath.row];
    
    // Devolverla
    return cell;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return @"TAGS";
}

#pragma mark - Notifications
// BOOK_DID_CHANGE_NOTIFICATION_NAME
- (void) notifyThatBookDidChange: (NSNotification *) aNotification{
    
    // Sacamos el libro
    FLGBook *book = [aNotification.userInfo objectForKey:BOOK_KEY];
    
    // Actualizamos el modelo
    self.model = book;
    
    // Sincronizamos modelo -> vista
    [self syncViewToModel];
}


#pragma mark - Utils
- (void) syncViewToModel{
    self.title = self.model.title;
    
    self.bookTitle.text = self.model.title;
    self.authors.text = [self.model authorsAsString];
    self.bookImage.image = [self.model bookImage];
    [self.tagsTableView reloadData];
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
