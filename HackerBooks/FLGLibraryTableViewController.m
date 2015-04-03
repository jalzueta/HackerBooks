//
//  FLGLibraryTableViewController.m
//  HackerBooks
//
//  Created by Javi Alzueta on 31/3/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "FLGLibraryTableViewController.h"
#import "FLGLibrary.h"
#import "FLGBook.h"
#import "FLGBookViewController.h"
#import "FLGSandboxUtils.h"
#import "FLGConstants.h"
#import "FLGBookTableViewCell.h"

@interface FLGLibraryTableViewController ()

@end

@implementation FLGLibraryTableViewController

- (id) initWithModel: (FLGLibrary *) model
        selectedBook: (FLGBook *) selectedBook
    showSelectedCell: (BOOL) showSelectedCell
               style: (UITableViewStyle) style{
    
    if (self = [super initWithStyle:style]) {
        _model = model;
        _showSelectedCell = showSelectedCell;
        _selectedBook = selectedBook;
        self.title = @"Library";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Nos damos de alta en las notificaciones
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(notifyThatBookDidChangeItsContent:)
                   name:BOOK_DID_CHANGE_ITS_CONTENT_NOTIFICATION_NAME
                 object:nil];
    
    // Registramos el Nig de la celda personalizada
    UINib *nib = [UINib nibWithNibName:@"FLGBookTableViewCell"
                                bundle:[NSBundle mainBundle]];
    
    [self.tableView registerNib:nib
         forCellReuseIdentifier:[FLGBookTableViewCell cellId]];
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

#pragma mark - UITableViewControllerDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [self.model tagsCount];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.model bookCountForTag:[self.model.tags objectAtIndex:section]];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Averiguar de que modelo (libro) me está hablando
    FLGBook *book = [self.model bookForTag:[self.model.tags objectAtIndex:indexPath.section] atIndex:indexPath.row];
    
    // Crear una celda
    FLGBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FLGBookTableViewCell cellId]
                                                            forIndexPath:indexPath];
    
    // Seleccionamos la celda, si procede
    if (book == self.selectedBook && self.showSelectedCell) {
        [tableView selectRowAtIndexPath:indexPath
                               animated:YES
                         scrollPosition:UITableViewScrollPositionNone];
    }
    
    // Sincronizamos modelo (personaje) -> vista (celda)
    [cell configureWithBook: book];
    
    // Devolverla
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ([[self.model.tags objectAtIndex:section] isEqualToString:FAVOURITES_TAG]) {
        return 10.0;
    }
    return 0.0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30.0)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.tableView.frame.size.width - 40, 30.0)];
    titleLabel.text = [[self.model tagForIndex:section] capitalizedString];
    titleLabel.font = [UIFont fontWithName:@"Palatino-Bold" size:18.0];
    
    if ([[self.model.tags objectAtIndex:section] isEqualToString:FAVOURITES_TAG]) {
        titleLabel.textColor = [UIColor whiteColor];
        headerView.backgroundColor = FAVOURITE_HEADER_COLOR;
    }else{
        titleLabel.textColor = [UIColor whiteColor];
        headerView.backgroundColor = CATHEGORY_HEADER_COLOR;
    }
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [headerView addSubview:titleLabel];
    return headerView;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 10.0)];
    footerView.backgroundColor = [UIColor colorWithRed:77/255.0 green:173/255.0 blue:0/255.0 alpha:1.0];
    return footerView;
}


#pragma mark - UITableViewControllerDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Averiguar de qué modelo (personaje) me están hablando
    FLGBook *book = [self.model bookForTag:[self.model.tags objectAtIndex:indexPath.section] atIndex:indexPath.row];
    
    // Actualizo la property self.selectedBook para la actualizacion de la celda seleccionada
    self.selectedBook = book;
    
    // Avisar al delegado (siempre y cuando entienda el mensaje) -> bookViewController
    if ([self.delegate respondsToSelector:@selector(libraryTableViewController:didSelectBook:)]) {
        // Envio el mensaje al delegado
        [self.delegate libraryTableViewController:self didSelectBook:book];
    }
    
    // Mandamos una notificacion -> para avisar a pdfViewController
    NSNotification *note = [NSNotification notificationWithName:BOOK_DID_CHANGE_NOTIFICATION_NAME
                                                         object:self
                                                       userInfo:@{BOOK_KEY: book}];
    
    // Enviamos la notificacion
    [[NSNotificationCenter defaultCenter] postNotification:note];
    
    // Guardamos las coordenadas del ultimo personaje en NSUserDefaults
    NSArray *coords = @[[self.model.tags objectAtIndex:indexPath.section], @(indexPath.row)];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:coords forKey:LAST_SELECTED_BOOK];
    [def synchronize];
}

#pragma mark - FLGLibraryTableViewControllerDelegate

- (void) libraryTableViewController:(FLGLibraryTableViewController *)libraryTableViewController didSelectBook:(FLGBook *)book{
    
    // Creamos un BookVC
    FLGBookViewController *bookVC = [[FLGBookViewController alloc] initWithModel:book];
    
    // Hago un push
    [self.navigationController pushViewController:bookVC animated:YES];
}

#pragma mark - Notifications
// BOOK_DID_CHANGE_ITS_CONTENT_NOTIFICATION_NAME
- (void) notifyThatBookDidChangeItsContent: (NSNotification *) aNotification{
    
    // Sacamos el libro
    FLGBook *book = [aNotification.userInfo objectForKey:BOOK_KEY];
    
    // Actualizamos el modelo
    [self.model updateLibraryWithBook: book];
    
    // Sincronizamos modelo -> vista
    [self.tableView reloadData];
}

@end
