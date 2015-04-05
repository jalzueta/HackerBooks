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
#import "FLGSandboxUtils.h"
#import "ReaderDocument+FLGHackerBooks.h"

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
                 object:nil];
    
//    NSString *file = [[NSBundle mainBundle] pathForResource:@"Reader" ofType:@"pdf"];
//    NSString *file = [[FLGSandboxUtils applicationDocumentsURLForFileName:[self.model.pdfURL lastPathComponent]] absoluteString];
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activity.center = self.view.center;
    [self.view addSubview:activity];
    [activity startAnimating];
    
    dispatch_queue_t pdf_download_and_save = dispatch_queue_create("pdf", 0);
    
    dispatch_async(pdf_download_and_save, ^{
        
        // Es el propio modelo "FLGBook" el que se encarga de hacer la descarga del pdf, si es necesario
        NSURL *pdfURL = [self.model localPdfURL];
        
        // se ejecuta en primer plano
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *fileName = [pdfURL lastPathComponent];
            
            ReaderDocument *document = [ReaderDocument withDocumentFileName:fileName password:nil];
            if (document != nil) {
                self.readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
                [self.navigationController pushViewController:self.readerViewController animated:YES];
                //        [self presentViewController:readerViewController animated:YES completion:nil];
                self.readerViewController.delegate = self;
            }
        });
    });
}

- (void) viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    // Nos damos de baja de las notificaciones
//    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
//    [center removeObserver:self];
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
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - Utils

- (void) syncViewToModel{

    [self.readerViewController archiveDocumentProperties];
    
    dispatch_queue_t pdf_download_and_save = dispatch_queue_create("pdf", 0);
    
    dispatch_async(pdf_download_and_save, ^{
        
        // Es el propio modelo "FLGBook" el que se encarga de hacer la descarga del pdf, si es necesario
        NSURL *pdfURL = [self.model localPdfURL];
        
        // se ejecuta en primer plano
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *fileName = [pdfURL lastPathComponent];
            
            ReaderDocument *document = [ReaderDocument withDocumentFileName:fileName password:nil];
            if (document != nil) {
                [self.readerViewController updateReaderWithDocument: document];
            }
        });
    });
}

@end
