//
//  FLGLibrary.h
//  HackerBooks
//
//  Created by Javi Alzueta on 30/3/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

@import Foundation;
@class FLGBook;

@interface FLGLibrary : NSObject

@property (nonatomic, strong) NSDictionary *booksForTagDict;
@property (nonatomic, strong) NSArray *booksArray;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, readonly) NSUInteger booksCount;
@property (nonatomic, readonly) NSUInteger tagsCount;

// Inicializador personalizado
- (id) initWithJsonData: (NSData *) jsonData error: (NSError *) error;

// metodos accesores para los elementos del modelo
- (NSString *) tagForIndex: (NSUInteger) index;
- (NSUInteger) bookCountForTag: (NSString *) tag;
- (NSArray *) booksForTag: (NSString *) tag;
- (NSArray *) sortedBooksForTag: (NSString *) tag;
- (FLGBook *) bookForTag: (NSString *) tag atIndex: (NSUInteger) index;

- (void) updateLibraryWithBook: (FLGBook *) book;
  
@end
