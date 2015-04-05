//
//  FLGVfrReaderViewController.m
//  HackerBooks
//
//  Created by Javi Alzueta on 5/4/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "FLGVfrReaderViewController.h"
#import "FLGBook.h"
#import "FLGConstants.h"

@interface FLGVfrReaderViewController ()

@end

@implementation FLGVfrReaderViewController

#pragma mark - Init

- (id) initWithModel: (FLGBook *) model{
    if (self = [super initWithNibName:nil
                               bundle:nil]) {
        _model = model;
        self.title = @"VFR reader";
    }
    return self;
}

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    // Asegurarse de que no se ocupa toda la pantalla cuando se esta en un combinador
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // Nos damos de alta en las notificaciones
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(notifyThatBookDidChange:)
                   name:BOOK_DID_CHANGE_NOTIFICATION_NAME
                 object:nil]; // Quien es el sender de la notificacion: en este caso no da igual
    
    NSString *file = [[NSBundle mainBundle] pathForResource:@"Reader" ofType:@"pdf"];
//    NSString *file = [[FLGSandboxUtils applicationDocumentsURLForFileName:@"Reader.pdf"] absoluteString];
    
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:file password:@"password"];
    if (document != nil)
    {
        self.readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
        [self.navigationController pushViewController:self.readerViewController animated:YES];
//        [self presentViewController:readerViewController animated:YES completion:nil];
        self.readerViewController.delegate = self;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Notifications
// BOOK_DID_CHANGE_NOTIFICATION_NAME
- (void) notifyThatBookDidChange: (NSNotification *) aNotification{
    
    // Sacamos el personaje
    FLGBook *book = [aNotification.userInfo objectForKey:BOOK_KEY];
    
    // Actualizamos el modelo
    self.model = book;
    
    // Sincronizamos modelo -> vista
    [self syncViewToModel];
}

#pragma mark - ReaderViewControllerDelegate
- (void) dismissReaderViewController:(ReaderViewController *)viewController{
    
    // si se ha usado "PushVC"
    [self.navigationController popViewControllerAnimated:YES];
    
    // si se ha usado "ModalVC"
//    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Utils

- (void) syncViewToModel{
    NSString *file = [[NSBundle mainBundle] pathForResource:@"Reader" ofType:@"pdf"];
//    NSString *file = [[FLGSandboxUtils applicationDocumentsURLForFileName:@"Reader.pdf"] absoluteString];
    
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:file password:@"password"];
    self.readerViewController.document = document;
}

@end
