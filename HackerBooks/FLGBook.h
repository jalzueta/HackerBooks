//
//  FLGBook.h
//  HackerBooks
//
//  Created by Javi Alzueta on 30/3/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface FLGBook : NSObject

@property (copy, nonatomic) NSString *title;
@property (strong, nonatomic) NSArray *authors;
@property (strong, nonatomic) NSArray *tags;
@property (strong, nonatomic) NSURL *imageURL;
@property (strong, nonatomic) NSURL *pdfURL;
@property (nonatomic) BOOL savedInLocal;

// designated init
- (id) initWithTitle: (NSString *)title
             authors: (NSArray *) authors
                tags: (NSArray *) tags
            imageURL: (NSURL *) imageURL
              pdfURL: (NSURL *) pdfURL
        savedInLocal: (BOOL) savedInLocal;

- (id) initWithTitle: (NSString *)title
             authors: (NSArray *) authors
                tags: (NSArray *) tags
            imageURL: (NSURL *) imageURL
              pdfURL: (NSURL *) pdfURL;

- (NSString *) authorsAsString;
- (UIImage *) bookImage;
- (UIImage *) favouriteImage;
- (BOOL) isFavourite;
- (void) setIsFavourite: (BOOL) isFavourite;
- (BOOL) isTheSameBook: (FLGBook *) book;
- (NSURL *) localPdfURL;

@end
