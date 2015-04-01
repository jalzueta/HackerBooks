//
//  FLGBook.m
//  HackerBooks
//
//  Created by Javi Alzueta on 30/3/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "FLGBook.h"
#import "FLGSandboxUtils.h"

@implementation FLGBook

#pragma mark - Properties

//- (NSURL *) imageURL{
//    return nil;
//}
//
//- (NSURL *) pdfURL{
//    return nil;
//}

#pragma mark - Init

// designated init
- (id) initWithTitle:(NSString *)title
             authors:(NSArray *)authors
                tags:(NSArray *)tags
            imageURL:(NSURL *)imageURL
              pdfURL:(NSURL *)pdfURL{
    
    if(self = [super init]){
        _title = title;
        _authors = authors;
        _tags = tags;
        _imageURL = imageURL;
        _pdfURL = pdfURL;
    }
    return self;
}

#pragma mark - Utils

- (NSString *) authorsAsString{
    return [self.authors componentsJoinedByString:@", "];
}

- (UIImage *) image{
    
    // Otenemos el nombre del fichero de la imagen en servidor
    NSString *imageFileName = [self.imageURL lastPathComponent];
    
    // Obtenemos la URL completa del fichero de imagen
    NSURL *imageURL = [FLGSandboxUtils applicationDocumentsURLForFileName:imageFileName];
    
    return [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
}

@end
