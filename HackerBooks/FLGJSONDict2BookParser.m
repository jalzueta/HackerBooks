//
//  FLGJSONDict2BookParser.m
//  HackerBooks
//
//  Created by Javi Alzueta on 31/3/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "FLGJSONDict2BookParser.h"
#import "FLGBook.h"
#import "FLGConstants.h"

@implementation FLGJSONDict2BookParser

+ (FLGBook *) bookFromJSONDict: (NSDictionary *) dict{
    
    NSArray *authorsArray = [[dict objectForKey:AUTHORS_KEY] componentsSeparatedByString: @", "];
    NSArray *tagsArray = [[dict objectForKey:TAGS_KEY] componentsSeparatedByString: @", "];
    
    return [[FLGBook alloc]initWithTitle: [dict objectForKey:TITLE_KEY]
                                 authors: authorsArray
                                    tags: tagsArray
                                imageURL: [dict objectForKey:IMAGE_URL_KEY]
                                  pdfURL: [dict objectForKey:PDF_URL_KEY]];
}

@end
