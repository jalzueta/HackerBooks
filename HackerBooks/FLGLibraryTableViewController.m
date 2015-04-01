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
#import "FLGSandboxUtils.h"
#import "FLGConstants.h"

@interface FLGLibraryTableViewController ()

@end

@implementation FLGLibraryTableViewController

- (id) initWithModel: (FLGLibrary *) model
               style: (UITableViewStyle) style{
    
    if (self = [super initWithStyle:style]) {
        _model = model;
        self.title = @"Library";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [self.model tagsCount];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.model bookCountForTag:[self.model.tags objectAtIndex:section]];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Averiguar de que modelo (libro) me está hablando
    FLGBook *book = [self.model bookForTag:[self.model.tags objectAtIndex:indexPath.section] atIndex:indexPath.row];
    
    // Crear una celda
    static NSString *cellId = @"LibraryCell"; // al ser "static" solo se va a asignar la primera vez que se entre en este método. Las siguientes veces, simplemente se recuperará el valor guardado.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        // La tenemos que crear nosotros
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellId];
    }
    // Sincronizamos modelo (personaje) -> vista (celda)
//    cell.imageView.image = book.;
    cell.textLabel.text = book.title;
    cell.detailTextLabel.text = [book authorsAsString];
    cell.imageView.image = [book image];

    // Devolverla
    return cell;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return [self.model tagForIndex:section];
}


#pragma mark - Table view delegate

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


@end
