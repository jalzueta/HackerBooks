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
        
        if (data != nil) {
            //No ha habido error
            
            NSArray *JSONObjects = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:kNilOptions
                                                                     error:&error];
            
            if (JSONObjects != nil) {
                //No ha habido error
                for (NSDictionary *dict in JSONObjects) {
                    [self.booksArray addObject:[FLGJSONDict2BookParser bookFromJSONDict:dict]];
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
        
    }
    return self;
}

@end
