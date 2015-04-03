//
//  FLGSandboxUtils.h
//  HackerBooks
//
//  Created by Javi Alzueta on 1/4/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

@import Foundation;
@import UIKit;
@class FLGBook;

@interface FLGSandboxUtils : NSObject

+ (NSURL *) applicationDocumentsURLForFileName: (NSString *) filename;
+ (NSURL *) urlForJSONDataInSandbox;
+ (void) saveLibraryJson: (NSData *) jsonData;
+ (NSURL *) downloadAndSaveFileWithUrl: (NSURL *) remoteUrl;
+ (NSData *) downloadAndSaveLibraryImages: (NSData *) jsonData;
+ (FLGBook *) downloadAndSavePdfForBook: (FLGBook *) book;

@end
