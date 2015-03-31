//
//  FLGLibrary.m
//  HackerBooks
//
//  Created by Javi Alzueta on 30/3/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "FLGLibrary.h"
#import "FLGBook.h"

@implementation FLGLibrary

#pragma mark - Properties
- (NSUInteger) tagsCount{
    return self.tagsCount;
}

#pragma mark - Inits
- (id) initWithArrayOfBooks: (NSArray *) booksArray{
    if (self = [super init]) {
        _booksArray = booksArray;
    }
    return self;
}

#pragma mark - Accesors
- (NSArray *) tags{

    
}

- (NSUInteger) bookCountForTag: (NSString *) tag{
    
    
}

- (NSArray *) booksForTag: (NSString *) tag{
    
    
}

- (FLGBook *) bookForTag: (NSString *) tag atIndex: (NSUInteger) index{
    
    
}


@end
