//
//  FLGJSONDict2BookParser.h
//  HackerBooks
//
//  Created by Javi Alzueta on 31/3/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FLGBook;

@interface FLGJSONDict2BookParser : NSObject

+ (FLGBook *) bookFromJSONDict: (NSDictionary *) dict;

@end
