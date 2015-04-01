//
//  FLGJSONUtils.m
//  HackerBooks
//
//  Created by Javi Alzueta on 31/3/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "FLGJSONUtils.h"
#import "FLGBook.h"
#import "FLGConstants.h"
#import "FLGSandboxUtils.h"

@implementation FLGJSONUtils

#pragma mark - FLGBook <-> NSdictionary

+ (FLGBook *) bookFromJsonDict: (NSDictionary *) dict{
    
    NSString *titleString = [dict objectForKey:TITLE_KEY];
    NSArray *authorsArray = [[dict objectForKey:AUTHORS_KEY] componentsSeparatedByString: @", "];
    NSArray *tagsArray = [[dict objectForKey:TAGS_KEY] componentsSeparatedByString: @", "];
    NSURL *imageURL = [NSURL URLWithString:[dict objectForKey:IMAGE_URL_KEY]];
    NSURL *pdfURL = [NSURL URLWithString:[dict objectForKey:PDF_URL_KEY]];
    
    return [[FLGBook alloc]initWithTitle: titleString
                                 authors: authorsArray
                                    tags: tagsArray
                                imageURL: imageURL
                                  pdfURL: pdfURL];
}

+ (NSDictionary *) jsonDictFromBook: (FLGBook *) book{
    
    return [[NSDictionary alloc] initWithObjects:@[book.title, [book.authors componentsJoinedByString:@", "], [book.tags componentsJoinedByString:@", "], [book.imageURL absoluteString], [book.pdfURL absoluteString]]
                                         forKeys:@[TITLE_KEY, AUTHORS_KEY, TAGS_KEY, IMAGE_URL_KEY, PDF_URL_KEY]];
}

#pragma mark - booksArray <-> JSONData

+ (NSMutableArray *) booksArrayWithJSONData: (NSData *) booksJSONData{
    NSMutableArray *booksArrayMutable = [[NSMutableArray alloc] init];
    NSError *err;
    if (booksJSONData != nil) {
        //No ha habido error
        id jsonObject = [NSJSONSerialization JSONObjectWithData:booksJSONData
                                                        options:kNilOptions
                                                          error:&err];
        if (jsonObject != nil) {
            // No ha habido error al parsear el JSON
            // comprueba si tenemos un array
            if ([jsonObject isKindOfClass:[NSArray class]]) {
                NSArray *JSONObjects = (NSArray *) jsonObject;
                for (NSDictionary *dict in JSONObjects) {
                    [booksArrayMutable addObject:[FLGJSONUtils bookFromJsonDict:dict]];
                }
            }else{
                NSDictionary *dict = (NSDictionary *) jsonObject;
                [booksArrayMutable addObject:[FLGJSONUtils bookFromJsonDict:dict]];
            }
        }else{
            // Se ha producido un error al parsear el JSON
            NSLog(@"Error al parsear JSON: %@", err.localizedDescription);
        }
    }
    else{
        //Se ha producido un error al parsear ael JSON
        NSLog(@"Error al descargar JSON: %@", err.localizedDescription);
    }
    
    return booksArrayMutable;
}

+ (NSData *) jsonDataWithBooksArray: (NSArray *) booksArray{
    
    NSData *jsonData;
    NSMutableArray *arrayOfDictsMutable = [[NSMutableArray alloc] init];
    
    if (booksArray) {
        for (FLGBook *book in booksArray) {
            // Convierto cada libro en un diccionario
            NSDictionary *dict = [self jsonDictFromBook:book];
            
            // Añado el diccionario a un array
            [arrayOfDictsMutable addObject:dict];
        }
        
        // Inicializo un array inmutable con el array obtenido de la iteracion anterior
        NSArray *arrayOfDicts = [NSArray arrayWithArray:arrayOfDictsMutable];
        NSError *err;
        
        // Convierto el array de diccionarios en un NSData
        if ([NSJSONSerialization isValidJSONObject:arrayOfDicts]) {
            jsonData = [NSJSONSerialization dataWithJSONObject:arrayOfDicts
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&err];
        }
    }
    return jsonData;
}


@end
