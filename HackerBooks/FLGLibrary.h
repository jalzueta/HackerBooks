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

// Inicializador personalizado
- (id) initWithData: (NSData *) booksJSONData error: (NSError *) error;

// metodos accesores para los elementos del modelo
- (NSUInteger) tagsCount;
- (NSString *) tagForIndex: (NSUInteger) index;
- (NSUInteger) bookCountForTag: (NSString *) tag;
- (NSArray *) booksForTag: (NSString *) tag;
- (FLGBook *) bookForTag: (NSString *) tag atIndex: (NSUInteger) index;
  
@end
