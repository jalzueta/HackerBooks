//
//  FLGBookTableViewCell.m
//  HackerBooks
//
//  Created by Javi Alzueta on 2/4/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "FLGBookTableViewCell.h"
#import "FLGBook.h"
#import "FLGConstants.h"

@implementation FLGBookTableViewCell

+ (NSString *) cellId{
    return NSStringFromClass(self);
}

- (void)awakeFromNib {
    // Initialization code
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.frame];
    backgroundView.backgroundColor = SELECTED_CELL_BACKGROUND_COLOR;
    self.selectedBackgroundView = backgroundView;
}

- (void) prepareForReuse{
    // Reseteamos la celda para el reuso
//    [self setSelected:NO];
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureWithBook: (FLGBook *) book{
    self.title.text = book.title;
    self.authors.text = [book authorsAsString];
    self.bookImage.image = [book bookImage];
    self.favouriteIcon.image = [book favouriteImage];
    self.downloadIcon.hidden = !book.savedInLocal;
}

@end
