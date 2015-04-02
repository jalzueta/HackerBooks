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
#import "FLGBook.h"
#import "FLGSandboxUtils.h"
#import "FLGConstants.h"
#import "FLGBookTableViewCell.h"

@interface FLGLibraryTableViewController ()

@end

@implementation FLGLibraryTableViewController

- (id) initWithModel: (FLGLibrary *) model
        selectedBook: (FLGBook *) selectedBook
               style: (UITableViewStyle) style{
    
    if (self = [super initWithStyle:style]) {
        _model = model;
        _selectedBook = selectedBook;
        self.title = @"Library";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Registramos el Nig de la celda personalizada
    UINib *nib = [UINib nibWithNibName:@"FLGBookTableViewCell"
                                bundle:[NSBundle mainBundle]];
    
    [self.tableView registerNib:nib
         forCellReuseIdentifier:[FLGBookTableViewCell cellId]];
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
    if (book == self.selectedBook) {
        [tableView selectRowAtIndexPath:indexPath
                               animated:YES
                         scrollPosition:UITableViewScrollPositionNone];
    }
    
    // Sincronizamos modelo (personaje) -> vista (celda)
    cell.title.text = book.title;
    cell.authors.text = [book authorsAsString];
    cell.bookImage.image = [book bookImage];
    cell.favouriteIcon.image = [book favouriteImage];
    

    // Devolverla
    return cell;
}

//- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    
//    return [[self.model tagForIndex:section] capitalizedString];
//}

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
    
    if ([[self.model.tags objectAtIndex:section] isEqualToString:FAVOURITES_TAG]) {
        titleLabel.textColor = [UIColor colorWithRed:0.0 green:83/255.0 blue:14/255.0 alpha:1.0];
        headerView.backgroundColor = [UIColor greenColor];
    }else{
        titleLabel.textColor = [UIColor darkGrayColor];
        headerView.backgroundColor = [UIColor lightGrayColor];
    }
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [headerView addSubview:titleLabel];
    return headerView;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 10.0)];
    footerView.backgroundColor = [UIColor greenColor];
    return footerView;
}


//- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    if ([[self.model.tags objectAtIndex:section] isEqualToString:FAVOURITES_TAG]) {
//        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30.0)];
//    }
//    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30.0)];
//}


#pragma mark - UITableViewControllerDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Averiguar de qué modelo (personaje) me están hablando
    FLGBook *book = [self.model bookForTag:[self.model.tags objectAtIndex:indexPath.section] atIndex:indexPath.row];
    
    // Mandamos una notificacion -> para avisar a bookViewController y a pdfViewController
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


#pragma mark - FLGBookViewControllerDelegate

- (void) bookViewController:(FLGBookViewController *)bookViewController didChangeBook:(FLGBook *)book{
    [self.model updateLibraryWithBook: book];
    [self.tableView reloadData];
}


@end
