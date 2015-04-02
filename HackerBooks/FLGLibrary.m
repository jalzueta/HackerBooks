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
#import "FLGJSONUtils.h"

@implementation FLGLibrary

#pragma mark - Inits
- (id) initWithJsonData: (NSData *) jsonData error: (NSError *) error{
    if (self = [super init]) {
        
        _booksArray = [FLGJSONUtils booksArrayWithJSONData:jsonData];
        
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
        
        // Ordenamos la tabla alfabeticamente
        NSMutableArray *sortedTagsArray = [[tagsArrayMutable sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] mutableCopy];
        
        // Pasamos el tag "Favoritos" a la primera posicion de la tabla
        if ([sortedTagsArray containsObject:FAVOURITES_TAG]) {
            [sortedTagsArray removeObject:FAVOURITES_TAG];
            [sortedTagsArray insertObject:FAVOURITES_TAG atIndex:0];
        }
        
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
    
    return [[self booksForTag:tag] objectAtIndex:index];
}


#pragma mark - Utils

- (void) updateLibraryWithBook: (FLGBook *) book{
    
    // Se actualiza la lista de libros
    NSMutableArray *bookArrayMutable = [self.booksArray mutableCopy];
    for (int i=0; i<self.booksArray.count; i++) {
        if ([book isTheSameBook:[bookArrayMutable objectAtIndex:i]]) {
            [bookArrayMutable replaceObjectAtIndex:i withObject:book];
            break;
        }
    }
    self.booksArray = bookArrayMutable;
    
    // Se actualiza el resto del modelo con la lista de lisbros nueva
    [self updateModelWithBooksArray:self.booksArray];
    
}

- (void) updateModelWithBooksArray: (NSArray *) booksArray{
    // Creo un diccionario en el que se guarda un array con todos los libros por cada tag
    NSMutableDictionary *booksForTagDictMutable = [[NSMutableDictionary alloc] init];
    
    // Creamos la tabla de tags
    NSMutableArray *tagsArrayMutable = [[NSMutableArray alloc] init];
    
    // Los poblamos segun los datos de los libros
    for (FLGBook *book in booksArray) {
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
    self.booksForTagDict = booksForTagDictMutable;
    
    // Ordenamos la tabla alfabeticamente
    NSMutableArray *sortedTagsArray = [[tagsArrayMutable sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] mutableCopy];
    
    // Pasamos el tag "Favoritos" a la primera posicion de la tabla
    if ([sortedTagsArray containsObject:FAVOURITES_TAG]) {
        [sortedTagsArray removeObject:FAVOURITES_TAG];
        [sortedTagsArray insertObject:FAVOURITES_TAG atIndex:0];
    }
    
    self.tags = [NSArray arrayWithArray:sortedTagsArray];
}

@end
