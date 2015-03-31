//
//  FLGLibrary.h
//  HackerBooks
//
//  Created by Javi Alzueta on 30/3/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FLGBook;

@interface FLGLibrary : NSObject

@property (nonatomic, strong) NSArray *booksArray;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, readonly) NSUInteger booksCount;
@property (nonatomic, readonly) NSUInteger tagsCount;

// Properties
- (NSArray *) tags;

// Inicializador personalizado
- (id) initWithArrayOfBooks: (NSArray *) booksArray;

// metodos accesores para los elementos del modelo
- (NSUInteger) bookCountForTag: (NSString *) tag;
- (NSArray *) booksForTag: (NSString *) tag;
- (FLGBook *) bookForTag: (NSString *) tag atIndex: (NSUInteger) index;
  
@end
