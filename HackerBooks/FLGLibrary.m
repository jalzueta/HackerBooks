//
//  FLGLibrary.m
//  HackerBooks
//
//  Created by Javi Alzueta on 30/3/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "FLGLibrary.h"
#import "FLGBook.h"
#import "FLGConstants.h"
#import "FLGJSONDict2BookParser.h"

@implementation FLGLibrary

#pragma mark - Inits
- (id) initWithData: (NSData *) booksJSONData error: (NSError *) error{
    if (self = [super init]) {
        
        _booksArray = [self booksArrayWithData:booksJSONData error:error];
        
        // Creo un diccionario en el que se guarda un array con todos los libros por cada tag
        NSMutableDictionary *booksForTagDictMutable = [[NSMutableDictionary alloc] init];
        
        // Creamos la tabla de tags
        NSMutableArray *tagsArrayMutable = [[NSMutableArray alloc] init];
        
         // Los poblamos segun los datos de los libros
        for (FLGBook *book in _booksArray) {
            for (NSString *tag in book.tags) {
                
                // Poblamos array de tags y diccionario de numero de libros por tag
                if (![tagsArrayMutable containsObject:tag]) {
                    [tagsArrayMutable addObject:tag];
                }
                
                // Poblamos diccionario de arrays de libros por tag
                NSArray *booksArrayForTag = [NSArray arrayWithArray:(NSArray *)[booksForTagDictMutable objectForKey:tag]];
                NSMutableArray *booksArrayForTagMutable = [booksArrayForTag mutableCopy];
                [booksArrayForTagMutable addObject:book];
                [booksForTagDictMutable setObject:booksArrayForTagMutable forKey:tag];
            }
        }
        _booksForTagDict = booksForTagDictMutable;
        
        // Ordenamos la tabla
        NSMutableArray *sortedTagsArray = [[tagsArrayMutable sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] mutableCopy];
        
        _tags = [NSArray arrayWithArray:sortedTagsArray];
    }
    return self;
}

#pragma mark - Accesors

- (NSUInteger) tagsCount{
    return [self.tags count];
}

- (NSString *) tagForIndex: (NSUInteger) index{
    
    return [self.tags objectAtIndex:index];
}


- (NSUInteger) bookCountForTag: (NSString *) tag{
    
    return [(NSArray *)[self.booksForTagDict objectForKey:tag] count];
}

- (NSArray *) booksForTag: (NSString *) tag{
    
    return (NSArray *)[self.booksForTagDict objectForKey:tag];
}

- (FLGBook *) bookForTag: (NSString *) tag atIndex: (NSUInteger) index{
    
    return [(NSArray *)[self.booksForTagDict objectForKey:tag] objectAtIndex:index];
}

#pragma mark - Utils

- (NSMutableArray *) booksArrayWithData: (NSData *) booksJSONData error: (NSError *) error{
    NSMutableArray *booksArrayMutable = [[NSMutableArray alloc] init];
    if (booksJSONData != nil) {
        //No ha habido error
        
        NSArray *JSONObjects = [NSJSONSerialization JSONObjectWithData:booksJSONData
                                                               options:kNilOptions
                                                                 error:&error];
        if (JSONObjects != nil) {
            //No ha habido error
            for (NSDictionary *dict in JSONObjects) {
                [booksArrayMutable addObject:[FLGJSONDict2BookParser bookFromJSONDict:dict]];
            }
        }
        else{
            //Se ha producido un error al parsear ael JSON
            NSLog(@"Error al parsear JSON: %@", error.localizedDescription);
        }
    }
    else{
        //Se ha producido un error al parsear ael JSON
        NSLog(@"Error al parsear JSON: %@", error.localizedDescription);
    }
    
    return booksArrayMutable;
}


@end
