//
//  FLGBookJSONDownloader.h
//  HackerBooks
//
//  Created by Javi Alzueta on 31/3/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLGBookJSONDownloader : NSObject

@property (strong, nonatomic) NSData *booksJSONData;
@property (strong, nonatomic) NSError *error;

// Init personalizado
- (id) initWithURL: (NSURL *) url;

@end
