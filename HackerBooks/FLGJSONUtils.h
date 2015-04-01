//
//  FLGJSONUtils.h
//  HackerBooks
//
//  Created by Javi Alzueta on 31/3/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

@import Foundation;
@class FLGBook;

@interface FLGJSONUtils : NSObject

+ (FLGBook *) bookFromJsonDict: (NSDictionary *) dict;
+ (NSDictionary *) jsonDictFromBook: (FLGBook *) book;

+ (NSMutableArray *) booksArrayWithJSONData: (NSData *) booksJSONData;
+ (NSData *) jsonDataWithBooksArray: (NSArray *) booksArray;

@end
