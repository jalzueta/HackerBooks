//
//  FLGBook.m
//  HackerBooks
//
//  Created by Javi Alzueta on 30/3/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "FLGBook.h"

@implementation FLGBook

#pragma mark - init

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

@end
