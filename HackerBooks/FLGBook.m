//
//  FLGBook.m
//  HackerBooks
//
//  Created by Javi Alzueta on 30/3/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "FLGBook.h"
#import "FLGSandboxUtils.h"
#import "FLGConstants.h"

@implementation FLGBook

#pragma mark - Properties

//- (NSURL *) imageURL{
//    return nil;
//}
//
//- (NSURL *) pdfURL{
//    return nil;
//}

#pragma mark - Properties


#pragma mark - Init
// designated init
- (id) initWithTitle: (NSString *)title
             authors: (NSArray *) authors
                tags: (NSArray *) tags
            imageURL: (NSURL *) imageURL
              pdfURL: (NSURL *) pdfURL
        savedInLocal: (BOOL) savedInLocal{
    
    if(self = [super init]){
        _title = title;
        _authors = authors;
        _tags = tags;
        _imageURL = imageURL;
        _pdfURL = pdfURL;
        _savedInLocal = savedInLocal;
    }
    return  self;
}

- (id) initWithTitle:(NSString *)title
             authors:(NSArray *)authors
                tags:(NSArray *)tags
            imageURL:(NSURL *)imageURL
              pdfURL:(NSURL *)pdfURL{
    
    
    return [self initWithTitle:title
                       authors:authors
                          tags:tags
                      imageURL:imageURL
                        pdfURL:pdfURL
                  savedInLocal:NO];
}

#pragma mark - Utils

- (NSString *) authorsAsString{
    return [self.authors componentsJoinedByString:@", "];
}

- (UIImage *) bookImage{
    
    // Otenemos el nombre del fichero de la imagen en servidor
    NSString *imageFileName = [self.imageURL lastPathComponent];
    
    // Obtenemos la URL completa del fichero de imagen
    NSURL *imageURL = [FLGSandboxUtils applicationDocumentsURLForFileName:imageFileName];
    
    return [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
}

- (UIImage *) favouriteImage{
    if (self.isFavourite) {
        return [UIImage imageNamed:FAVOURITE_ON_IMAGE_NAME];
    } else{
        return [UIImage imageNamed:FAVOURITE_OFF_IMAGE_NAME];
    }
}

- (void) setIsFavourite: (BOOL) isFavourite{
    
    NSMutableArray *tagsMutable = [self.tags mutableCopy];
    if (isFavourite) {
        [tagsMutable addObject:FAVOURITES_TAG];
    }else{
        [tagsMutable removeObject:FAVOURITES_TAG];
    }
    self.tags = tagsMutable;
}

- (BOOL) isFavourite{
    return [self.tags containsObject:FAVOURITES_TAG];
}

- (BOOL) isTheSameBook: (FLGBook *) book{
    return (self.title == book.title && self.authors == book.authors && self.imageURL == book.imageURL);
}

- (NSURL *) localPdfURL{
    if (!self.savedInLocal) {
        [self downloadAndSavePdf];
        
        // Mandamos una notificacion -> para avisar a bookViewController y a pdfViewController
        NSNotification *note = [NSNotification notificationWithName:BOOK_DID_CHANGE_ITS_CONTENT_NOTIFICATION_NAME
                                                             object:self
                                                           userInfo:@{BOOK_KEY: self}];
        
        // Enviamos la notificacion
        [[NSNotificationCenter defaultCenter] postNotification:note];
    }else{
        self.pdfURL = [FLGSandboxUtils applicationDocumentsURLForFileName:[self.pdfURL lastPathComponent]];
    }
    return self.pdfURL;
}

- (void) downloadAndSavePdf{
    
//    [FLGSandboxUtils downloadAndSavePdfForBook:self];
    NSURL *newPdfURL = [FLGSandboxUtils downloadAndSaveFileWithUrl:self.pdfURL];
    if (newPdfURL != self.pdfURL) {
        self.savedInLocal = YES;
        self.pdfURL = newPdfURL;
    }
}


@end
