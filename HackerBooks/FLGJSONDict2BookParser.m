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
    return [[FLGBook alloc]initWithTitle: [dict objectForKey:TITLE_KEY]
                                 authors: [dict objectForKey:AUTHORS_KEY]
                                    tags: [dict objectForKey:TAGS_KEY]
                                imageURL: [dict objectForKey:IMAGE_URL_KEY]
                                  pdfURL: [dict objectForKey:PDF_URL_KEY]];
}

@end
