//
//  FLGBookJSONDownloader.m
//  HackerBooks
//
//  Created by Javi Alzueta on 31/3/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "FLGBookJSONDownloader.h"
#import "FLGBook.h"
#import "FLGJSONDict2BookParser.h"

@implementation FLGBookJSONDownloader

// Init personalizado
- (id) initWithURL: (NSURL *) url{
    if (self = [super init]) {
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLResponse *response = [[NSURLResponse alloc] init];
        NSError *error;
        NSData *data = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:&response
                                                         error:&error];
        _booksJSONData = data;
        _error = error;
    }
    return self;
}

@end
