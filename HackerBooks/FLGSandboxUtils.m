//
//  FLGSandboxUtils.m
//  HackerBooks
//
//  Created by Javi Alzueta on 1/4/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "FLGSandboxUtils.h"
#import "FLGConstants.h"
#import "FLGBook.h"
#import "FLGJSONUtils.h"

@implementation FLGSandboxUtils

#pragma mark - JSON Data

+ (NSURL *) applicationDocumentsURL{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *urls = [fm URLsForDirectory:NSDocumentDirectory
                               inDomains:NSUserDomainMask];
    return [urls lastObject];
}

+ (NSURL *) applicationDocumentsURLForFileName: (NSString *) filename{
    
    // Se obtiene la URL de la carpeta donde se va a guardar el JSON
    NSURL * url = [self applicationDocumentsURL];
    
    // Añadir el componente del nombre del fichero
    url = [url URLByAppendingPathComponent:filename];
    return url;
}

+ (NSURL *) urlForJSONDataInSandbox{
    return [self applicationDocumentsURLForFileName:JSON_FILENAME];
}

+ (void) saveLibraryJson: (NSData *) jsonData{
    // Averigura la URL a la carpeta Caches
    NSURL *url = [self urlForJSONDataInSandbox];
    
    // Guardar algo
    NSError *err;
    BOOL rc = [jsonData writeToURL:url atomically:YES];
    
    // Comprobar que se guardó
    if (rc == NO) {
        // Hubo error al guardar
        NSLog( @"Error al guardar: %@", err.userInfo);
    }else{
        // No hubo error al guardar
        NSLog( @"JSON guardado correctamente");
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setObject:@"YES" forKey:IS_SAVED_JSON_DATA_KEY];
    }
}

+ (NSData *) downloadAndSaveLibraryImages: (NSData *) libraryJsonData{
   
    // Se obtiene el array de libros a partir del JSON de la libreria
    NSArray *booksArray = [FLGJSONUtils booksArrayWithJSONData:libraryJsonData];
    NSMutableArray *newBooksArray = [booksArray mutableCopy];
    
    // Se descargan las imagenes, se guardan en el Sandbox y se modifican las "imageURL" de los libros
    for (int i=0; i<[newBooksArray count]; i++) {
        
        // Se coge el libro correspondiente
        FLGBook *book = [newBooksArray objectAtIndex:i];
        
        // Se descarga la imagen de ese libro y se modifica la "imageURL" del mismo (local)
        book = [self downloadAndSaveImageForBook: book];
        
        // Se reemplaza el libro correspondiente con el libro "actualizado"
        [newBooksArray replaceObjectAtIndex:i withObject:book];
    }
    
    // Obtengo el json a partir del array de libros
    NSData *newLibraryJsonData = [FLGJSONUtils jsonDataWithBooksArray:newBooksArray];
    
    return newLibraryJsonData;
}

+ (FLGBook *) downloadAndSaveImageForBook: (FLGBook *) book{
    
    // Otenemos el nombre del fichero de la imagen en servidor
    NSString *imageFileName = [book.imageURL lastPathComponent];
    
    // Gestion de errores
    NSError *err;
    
    // Descarga de la imagen desde servidor
    NSData *imageData = [NSData dataWithContentsOfURL:book.imageURL];
    
    // Guarda la imagen en Documents
    NSURL *imageLocalURL = [self applicationDocumentsURLForFileName:imageFileName];
    BOOL rc = [imageData writeToURL:imageLocalURL
                            options:NSDataWritingAtomic
                              error:&err];
    
    if (rc) {
        // Guardado sin errores
        book.imageURL = imageLocalURL;
    }else{
        NSLog(@"Error al guardar la imagen: %@", err);
    }
    
    // Se devuelve el objeto "book" con la nueva "imageURL" (local)
    return book;
}

@end
