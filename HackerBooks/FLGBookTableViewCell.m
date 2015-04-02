//
//  FLGBookTableViewCell.m
//  HackerBooks
//
//  Created by Javi Alzueta on 2/4/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "FLGBookTableViewCell.h"

@implementation FLGBookTableViewCell

+ (NSString *) cellId{
    return NSStringFromClass(self);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void) prepareForReuse{
    // Reseteamos la celda para el reuso
//    [self setSelected:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
