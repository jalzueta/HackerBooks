//
//  FLGPdfViewController.m
//  HackerBooks
//
//  Created by Javi Alzueta on 2/4/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "FLGPdfViewController.h"
#import "FLGBook.h"
#import "FLGConstants.h"

@interface FLGPdfViewController ()

@end

@implementation FLGPdfViewController

#pragma mark - Init

- (id) initWithModel: (FLGBook *) model{
    if (self = [super initWithNibName:nil
                               bundle:nil]) {
        _model = model;
        self.title = @"PDF reader";
    }
    return self;
}

#pragma mark - LifeCycle

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // Asegurarse de que no se ocupa toda la pantalla cuando se esta en un combinador
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // Asigno delegados
    self.browser.delegate = self;
    
    // Nos damos de alta en las notificaciones
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(notifyThatBookDidChange:)
                   name:BOOK_DID_CHANGE_NOTIFICATION_NAME
                 object:nil]; // Quien es el sender de la notificacion: en este caso no da igual
    
    [self configBrowser];
    [self configViewBeforeLoadingPDF];
}

- (void) viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self syncViewToModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    // Paro y oculto el activityView
    [self.activityView setHidden:YES];
    [self.activityView stopAnimating];
    
    NSLog(@"Error en la carga: %@", error);
}

- (void) webViewDidFinishLoad:(UIWebView *)webView{
    
    // Paro y oculto el activityView
    [self.activityView setHidden:YES];
    [self.activityView stopAnimating];
}

#pragma mark - Notifications
// BOOK_DID_CHANGE_NOTIFICATION_NAME
- (void) notifyThatBookDidChange: (NSNotification *) aNotification{
    
    // Sacamos el personaje
    // no usar "valueForKey", ya que eso es para KVC. Para diccionarios se usa "objectForKey"
    FLGBook *book = [aNotification.userInfo objectForKey:BOOK_KEY];
    
    // Actualizamos el modelo
    self.model = book;
    
    // Sincronizamos modelo -> vista
    [self syncViewToModel];
}

#pragma mark - Utils

- (void) configBrowser{
    self.browser.scrollView.showsVerticalScrollIndicator = YES;
}

- (void) configViewBeforeLoadingPDF{
    [self.activityView setHidden:NO];
    [self.activityView startAnimating];
}

- (void) syncViewToModel{
    
    // Sincronizar modelo -> vista
    [self.activityView setHidden:NO];
    [self.activityView startAnimating];
    
    self.browser.delegate = self;
    
    NSURL *pdfURL = [self.model localPdfURL];
    [self.browser loadData:[NSData dataWithContentsOfURL:pdfURL]
                  MIMEType:@"application/pdf"
          textEncodingName:@"UTF-8"
                   baseURL:nil];
}

@end
