//
//  OrgImageView.m
//  BookStore
//
//  Created by Rahul on 22/01/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "OrgImageView.h"


@implementation OrgImageView


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}
- (void) setSkinImage: (UIImage *) anImage
{
	self.image = anImage;//[FFRoundRectImage maskedImage:anImage forSize: anImage.size ovalSize:CGSizeMake(radius,radius)]; //(8,8)
}
- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
    [super dealloc];
}


@end
