//
//  ReaderDocument+FLGHackerBooks.h
//  HackerBooks
//
//  Created by Javi Alzueta on 5/4/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "ReaderDocument.h"

@interface ReaderDocument (FLGHackerBooks)

+ (ReaderDocument *)withDocumentFileName:(NSString *)fileName password:(NSString *)phrase;

@end
