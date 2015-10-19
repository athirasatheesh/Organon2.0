//
//  SummaryCell.m
//  BookStore
//
//  Created by Rahul on 22/01/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SummaryCell.h"


@implementation SummaryCell
@synthesize summarylabel,chapterlabel;


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
	[chapterlabel release];
	[summarylabel release];
    [super dealloc];
}


@end
