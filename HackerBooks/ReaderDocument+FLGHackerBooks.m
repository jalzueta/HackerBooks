//
//  ReaderDocument+FLGHackerBooks.m
//  HackerBooks
//
//  Created by Javi Alzueta on 5/4/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "ReaderDocument+FLGHackerBooks.h"
#import "FLGSandboxUtils.h"

@implementation ReaderDocument (FLGHackerBooks)

+ (ReaderDocument *)withDocumentFileName:(NSString *)fileName password:(NSString *)phrase
{
    NSURL *filePath = [FLGSandboxUtils applicationDocumentsURLForFileName:fileName];
    
    NSError *err;
    BOOL fileExists = [filePath checkResourceIsReachableAndReturnError:&err];
    if (!fileExists) {
        NSLog(@"El PDF no existe: %@", err);
    }
    
    return [self withDocumentFilePath:[filePath absoluteString] password:phrase];
}


@end
